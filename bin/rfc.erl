#!/usr/bin/env escript
-module(rfc).

-mode(compile).
-compile(export_all).
-behaviour(gen_statem).
-include("logger.hrl").


-define(SP, <<" ">>).
-define(BR, <<"\n">>).

trim(Bin) ->
    list_to_binary(string:trim(binary_to_list(Bin))).

cat(Bin1, Bin2) ->
    <<Bin1/binary, ?SP/binary, Bin2/binary>>.

join(Bin1, Bin2) ->
    <<Bin1/binary, Bin2/binary, ?BR/binary>>.

join(Bin1, Bin2, br) ->
    <<Bin1/binary, Bin2/binary, ?BR/binary, ?BR/binary>>.

callback_mode() ->
    state_functions.

terminate(_Reason, _State, _Data) ->
    void.

code_change(_Vsn, State, Data, _Extra) ->
    {ok, State, Data}.


start() ->
    gen_statem:start({local, ?MODULE}, ?MODULE, #{ acc => <<>>, buf => <<>>}, []).

stop() ->
    gen_statem:stop(?MODULE).


init(Arg) ->
    {ok, start, Arg}.

start({call, From}, <<>>, State) ->
    {keep_state, State, [{reply, From, State}]};

start({call, From}, Line, State) ->
    {next_state, header, State, [{postpone, true}]}.


header({call, From}, <<>>, State) ->
    {next_state, title, State, [{postpone, true}]};

header({call, From}, Line, #{acc := Acc}=_State) ->
    State = _State#{acc := join(Acc, Line)},
    {keep_state, State, [{reply, From, State}]}.



title({call, From}, <<>>, State) ->
    {keep_state, State, [{reply, From, State}]};

title({call, From}, Line, #{acc := Acc}=_State) ->
    H1 = <<"# ", (trim(Line))/binary>>,
    State = _State#{acc := join(Acc, H1)},
    {next_state, p, State, [{reply, From, State}]}.



br({call, From}, <<>>, State) ->
    {keep_state, State, [{reply, From, State}]};

br({call, From}, _, State) ->
    {next_state, p, State, [{postpone, true}]}.



% abstract
p({call, From}, <<"Abstract">>=Line, #{acc := Acc}=_State) ->
    State = _State#{acc := join(Acc, <<"## Abstract\n">>)},
    {next_state, br, State, [{reply, From, State}]};

% status
p({call, From}, <<"Status of This Memo">>, #{acc := Acc}=_State) ->
    State = _State#{acc := join(Acc, <<"## Status of This Memo\n">>)},
    {next_state, br, State, [{reply, From, State}]};

% copyright
p({call, From}, <<"Copyright Notice">>, #{acc := Acc}=_State) ->
    State = _State#{acc := join(Acc, <<"## Copyright Notice\n">>)},
    {next_state, br, State, [{reply, From, State}]};

% 目次、そのあとは toc に飛ぶ
p({call, From}, <<"Table of Contents">>, #{acc := Acc}=_State) ->
    State = _State#{acc := join(Acc, <<"## Table of Contents\n">>)},
    {next_state, toc, State, [{reply, From, State}]};

% code などのブロックは 3 以上の indent なので buffer がなければそのままつなぐ
p({call, From}, <<"    ", _Line/binary>>=Line, #{acc := Acc, buf := <<>>}=_State) ->
    State = _State#{acc := join(Acc, Line), buf := <<>>},
    {keep_state, State, [{reply, From, State}]};

% buffer があれば定義リストなどなので、 buffer と一緒につなぐ
p({call, From}, <<"    ", _Line/binary>>=Line, #{acc := Acc, buf := Buf}=_State) ->
    State = _State#{acc := join(Acc, <<Buf/binary, ?BR/binary, Line/binary>>), buf := <<>>},
    {keep_state, State, [{reply, From, State}]};

% 普通のブロックは 3 indent なので buffer にまとめる
p({call, From}, <<"   ", Line/binary>>, #{buf := Buf}=_State) ->
    State = _State#{buf := cat(Buf, Line)},
    {keep_state, State, [{reply, From, State}]};

% 改ページは消す
p({call, From}, <<"\f">>, State) ->
    {keep_state, State, [{reply, From, State}]};

% 改ページ後の最初の行
p({call, From}, <<"RFC ", _/binary>>, State) ->
    {keep_state, State, [{reply, From, State}]};

% ブロックが終わる改行なので、そこまでの buf をつなぐ
p({call, From}, <<>>, #{acc := Acc, buf := Buf}=_State) ->
    State = _State#{acc := join(Acc, trim(Buf), br), buf := <<>>},
    {next_state, br, State, [{reply, From, State}]};


p({call, From}, _Line, #{acc := Acc}=_State) ->
    Line = case h(_Line) of
               {h, L} -> L;
               _Line ->
                   case re:run(_Line, <<".* Standards Track .*">>) of
                       {match, _} -> <<>>;
                       nomatch -> _Line
                   end
           end,
    State = _State#{acc := join(Acc, Line)},
    {keep_state, State, [{reply, From, State}]}.


% toc start
toc({call, From}, <<>>, #{buf := <<>>}=State) ->
    {keep_state, State, [{reply, From, State}]};

% toc end
toc({call, From}, <<>>, #{acc := Acc, buf := Buf}=_State) ->
    State = _State#{acc := join(Acc, Buf), buf := <<>>},
    {next_state, br, State, [{reply, From, State}]};

% toc body
toc({call, From}, Line, #{buf := Buf}=_State) ->
    State = _State#{buf := join(Buf, Line)},
    {keep_state, State, [{reply, From, State}]}.



h(L) ->
    case (re:run(L, <<"^(\\d)+\\. ">>)) of
        {match, _} -> {h, <<"# ", L/binary>>};
        nomatch -> h2(L)
    end.

h2(L) ->
    case (re:run(L, <<"^(\\d)+\\.(\\d)+\\. ">>)) of
        {match, _} -> {h, <<"## ", L/binary>>};
        nomatch -> h3(L)
    end.

h3(L) ->
    case (re:run(L, <<"^(\\d)+\\.(\\d)+\\.(\\d)+\\. ">>)) of
        {match, _} -> {h, <<"### ", L/binary>>};
        nomatch -> h4(L)
    end.

h4(L) ->
    case (re:run(L, <<"^(\\d)+\\.(\\d)+\\.(\\d)+\\.(\\d)+\\. ">>)) of
        {match, _} -> {h, <<"#### ", L/binary>>};
        nomatch -> L
    end.



main([File]) ->
    {ok, Bin} = file:read_file(File),

    %Lines = (token(Bin)),
    Lines = (binary:split(Bin, [<<"\n">>], [global])),
    start(),

    Result = lists:map(fun(Line) ->
                               (gen_statem:call(?MODULE, Line))
                       end, Lines),

    io:format("~s~n", [maps:get(acc, lists:last(Result))]),

    %file:write_file(File, lists:last(Result)),
    %io:format("~s", [lists:last(Result)]),

    ok.

