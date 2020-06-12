#!/bin/bash

target="$1"

readonly HASHLINK_BASE="$TOOLING_BASE/hashlink/hashlink-master"

gcc -O3 -std=c11 -o "$target/hlc" "$target/hlc.c" -I "$HASHLINK_BASE/include" -I "$target" -L "$HASHLINK_BASE/lib" -lhl "$HASHLINK_BASE/lib/fmt.hdll"
