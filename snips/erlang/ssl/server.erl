#!/usr/bin/env escript
-module(server).

-export([main/1]).

-define(Log(A),                (fun(P) -> io:format("[~p:~p#~p] ~p~n",     [?MODULE, ?FUNCTION_NAME, ?LINE, P]), P end)(A)).
-define(Log(A, B),             io:format("[~p:~p#~p] ~p ~p~n",             [?MODULE, ?FUNCTION_NAME, ?LINE, A, B            ])).
-define(Log(A, B, C),          io:format("[~p:~p#~p] ~p ~p ~p~n",          [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C         ])).
-define(Log(A, B, C, D),       io:format("[~p:~p#~p] ~p ~p ~p ~p~n",       [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D      ])).
-define(Log(A, B, C, D, E),    io:format("[~p:~p#~p] ~p ~p ~p ~p ~p~n",    [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E   ])).
-define(Log(A, B, C, D, E, F), io:format("[~p:~p#~p] ~p ~p ~p ~p ~p ~p~n", [?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F])).

main(_) ->
    ?Log(main),
    start().

start() ->
    ok = ssl:start(),
    ?Log(start),
    {ok, Listen} = ssl:listen(3000, [{certfile,"/keys/cert.pem"}, {keyfile, "/keys/privkey.pem"}, {reuseaddr, true}]),
    ?Log(listen),
    {ok, Socket} = ssl:transport_accept(Listen),
    ?Log(transport_accept),
    ssl:ssl_accept(Socket),
    ?Log(accept),
    loop(Socket).

loop(Socket) ->
    ?Log(loop),
    receive
        {ssl, Socket, Data} ->
            ?Log(Data),
            ssl:send(Socket, Data),
            loop(Socket);
        {ssl_closed, Socket} ->
            ?Log(closed);
        Error ->
            ?Log(Error)
    end.

