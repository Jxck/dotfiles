%%%-------------------------------------------------------------------
%% @doc {{name}} public API
%% @end
%%%-------------------------------------------------------------------

-module({{name}}_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("records.hrl").
-include("logger.hrl").

%%====================================================================
%% API functions
%%====================================================================

%%====================================================================
%% Application callbacks
%% http://erlang.org/doc/design_principles/applications.html#id80468
%%====================================================================

start(StartType, StartArgs) ->
    ?Log(StartType, StartArgs),
    {ok, Port} = application:get_env({{name}}, port),
    {{name}}_sup:start_link(#state{port=Port}).

stop(State) ->
    ?Log(State),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
