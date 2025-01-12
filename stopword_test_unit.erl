-module(stopword_test_unit).
-include_lib("eunit/include/eunit.hrl").

% Retorna lista vazia para apenas stopwords
main_only_stopwords_test() ->
    Input = "stopwords_only.txt",
    Case = "sensivel",
    StopWords = ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"],
    Expected = [],
    ?assertEqual(Expected, stopword:main(Input, Case, StopWords)).

% Comporta-se corretamente com palavras repetidas
circular_displacement_repeated_words_test() ->
    Line = "the cat and the dog",
    MainWord = "the",
    Expected = "the cat and the dog",  
    ?assertEqual(Expected, stopword:createCircularDisplacement(Line, MainWord)).

% Funciona de forma insensível a maiúsculas/minúsculas
main_insensivel_test() ->
    Input = "word.txt",
    Case = "insensivel",
    StopWords = ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"],
    Expected =["brown cat sat A","brown fox The quick","brown The cat is",
            "cat is brown The","cat sat A brown","fox The quick brown",
            "quick brown fox The","sat A brown cat"],
    ?assertEqual(Expected, stopword:main(Input, Case, StopWords)).

% Funciona de forma sensível a maiúsculas/minúsculas
main_sensivel_test() ->
    Input = "word.txt", 
    Case = "sensivel",
    StopWords = ["a", "the", "and", "of", "an", "to", "in", "on", "is", "are", "they", "he", "she"],
    Expected = ["brown The cat is","brown cat sat A","brown fox The quick",
              "cat is brown The","cat sat A brown","fox The quick brown",
              "quick brown fox The","sat A brown cat"],  
    ?assertEqual(Expected, stopword:main(Input, Case, StopWords)).