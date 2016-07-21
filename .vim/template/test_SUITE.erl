-module(test_SUITE).
-export([
         all/0,
         suite/0,
         groups/0,
         init_per_suite/1,
         end_per_suite/1,
         init_per_group/2,
         end_per_group/2,
         init_per_testcase/2,
         end_per_testcase/2
        ]).
-export([
         test_case1/1,
         test_case2/1,
         test_case3/1,
         test_case4/1
        ]).

-include_lib("common_test/include/ct.hrl").

-define(p(A1), io:format("[~p:~p] ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1])).
-define(p(A1, A2), io:format("[~p:~p] ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2])).
-define(p(A1, A2, A3), io:format("[~p:~p] ~p ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2, A3])).
-define(p(A1, A2, A3, A4), io:format("[~p:~p] ~p ~p ~p ~p~n", [?FUNCTION_NAME, ?LINE] ++ [A1, A2, A3, A4])).

suite() ->
    ct:print("\x1b[0;35m# suite()\x1b[0m"),
    [{timetrap, {seconds, 30}}].

init_per_suite(Config) ->
    ct:print("\x1b[0;36m> init_per_suite()\x1b[0m"),
    DB=orddict:store(x, y, orddict:new()),
    [{db, DB} | Config].

end_per_suite(_Config) ->
    ct:print("\x1b[0;36m< end_per_suite()\x1b[0m"),
    ok.

init_per_group(_GroupName, Config) ->
    ct:print("\x1b[0;33m>> init_per_group(~p)\x1b[0m", [_GroupName]),
    Config.

end_per_group(_GroupName, _Config) ->
    ct:print("\x1b[0;33m<< end_per_group(~p)\x1b[0m", [_GroupName]),
    ok.

init_per_testcase(_TestCase, Config) ->
    ct:print("\x1b[0;34m>>> init_per_testcase(~p)\x1b[0m", [_TestCase]),
    Config.

end_per_testcase(_TestCase, _Config) ->
    ct:print("\x1b[0;34m<<< end_per_testcase(~p)\x1b[0m", [_TestCase]),
    ok.

groups() ->
    ct:print("\x1b[0;35m# groups()\x1b[0m"),
    [
     {success, [parallel], [ test_case1, test_case2 ]},
     {failer,  [shuffle, sequence], [ test_case3, test_case4 ]}
    ].

all() ->
    [
     {group, success},
     {group, failer}
    ].

test_case1(Config) ->
    ct:print("\x1b[0;31m## test_case1\x1b[0m"),
    DB = ?config(db, Config),
    {ok, y} = orddict:find(x, DB).

test_case2(Config) ->
    ct:print("\x1b[0;31m## test_case2\x1b[0m"),
    DB = ?config(db, Config),
    NewDB = orddict:store(k, v, DB),
    {ok, v} = orddict:find(k, NewDB).

test_case3(Config) ->
    ct:print("\x1b[0;31m## test_case3\x1b[0m"),
    DB = ?config(db, Config),
    error = orddict:find(n, DB).

test_case4(Config) ->
    ct:print("\x1b[0;31m## test_case4\x1b[0m"),
    DB = ?config(db, Config),
    false = orddict:is_empty(DB).
