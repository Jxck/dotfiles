#!/usr/bin/env escript
-module(client).

-export([main/1]).

-define(Log(A),                (fun(P) -> io:format("[~p:~p#~p] ~p~n",     [?MODULE, ?FUNCTION_NAME, ?LINE, P]), P end)(A)).
-define(Log(A, B),             io:format("[~p:~p#~p] ~p ~p~n",             [?MODULE, ?FUNCTION_NAME, ?LINE, A, B            ])).
-define(Log(A, B, C),          io:format("[~p:~p#~p] ~p ~p ~p~n",          [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C         ])).
-define(Log(A, B, C, D),       io:format("[~p:~p#~p] ~p ~p ~p ~p~n",       [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D      ])).
-define(Log(A, B, C, D, E),    io:format("[~p:~p#~p] ~p ~p ~p ~p ~p~n",    [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E   ])).
-define(Log(A, B, C, D, E, F), io:format("[~p:~p#~p] ~p ~p ~p ~p ~p ~p~n", [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F])).

main([]) ->
    ?Log("argument required!!");

main(Arg) ->
    client(Arg).

client(Message) ->
    ?Log(Message),
    ssl:start(),
    {ok, Socket} = ssl:connect("localhost", 3000,  []),
    ?Log(connect),
    ok = ssl:send(Socket, Message),
    ?Log(send, Message),
    receive
        {ssl, Socket, Data} ->
            ?Log(Data);
        Error ->
            ?Log(Error)
    end,
    ssl:close(Socket).
