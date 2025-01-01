-module(stopword).
-export([main/1]).
-import(lists,[sort/1]).

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


main(FileName)->
    %make the stopwords be dinamic as parameter for main function
    StopWords = ["a","the","and","of","an","to","in","on","is","are","they","he","she"],
    case file:read_file(FileName) of
        {ok,Content} ->
            Lines = string:tokens(binary_to_list(Content),"\n"),
            ParentPid = self(),

            %to each line call the process
            lists:foreach(fun(Line) -> createPid(Line, StopWords, ParentPid) end, Lines),

            %Take all messages sent to PidParent
            GeneralList = collectResults(length(Lines),[]),

            %Sort result
            Ans = addToTheList(GeneralList, []),
            SortedList = lists:sort(Ans),
            io:fwrite("Resulted: ~p~n", [SortedList]),
            ok;

        {error,Reason} ->
            io:fwrite("Error occuried: ~n~s", [Reason])
    end.