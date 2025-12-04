#!/bin/bash

target="$1"

readonly HASHLINK_BASE="$TOOLING_BASE/hashlink/hashlink-1.16"

export LD_LIBRARY_PATH="$HASHLINK_BASE/lib:$LD_LIBRARY_PATH"

"$target" "${@:2}"
