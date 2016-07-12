-module(fsm).

-behaviour(gen_fsm).

-export([start_link/1]).
-export([init/1, first_state/2, first_state/3, second_state/3, second_state/2,
         third_state/2, third_state/3, handle_event/3,
         handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([next/1, sync_next/1, reset/1, sync_reset/1]).

-define(SERVER, ?MODULE).

-record(state, {times=0}).

start_link(MachineName) ->
  gen_fsm:start_link({global, MachineName}, ?MODULE, [], []).

next(MachineName) ->
  gen_fsm:send_event({global, MachineName}, next).

sync_next(MachineName) ->
  gen_fsm:sync_send_event({global, MachineName}, next).

reset(MachineName) ->
  gen_fsm:send_all_state_event({global, MachineName}, reset).

sync_reset(MachineName) ->
  gen_fsm:sync_send_all_state_event({global, MachineName}, reset).

init([]) ->
  {ok, first_state, #state{}}.

%-----------------------------------------------------------------------------------
% Async events.
%-----------------------------------------------------------------------------------
first_state(next, #state{times = N} = State) ->
  io:format("First state...~n"),
  {next_state, second_state, State#state{times = N + 1}}.

second_state(next, #state{times = N} = State) ->
  io:format("Second state...~n"),
  {next_state, third_state, State#state{times = N + 1}}.

third_state(next, #state{times = N} = State) ->
  io:format("Third state...~n"),
  {next_state, first_state, State#state{times = N + 1}}.

%-----------------------------------------------------------------------------------
% Sync events.
%-----------------------------------------------------------------------------------
first_state(Event, _From, State) ->
  {next_state, NextState, NewState} = first_state(Event, State),
  {reply, NewState#state.times, NextState, NewState}.

second_state(Event, _From, State) ->
  {next_state, NextState, NewState} = second_state(Event, State),
  {reply, NewState#state.times, NextState, NewState}.

third_state(Event, _From, State) ->
  {next_state, NextState, NewState} = third_state(Event, State),
  {reply, NewState#state.times, NextState, NewState}.

%-----------------------------------------------------------------------------------
% Async events (All).
%-----------------------------------------------------------------------------------
handle_event(reset, _StateName, _State) ->
  io:format("Async reset...~n"),
  {next_state, first_state, #state{}}.

%-----------------------------------------------------------------------------------
% Sync events (All).
%-----------------------------------------------------------------------------------
handle_sync_event(reset, _From, _StateName, _State) ->
  io:format("Sync reset...~n"),
  {reply, 0, first_state, #state{}}.

%-----------------------------------------------------------------------------------
% Regular OTP messages.
%-----------------------------------------------------------------------------------
handle_info(_Info, StateName, State) ->
  {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
  ok.

code_change(_OldVsn, StateName, State, _Extra) ->
  {ok, StateName, State}.
