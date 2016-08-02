%%%-------------------------------------------------------------------
%% @doc {{name}} top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module({{name}}_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(Log(Args), io:format("[~p:~p#~p] ~p~n", [?MODULE, ?FUNCTION_NAME, ?LINE, Args])).

%%====================================================================
%% API functions
%%====================================================================

start_link(State) ->
    ?Log([State]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, State).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init(State) ->
    ?Log([State]),
    {ok,
     {
      {
       simple_one_for_one, %% restart strategy
       0, %% max restart
       1  %% max time
      },
      [
       {
        worker, %% child id
        {worker, start_link, []}, %% MFA for start
        permanent, %% restart(permanent, temporary, transient)
        5000, %% shutdown timeout
        worker %% type(worker, supervisor)
        %% module (optional) default to M for MFA
       }
      ]
     }
    }.

%%====================================================================
%% Internal functions
%%====================================================================
