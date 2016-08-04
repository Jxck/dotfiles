%%%-------------------------------------------------------------------
%% @doc {{name}} top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module({{name}}_sup).

-behaviour(supervisor).

%% API
-export([start_link/1, start_child/0]).

%% Supervisor callbacks
-export([init/1]).

-include("records.hrl").
-include("logger.hrl").

%%====================================================================
%% API functions
%%====================================================================

start_link(State) ->
    ?Log(State),
    supervisor:start_link({local, ?MODULE}, ?MODULE, State).

start_child() ->
    supervisor:start_child(?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init(State) ->
    ?Log(State),
    spawn_link(fun start_child/0),
    Restart = {
      simple_one_for_one, %% restart strategy
      5,   %% max restart
      3600 %% max time
     },
    Server = {
      {{name}}_server, %% child id
      { {{name}}_server, start_link, [State] }, %% MFA for start
      permanent, %% restart(permanent, temporary, transient)
      5000, %% shutdown timeout
      worker, %% type(worker, supervisor)
      [ {{name}}_server ] %% module (optional) default to M for MFA
     },
    {ok, {Restart, [Server]}}.

%%====================================================================
%% Internal functions
%%====================================================================
