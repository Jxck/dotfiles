%% test では ct:print, prod では io:format を使いログを出す。
%% 配列にしないため、引数 7 個まで対応。

%% Test かどうかで Log か Debug を切り替える。
%% TODO: debug フラグで行う。
-ifdef(TEST).
  -define(IO(A, B),  ct:print(A, B)).
  -define(IO2(A, B), ct:print(A, B)).
  -define(IO1(A, B), (fun(_A, _B) -> '' end)(A, B)).
-else.
  -define(IO(A, B),  io:format(A, B)).
  -define(IO1(A, B), io:format(A, B)).
  -define(IO2(A, B), (fun(_A, _B) -> '' end)(A, B)).
-endif.


%% 式の途中で引数が一つならそれをそのまま返す関数
-define(P(A),            (fun(P) -> ?IO1("[~p ~p:~p#~p]~n\t~p~n",                   [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, P]), P end)(A)).

-define(Log(A),                     ?IO1("[~p ~p:~p#~p]~n\t~p~n",                   [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A                  ])).
-define(Log(A, B),                  ?IO1("[~p ~p:~p#~p]~n\t~p ~p~n",                [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B               ])).
-define(Log(A, B, C),               ?IO1("[~p ~p:~p#~p]~n\t~p ~p ~p~n",             [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C            ])).
-define(Log(A, B, C, D),            ?IO1("[~p ~p:~p#~p]~n\t~p ~p ~p ~p~n",          [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D         ])).
-define(Log(A, B, C, D, E),         ?IO1("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p~n",       [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E      ])).
-define(Log(A, B, C, D, E, F),      ?IO1("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p ~p~n",    [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F   ])).
-define(Log(A, B, C, D, E, F, G),   ?IO1("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p ~p ~p~n", [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F, G])).

-define(Debug(A),        (fun(P) -> ?IO2("[~p ~p:~p#~p]~n\t~p~n",                   [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, P]), P end)(A)).
-define(Debug(A, B),                ?IO2("[~p ~p:~p#~p]~n\t~p ~p~n",                [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B               ])).
-define(Debug(A, B, C),             ?IO2("[~p ~p:~p#~p]~n\t~p ~p ~p~n",             [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C            ])).
-define(Debug(A, B, C, D),          ?IO2("[~p ~p:~p#~p]~n\t~p ~p ~p ~p~n",          [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D         ])).
-define(Debug(A, B, C, D, E),       ?IO2("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p~n",       [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E      ])).
-define(Debug(A, B, C, D, E, F),    ?IO2("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p ~p~n",    [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F   ])).
-define(Debug(A, B, C, D, E, F, G), ?IO2("[~p ~p:~p#~p]~n\t~p ~p ~p ~p ~p ~p ~p~n", [self(), ?MODULE, ?FUNCTION_NAME, ?LINE, A, B, C, D, E, F, G])).

%% print with red
-define(Red(Str), ?IO("\x1b[1;35m~p\x1b[0m~n", [Str])).

%% print binary in hexadecimal
-define(Bin, fun(Bin) ->
                     List = lists:map(fun(X) ->
                                              string:right(lists:flatten(io_lib:format("~.16b", [X])), 2, $0)
                                      end, binary:bin_to_list(Bin)),
                     Len = length(List),
                     Format = "[~p:~p#~p]~n" ++ string:copies("~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s~n", Len div 8) ++ string:copies("~s, ", Len rem 8) ++ "~n",

                     ?IO(Format, [?MODULE, ?FUNCTION_NAME, ?LINE | List]),
                     Bin
             end).
