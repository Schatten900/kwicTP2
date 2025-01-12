-module(stopword).
-export([main/3]).
-export([createCircularDisplacement/2]).
-export([concurrencyWords/2]).
-export([collectResults/2]).
-export([addToTheList/2]).
-import(lists,[sort/1, sort/2]).

createCircularDisplacement(Line, MainWord) ->
    Words = string:tokens(Line, " \t\n"),     
    case lists:member(MainWord, Words) of
        true ->
            % Split the list in two, the sentence before and after the mainWord
            {Before, [MainWord | After]} = lists:splitwith(fun(X) -> X =/= MainWord end, Words),
            %io:fwrite("Before: ~p~n",[Before]),
            %io:fwrite("After: ~p~n",[After]),
            string:join([MainWord | After ++ Before], " "); 
        false ->
            io:fwrite("The main word was not detected... ~p~n",[Line]),
            Line 
    end.

%Will create a circular displacements general list
concurrencyWords(StopWords, GeneralList)->
    receive 
        {Line,PidParent}->
            Words = string:tokens(Line," \t\r\n"),

            %Remove stopWords
            FilteredWords = [Word || Word <- Words, not lists:member(string:lowercase(Word), StopWords)],
            %io:fwrite("Filtered words: ~p~n",[FilteredWords]),

            %Logic to create a circular displacement list
            CircularDisplacement= lists:map(
            fun(Word) -> createCircularDisplacement(Line, Word) end,
                FilteredWords
            ),

            %Send the list of circularDisplacements to Pid father

            PidParent ! {circular,CircularDisplacement},
            concurrencyWords(StopWords,GeneralList);

    _Other ->
        io:fwrite("Don't implemented yet\n"),
        concurrencyWords(StopWords,GeneralList)
    end.

%To each line, create a process
createPid(Line,StopWords,ParentPid)->
    Pid = spawn(fun() -> concurrencyWords(StopWords,[]) end),
    Pid ! {Line,ParentPid}.

%Collect every son process
collectResults(0,Ans) -> Ans;
collectResults(N,Ans) ->
    receive
        {circular,CircularDisplacement} -> 
            collectResults(N-1,[CircularDisplacement | Ans])
    end.


addToTheList([], Ans) -> Ans;
addToTheList([Hd | Tl], Ans) ->
   addToTheList(Tl, Hd ++ Ans). 


main(FileName, Case, StopWords) ->
    % Lista de exemplo
    case file:read_file(FileName) of
        {ok, Content} ->
            %Lines = string:tokens(binary_to_list(Content), "\n"), % Linux
            Lines = [string:strip(Line, right, $\r) || Line <- string:tokens(binary_to_list(Content), "\n")], % Windows
            ParentPid = self(),

            % Para cada linha, cria um processo
            lists:foreach(fun(Line) -> createPid(Line, StopWords, ParentPid) end, Lines),

            % Coleta todos os resultados
            GeneralList = collectResults(length(Lines), []),

            % Decide qual sort usar com base no valor de Case
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

            % Arquivo de saida
            case file:open("output.txt", [write]) of
                {ok, File} ->
                    lists:foreach(fun(Line) -> file:write(File, Line ++ "\n") end, SortedList),
                    file:close(File),
                    io:fwrite("Results written to output.txt~n");
                {error, Reason} ->
                    io:fwrite("Failed to open output file: ~p~n", [Reason])
            end,
            
            %io:fwrite("Sorted list: ~p~n", [SortedList]),
            SortedList;

        {error, Reason} ->
            io:fwrite("Error occurred: ~s~n", [Reason])
    end.