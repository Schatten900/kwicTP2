-module(stopword_test_int).
-include_lib("eunit/include/eunit.hrl").

% Teste para a função createCircularDisplacement/2
createCircularDisplacement_test() ->
    % Teste para quando a mainword existe na string
    ?assertEqual("functional programming language Erlang is a", stopword:createCircularDisplacement("Erlang is a functional programming language", "functional")),
    
    % Teste para quando a mainword existe na string    
    ?assertEqual("Erlang is a functional programming language",stopword:createCircularDisplacement("Erlang is a functional programming language", "notfound")).

% Teste para a função concurrencyWords/2
concurrencyWords_test() ->
    % Define as stop words e o texto de entrada
    StopWords = ["is", "a", "the"],
    Line = "This is a test line with words",
    ParentPid = self(),  % O processo atual será o "pai"

    % Cria um processo para executar concurrencyWords/2
    Pid = spawn(fun() -> stopword:concurrencyWords(StopWords, []) end),

    % Envia uma mensagem para o processo
    Pid ! {Line, ParentPid},

    % Aguarda a resposta do processo filho
    receive
        {circular, CircularDisplacement} ->
            % Define o resultado esperado
            ExpectedResult = [
                      "This is a test line with words",
                      "test line with words This is a",
                      "line with words This is a test",
                      "with words This is a test line",
                      "words This is a test line with"
                    ],

            % Verifica se o resultado corresponde ao esperado
            ?assertEqual(ExpectedResult, CircularDisplacement)
    after 5000 ->
        % Falha o teste se não houver resposta em 5 segundos
        ?assert(false, "Timeout while waiting for response from child process")
    end.

% Função de teste para collectResults/2
collectResults_test() ->
    % Defina o número de mensagens esperadas
    N = 3,
    ParentPid = self(),  % O processo atual será o "pai"
    
    % Cria os processos filhos e envia as mensagens
    spawn(fun() -> ParentPid ! {circular, "Result 1"} end),
    spawn(fun() -> ParentPid ! {circular, "Result 2"} end),
    spawn(fun() -> ParentPid ! {circular, "Result 3"} end),
    
    % Chama a função collectResults/2 com N = 3
    CollectedResults = stopword:collectResults(N, []),
    
    % Verifica se os resultados coletados são os esperados
    ExpectedResults = ["Result 3", "Result 2", "Result 1"],
    
    % Valida se os resultados coletados estão corretos
    ?assertEqual(CollectedResults, ExpectedResults).

% Função de teste para addToTheList/2
% Função de teste para addToTheList/2
addToTheList_test() ->
    % Caso 1: Lista original vazia
    Ans1 = stopword:addToTheList([], []),
    ?assertEqual(Ans1, []),  % Espera-se uma lista vazia como resultado

    % Caso 2: Lista original com um único elemento
    Ans2 = stopword:addToTheList([["quick", "brown", "fox"]], []),
    ?assertEqual(Ans2, ["quick", "brown", "fox"]),  % Espera-se que o elemento 1 seja mantido

    % Caso 3: Lista original com múltiplos elementos
    Ans3 = stopword:addToTheList([["quick", "brown", "fox"],["Jumped", "over", "lazy", "dog"], ["Erlang", "is", "a", "functional", "programming", "language"]], []),
    ?assertEqual(Ans3, ["Erlang", "is", "a", "functional", "programming", "language", "Jumped", "over", "lazy", "dog", "quick", "brown", "fox"]).  % Espera-se que o elemento 1 seja mantido

