#!/bin/bash

target="$1"

readonly HASHLINK_BASE="$TOOLING_BASE/hashlink/hashlink-1.12"

gcc -O3 -std=c11 -o "$target/hlc" "$target/hlc.c" -I "$HASHLINK_BASE/include" -I "$target" -L "$HASHLINK_BASE/lib" -lhl -lm "$HASHLINK_BASE/lib/fmt.hdll"
