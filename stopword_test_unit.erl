-module(stopword_test_unit).
-include_lib("eunit/include/eunit.hrl").

% Testando a função main/2 com diferentes valores para Case
main_sensivel_test() ->
    % Caso sensível a maiúsculas/minúsculas
    Input = "word.txt",  % Suponha que "file.txt" contém o texto necessário
    Case = "sensivel",
    StopWords = ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"],
    Expected = ["brown The cat is","brown cat sat A","brown fox The quick",
              "cat is brown The","cat sat A brown","fox The quick brown",
              "quick brown fox The","sat A brown cat"],  % Exemplo esperado para este caso
    ?assertEqual(Expected, stopword:main(Input, Case, StopWords)).

main_insensivel_test() ->
    % Caso sensível a maiúsculas/minúsculas
    Input = "word.txt",  % Suponha que "file.txt" contém o texto necessário
    Case = "insensivel",
    StopWords = ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"],
    Expected =["brown cat sat A","brown fox The quick","brown The cat is",
            "cat is brown The","cat sat A brown","fox The quick brown",
            "quick brown fox The","sat A brown cat"],  % Exemplo esperado para este caso
    ?assertEqual(Expected, stopword:main(Input, Case, StopWords)).

