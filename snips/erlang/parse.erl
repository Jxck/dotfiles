-module(parse).
-behaviour(gen_fsm).

-compile([export_all]).
-record(frame, {key, len, value}).

start_link(Bin) ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, Bin, []).

next() ->
    gen_fsm:send_event(?MODULE, {next}).

init(Bin) ->
    io:format("~p~n", [Bin]),
    {ok, key, {Bin, #frame{}}}.

key({next}, {Bin, Frame}) ->
    io:format("key ~p ~p~n", [Bin, Frame]),
    {Key, Rest} = parse(Bin, []),
    {next_state, len, {Rest, Frame#frame{key=Key}}}.

len({next}, {Bin, Frame}) ->
    io:format("len ~p ~p~n", [Bin, Frame]),
    {Len, Rest} = parse(Bin, []),
    {next_state, value, {Rest, Frame#frame{len=list_to_integer(Len)}}}.

value({next}, {Bin, Frame}) ->
    io:format("value ~p ~p~n", [Bin, Frame]),
    {Value, Rest} = parse(Bin, []),
    process_frame(Frame#frame{value=Value}),
    {next_state, key, {Rest, #frame{}}}.

process_frame(Frame) ->
    io:format("~p~n", [Frame]).

parse(<<>>, Field) ->
    {Field, <<>>};
parse(<<" ", Rest/binary>>, []) ->
    parse(Rest, []);
parse(<<" ", Rest/binary>>, Field) ->
    {lists:reverse(Field), Rest};
parse(<<Char, Rest/binary>>, Field) ->
    parse(Rest, [Char|Field]).

main() ->
    start_link(<<"set 4 vvvv">>),
    next(),
    next(),
    next(),
    next().








%-----------------------------------------------------------------------------------
% Async events (All).
%-----------------------------------------------------------------------------------
handle_event(reset, _StateName, _State) ->
    io:format("Async reset...~n").

%-----------------------------------------------------------------------------------
% Sync events (All).
%-----------------------------------------------------------------------------------
handle_sync_event(reset, _From, _StateName, _State) ->
    io:format("Sync reset...~n").

%-----------------------------------------------------------------------------------
% Regular OTP messages.
%-----------------------------------------------------------------------------------
handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

