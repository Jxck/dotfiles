#!/usr/bin/env escript
-module(main).

-mode(compile).
-compile(export_all).

-define(Log(A),                (fun(P) -> io:format("[~p:~p#~p] ~p~n",     [?MODULE, ?FUNCTION_NAME, ?LINE, P]), P end)(A)).
-define(Log(A, B),             io:format("[~p:~p#~p] ~p ~p~n",             [?MODULE, ?FUNCTION_NAME, ?LINE, A, B            ])).
-define(Log(A, B, C),          io:format("[~p:~p#~p] ~p ~p ~p~n",          [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C         ])).
-define(Log(A, B, C, D),       io:format("[~p:~p#~p] ~p ~p ~p ~p~n",       [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D      ])).
-define(Log(A, B, C, D, E),    io:format("[~p:~p#~p] ~p ~p ~p ~p ~p~n",    [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E   ])).
-define(Log(A, B, C, D, E, F), io:format("[~p:~p#~p] ~p ~p ~p ~p ~p ~p~n", [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F])).

main(_) ->
    ?Log(hello, world).
