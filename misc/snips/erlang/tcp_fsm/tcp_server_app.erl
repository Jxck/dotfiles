%% https://erlangcentral.org/wiki/index.php/Building_a_Non-blocking_TCP_server_using_OTP_principles
-module(tcp_server_app).

-behaviour(application).

%% Internal API
-export([start_client/0]).

%% Application and Supervisor callbacks
-export([start/2, stop/1, init/1]).

-define(MAX_RESTART,    5).
-define(MAX_TIME,      60).
-define(DEF_PORT,    2222).

%%----------------------------------------------------------------------
%% Application behaviour callbacks
%%----------------------------------------------------------------------
start(_Type, _Args) ->
    ListenPort = get_app_env(listen_port, ?DEF_PORT),
    supervisor:start_link({local, ?MODULE}, ?MODULE, [ListenPort, tcp_echo_fsm]).

stop(_S) ->
    ok.

%%----------------------------------------------------------------------
%% Supervisor behaviour callbacks
%%----------------------------------------------------------------------
%%
%%                 +----------------+
%%                 | tcp_server_app |
%%                 +--------+-------+
%%                          | (one_for_one)
%%         +----------------+---------+
%%         |                          |
%% +-------+------+           +-------+--------+
%% | tcp_listener |           + tcp_client_sup |
%% +--------------+           +-------+--------+
%%                                    | (simple_one_for_one)
%%                              +-----|---------+
%%                            +-------|--------+|
%%                           +--------+-------+|+
%%                           |  tcp_echo_fsm  |+
%%                           +----------------+
%%
init([Port, Module]) -> % Module = FSM
    {ok,
     {_SupFlags = {one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
       % TCP Listener
       {   tcp_server_sup,                          % Id       = internal id
           {tcp_listener,start_link,[Port,Module]}, % StartFun = {M, F, A}
           permanent,                               % Restart  = permanent | transient | temporary
           2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
           worker,                                  % Type     = worker | supervisor
           [tcp_listener]                           % Modules  = [Module] | dynamic
       },
       % Client instance supervisor
       {
        tcp_client_sup,
        {
         supervisor,
         start_link,
         [{local, tcp_client_sup}, ?MODULE, [Module]]
        },
        permanent,                               % Restart  = permanent | transient | temporary
        infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
        supervisor,                              % Type     = worker | supervisor
        []                                       % Modules  = [Module] | dynamic
       }
      ]
     }
    };

%% コネクションを扱う FSM を spawn
start_client() ->
    supervisor:start_child(tcp_client_sup, []).

init([Module]) ->
    {ok,
     {_SupFlags = {simple_one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
       % TCP Client
       {   undefined,                               % Id       = internal id
           {Module,start_link,[]},                  % StartFun = {M, F, A}
           temporary,                               % Restart  = permanent | transient | temporary
           2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
           worker,                                  % Type     = worker | supervisor
           []                                       % Modules  = [Module] | dynamic
       }
      ]
     }
    }.

%%----------------------------------------------------------------------
%% Internal functions
%%----------------------------------------------------------------------
get_app_env(Opt, Default) ->
    {ok, App} = application:get_application(),
    application:get_env(App, Opt, Default).
