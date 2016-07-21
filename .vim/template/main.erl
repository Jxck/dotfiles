-module(main).

-export([
         main/0
        ]).

-define(p(A1), io:format("[~p:~p] ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1])).
-define(p(A1, A2), io:format("[~p:~p] ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2])).
-define(p(A1, A2, A3), io:format("[~p:~p] ~p ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2, A3])).
-define(p(A1, A2, A3, A4), io:format("[~p:~p] ~p ~p ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2, A3, A4])).

main() ->
    ?p(hello, world).
