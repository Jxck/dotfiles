#!/usr/bin/env escript
-module(format).

-mode(compile).
-compile(export_all).
-behaviour(gen_statem).
-include("logger.hrl").

init(Arg) ->
    {ok, title, Arg}.

callback_mode() ->
    state_functions.

terminate(_Reason, _State, _Data) ->
    void.

code_change(_Vsn, State, Data, _Extra) ->
    {ok, State, Data}.


start() ->
    gen_statem:start({local, ?MODULE}, ?MODULE, "", []).

stop() ->
    gen_statem:stop(?MODULE).

call(Data) ->
    gen_statem:call(?MODULE, Data).

title({call, From}, {header, Line}, _State) ->
    State = _State ++ Line,
    {next_state, intro, State, [{reply, From, State}]}.

intro({call, From}, {br, Line}, _State) ->
    State = _State ++ Line,
    {next_state, intro, State, [{reply, From, State}]};

intro({call, From}, {header, Line}, _State) ->
    State = _State ++ Line,
    {next_state, body, State, [{reply, From, State}]}.

body({call, From}, {header, Line}, _State) ->
    State = _State ++ "\n\n" ++ Line,
    {keep_state, State, [{reply, From, State}]};

body({call, From}, {p, Line}, _State) ->
    State = _State ++ "\n" ++ Line,
    {keep_state, State, [{reply, From, State}]};

body({call, From}, {ul, Line}, _State) ->
    State = _State ++ "\n" ++ Line,
    {next_state, ul, State, [{reply, From, State}]};

body({call, From}, {ol, Line}, _State) ->
    State = _State ++ "\n" ++ Line,
    {next_state, ol, State, [{reply, From, State}]};

body({call, From}, {num, Line}, _State) ->
    State = _State ++ "\n" ++ Line,
    {next_state, num, State, [{reply, From, State}]};

body({call, From}, {code, Line}, _State) ->
    State = _State ++ "\n\n" ++ Line,
    {next_state, code, State, [{reply, From, State}]};

body({call, From}, {table, Line}, _State) ->
    State = _State ++ "\n\n" ++ Line,
    {next_state, table, State, [{reply, From, State}]};

body({call, From}, {br, _}, State) ->
    {keep_state, State, [{reply, From, State}]}.




ul({call, From}, {ul, Line}, _State) ->
    State = _State ++ Line,
    {keep_state, State, [{reply, From, State}]};

ul({call, From}, _, State) ->
    {next_state, body, State, [{reply, From, State}, postpone]}.


ol({call, From}, {ol, Line}, _State) ->
    State = _State ++ Line,
    {keep_state, State, [{reply, From, State}, postpone]};

ol({call, From}, _, State) ->
    {next_state, body, State, [{reply, From, State}]}.


num({call, From}, {num, Line}, _State) ->
    State = _State ++ Line,
    {keep_state, State, [{reply, From, State}]};

num({call, From}, _, State) ->
    {next_state, body, State, [{reply, From, State}, postpone]}.


code({call, From}, {code, Line}, _State) ->
    State = _State ++ Line,
    {next_state, body, State, [{reply, From, State}]};

code({call, From}, {_, Line}, _State) ->
    State = _State ++ Line,
    {keep_state, State, [{reply, From, State}]}.

table({call, From}, {table, Line}, _State) ->
    State = _State ++ Line,
    {keep_state, State, [{reply, From, State}]};

table({call, From}, {_, Line}, _State) ->
    State = _State ++ Line,
    {next_state, body, State, [{reply, From, State}]}.



%% labeling token
label(Line) ->
    label(Line, br).

label(Line, br) ->
    case Line =:= "\n" of
        true -> {br, Line};
        false -> label(Line, header)
    end;

label(Line, header) ->
    case re:run(Line, "^#{1,6} .*") of
        {match, _} -> {header, Line};
        nomatch -> label(Line, ul)
    end;

label(Line, ul) ->
    case re:run(Line, "^ *- .*") of
        {match, _} -> {ul, Line};
        nomatch -> label(Line, ol)
    end;

label(Line, ol) ->
    case re:run(Line, "^ *\\+ .*") of
        {match, _} -> {ol, Line};
        nomatch -> label(Line, num)
    end;

label(Line, num) ->
    case re:run(Line, "^ *\\d+\\. .*") of
        {match, _} -> {num, Line};
        nomatch -> label(Line, code)
    end;

label(Line, code) ->
    case re:run(Line, "```.*") of
        {match, _} -> {code, Line};
        nomatch -> label(Line, table)
    end;

label(Line, table) ->
    case re:run(Line, "^\\|") of
        {match, _} ->
            {table, Line};
        nomatch -> label(Line, p)
    end;

label(Line, p) ->
    {p, Line}.


%% tokenize
token(<<"\n", Rest/binary>>, Curr, Acc) ->

    Line = binary_to_list(<<Curr/binary, "\n">>),

    Labeled = label(Line),

    token(Rest, <<>>, [Labeled | Acc]);

token(<<C, Rest/binary>>, Curr, Acc) ->
    token(Rest, <<Curr/binary, C>>, Acc);

token(<<>>, <<>>, Acc) ->
    lists:reverse(Acc).

token(Bin) ->
    token(Bin, <<>>, []).


main([File]) ->
    {ok, Bin} = file:read_file(File),

    Lines = (token(Bin)),

    start(),

    lists:foreach(fun(Line) ->
                          call(Line)
                  end, Lines),


    Result = call({br, "\n"}),

    file:write_file(File, Result),
    io:format("~s", [Result]),

    ok.
