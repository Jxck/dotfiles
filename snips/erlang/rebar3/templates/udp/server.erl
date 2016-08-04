-module({{name}}_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% API exports
-export([start_link/1]).

-include("records.hrl").
-include("logger.hrl").

%%====================================================================
%% API functions
%%====================================================================

start_link(State) ->
  ?Log(State),
  gen_server:start_link({local, ?MODULE}, ?MODULE, State, []).

%%====================================================================
%% Application callbacks
%% http://erlang.org/doc/man/gen_server.html
%%
%% gen_server module            Callback module
%% -----------------            ---------------
%% gen_server:start
%% gen_server:start_link -----> Module:init/1
%%
%% gen_server:stop       -----> Module:terminate/2
%%
%% gen_server:call
%% gen_server:multi_call -----> Module:handle_call/3
%%
%% gen_server:cast
%% gen_server:abcast     -----> Module:handle_cast/2
%%
%% -                     -----> Module:handle_info/2
%%
%% -                     -----> Module:terminate/2
%%
%% -                     -----> Module:code_change/3
%%====================================================================

init(State) ->
    ?Log(State),
    {ok, Socket} = gen_udp:open(State#state.port, [binary]),
    {ok, State#state{socket=Socket}}.


handle_call(Request, From, State) ->
    ?Log(Request, From, State),
    Response = Request,
    {reply, Response, State}.


handle_cast(Request, State) ->
    ?Log(Request, State),
    {noreply, State}.


handle_info(Info, State) ->
    ?Log(Info, State),
    {noreply, State}.


terminate(Reason, State) ->
    ?Log(Reason, State).


code_change(Old, State, Extra) ->
    ?Log(Old, State, Extra),
    {ok, State}.


%%====================================================================
%% Internal functions
%%====================================================================
