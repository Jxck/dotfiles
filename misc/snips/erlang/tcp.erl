-module(tcp).
-export([start/1, start_link/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-behaviour(gen_server).
-record(connection, {socket, header}).
-define(Log(Format, Args), io:format("[~p:~p] " Format "~n", [?MODULE, ?LINE] ++ Args)).

start(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, once}, {packet, 0}]),
    start_link(ListenSocket).

start_link(Listen) ->
    ?Log("tcp_serv:start_link(~p)", [Listen]),
    gen_server:start_link(?MODULE, Listen, []).

init(Listen) ->
    ?Log("tcp_serv:init(~p)", [Listen]),
    gen_server:cast(self(), accept),
    {ok, Listen}.

handle_call(Message, From, State) ->
    ?Log("handle_call: ~p ~p ~p", [Message, From, State]),
    {noreply, State}.

handle_cast(accept, Listen) ->
    %% ここで accept する
    {ok, Socket} = gen_tcp:accept(Listen),
    ?Log("accept: ~p", [inet:peername(Socket)]),
    %% 接続ごとにプロセスを立てる
    tcp_sup:start_socket(),
    {noreply, #connection{socket=Socket}}.

handle_info({tcp, Socket, Data}, State) ->
    ?Log("recv bin: ~p ~p ~p",[Data, Socket, State]),
    send(Socket, Data),
    {noreply, State};

handle_info({tcp_closed, Socket}, State) ->
    ?Log("tcp_closed: ~p", [Socket]),
    {stop, normal, State};

handle_info({tcp_error, Socket, Reason}, State) ->
    ?Log("tcp_error: ~p ~p", [inet:peername(Socket), Reason]),
    {stop, normal, State};

handle_info(Err, State) ->
    ?Log("unexpected: ~p ~p", [Err, State]),
    {noreply, State}.

terminate(Reason, State) ->
    ?Log("terminate ~p: ~p", [Reason, State]).

code_change(Old, State, Extra) ->
    ?Log("code_change: ~p ~p", [Old, Extra]),
    {ok, State}.

%% 中間が active once で、 inet:setopts か listen するときに {active, once} を指定
%% 1 メッセージだけ active に push され、自動で passive になる
%% 各メッセージの受信で {active once} に戻し、コントロールする
send(Socket, Data) ->
    ?Log("send ~p ~p", [Socket, Data]),
    ok = gen_tcp:send(Socket, Data),
    ok = inet:setopts(Socket, [{active, once}]).
