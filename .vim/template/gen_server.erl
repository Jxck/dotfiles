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


-behaviour(gen_server).

init(Seq) ->
    ?Log(Seq),
    process_flag(trap_exit, true),
    {ok, #{seq => Seq}}.

terminate(Reason, State) ->
    ?Log(Reason, State),
    ok.

code_change(OldVsn, State, Extra) ->
    ?Log(OldVsn, State, Extra),
    {ok, State}.


handle_cast({delta, N}, #{seq := Seq}=State) ->
    {noreply, State#{seq := Seq + N}}.

handle_call(get, _From, #{seq := Seq}=State) ->
    {reply, Seq, State}.

handle_info(Msg, State) ->
    ?Log(Msg, State),
    {noreply, State}.



%% main
main(_) ->
    ?Log(gen_server:start_link({local, ?MODULE}, ?MODULE, 0, [])),
    ?Log(gen_server:cast(?MODULE, {delta, 2})),
    ?Log(gen_server:call(?MODULE, get)),
    ?Log(gen_server:cast(?MODULE, {delta, 4})),
    ?Log(gen_server:call(?MODULE, get)),
    ?Log(gen_server:stop(?MODULE)),
    ok.
