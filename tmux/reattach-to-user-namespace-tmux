#!/usr/bin/env bash

if [[ "$(uname)" = "Darwin" ]]; then
  reattach-to-user-namespace $@
else
  exec "$@"
fi
