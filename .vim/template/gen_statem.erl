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


-behaviour(gen_statem).

init(Seq) ->
    ?Log(Seq),
    process_flag(trap_exit, true),
    {ok, hello, #{seq => Seq}}.

callback_mode() ->
    [
     state_functions,
     state_enter
    ].

terminate(Reason, State, Data) ->
    ?Log(Reason, State, Data),
    ok.

code_change(OldVsn, State, Data, _Extra) ->
    ?Log(OldVsn, State, Data, _Extra),
    {ok, State, Data}.


hello(enter, _OldState, State) ->
    {keep_state, State};

hello(timeout, _, #{seq := Seq} = State) ->
    {keep_state, State#{seq := 0}};

hello(cast, {delta, N}, #{seq := Seq} = State) ->
    {next_state, hello, State#{seq := Seq+N}};

hello({call, From}, get, #{seq := Seq} = State) ->
    {next_state, hello, State, [{reply, From, Seq}]};

hello(internal, EventContent, Data) ->
    ?Log(internal, EventContent, Data),
    keep_state_and_data;

hello(EventType, EventContent, Data) ->
    ?Log(EventType, EventContent, Data),
    keep_state_and_data.


%% Main %%
main(_) ->
    ?Log(gen_statem:start_link({local, ?MODULE}, ?MODULE, 0, [])).
    ?Log(gen_statem:cast(?MODULE, {delta, 2})),
    ?Log(gen_statem:call(?MODULE, get)),
    ?Log(gen_statem:cast(?MODULE, {delta, 4})),
    ?Log(gen_statem:call(?MODULE, get)),
    ?Log(gen_statem:stop(?MODULE)).
    ok.
