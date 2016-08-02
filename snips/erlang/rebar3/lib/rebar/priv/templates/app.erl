%%%-------------------------------------------------------------------
%% @doc {{name}} public API
%% @end
%%%-------------------------------------------------------------------

-module({{name}}_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-define(Log(Args), io:format("[~p:~p#~p] ~p~n", [?MODULE, ?FUNCTION_NAME, ?LINE, Args])).

%%====================================================================
%% API functions
%%====================================================================

%%====================================================================
%% Application callbacks
%% http://erlang.org/doc/design_principles/applications.html#id80468
%%====================================================================

start(StartType, StartArgs) ->
    ?Log([StartType, StartArgs]),
    {{name}}_sup:start_link(StartArgs).

%%--------------------------------------------------------------------
stop(State) ->
    ?Log([State]),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
