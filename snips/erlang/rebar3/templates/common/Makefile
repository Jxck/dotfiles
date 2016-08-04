all:
	rebar3 clean && rebar3 release && ./_build/default/rel/{{name}}/bin/{{name}} foreground

test:
	rebar3 clean && rebar3 compile && rebar3 ct
