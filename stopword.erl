-module(stopword).
-export([main/4, createCircularDisplacement/3, concurrencyWords/3, collectResults/2, addToTheList/2]).
-import(lists, [sort/1, sort/2]).

% Função para criar o deslocamento circular de uma palavra, considerando a janela de contexto
createCircularDisplacement(Line, MainWord, WindowSize) ->
    Words = string:tokens(Line, " \t\n"),     
    case lists:member(MainWord, Words) of
        true ->
            % Divide a lista em duas partes: antes e depois da palavra principal
            {Before, [MainWord | After]} = lists:splitwith(fun(X) -> X =/= MainWord end, Words),

            % Seleciona uma janela de contexto ao redor da palavra principal
            BeforeWindow = lists:sublist(lists:reverse(Before), min(WindowSize, length(Before))),
            AfterWindow = lists:sublist(After, min(WindowSize, length(After))),
            Context = lists:reverse(BeforeWindow) ++ [MainWord] ++ AfterWindow,

            % Junta as palavras em uma única string
            string:join(Context, " "); 
        false ->
            io:fwrite("The main word was not detected... ~p~n", [Line]),
            Line 
    end.

% Função para criar deslocamentos circulares de palavras não pertencentes à lista de stopWords
concurrencyWords(StopWords, WindowSize, GeneralList)->
    receive 
        {Line, PidParent} ->
            Words = string:tokens(Line, " \t\r\n"),

            % Remove stopWords
            FilteredWords = [Word || Word <- Words, not lists:member(string:lowercase(Word), StopWords)],

            % Lógica para criar a lista de deslocamentos circulares
            CircularDisplacement = lists:map(
                fun(Word) -> createCircularDisplacement(Line, Word, WindowSize) end,
                FilteredWords
            ),

            % Envia a lista de deslocamentos circulares ao processo pai
            PidParent ! {circular, CircularDisplacement},
            concurrencyWords(StopWords, WindowSize, GeneralList);

    _Other ->
        io:fwrite("Not implemented yet\n"),
        concurrencyWords(StopWords, WindowSize, GeneralList)
    end.

% Cria processos para cada linha do arquivo
createPid(Line, StopWords, WindowSize, ParentPid) ->
    Pid = spawn(fun() -> concurrencyWords(StopWords, WindowSize, []) end),
    Pid ! {Line, ParentPid}.

% Coleta os resultados de todos os processos filhos
collectResults(0, Ans) -> Ans;
collectResults(N, Ans) ->
    receive
        {circular, CircularDisplacement} -> 
            collectResults(N-1, [CircularDisplacement | Ans])
    end.

% Adiciona listas aninhadas a uma única lista
addToTheList([], Ans) -> Ans;
addToTheList([Hd | Tl], Ans) ->
    addToTheList(Tl, Hd ++ Ans). 

% Função principal que lê o arquivo, cria os processos e exibe o resultado ordenado
main(FileName, Case, StopWords, WindowSize) ->
    % Lê o arquivo de entrada
    case file:read_file(FileName) of
        {ok, Content} ->
            Lines = string:tokens(binary_to_list(Content), "\n"),
            ParentPid = self(),

            % Para cada linha, cria um processo
            lists:foreach(fun(Line) -> createPid(Line, StopWords, WindowSize, ParentPid) end, Lines),

            % Coleta os resultados
            GeneralList = collectResults(length(Lines), []),
            
            % Decide qual ordenação usar com base no valor de Case
            Ans = addToTheList(GeneralList, []),
            SortedList = 
                if
                    Case == "sensivel" -> 
                        sort(Ans);
                    Case == "insensivel" -> 
                        sort(fun(A, B) -> string:lowercase(A) =< string:lowercase(B) end, Ans);
                    true -> 
                        io:fwrite("Invalid case option~n"),
                        Ans
                end,

            % Exibe a lista ordenada
            io:fwrite("Sorted list: ~p~n", [SortedList]),
            SortedList;

        {error, Reason} ->
            io:fwrite("Error occurred: ~s~n", [Reason])
    end.