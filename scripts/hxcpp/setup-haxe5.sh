#!/bin/bash

readonly HXCPP_BASE="$TOOLING_BASE/hxcpp/hxcppHaxe5"

if [ -d "$HXCPP_BASE" ]; then
    lix dev hxcpp "$HXCPP_BASE"
    haxelib dev hxcpp "$HXCPP_BASE"
fi
