#!/bin/bash

readonly HXCPP_BASE="$TOOLING_BASE/hxcpp/hxcppHaxe4"

if [ -d "$HXCPP_BASE" ]; then
    lix dev hxcpp "$HXCPP_BASE"
    haxelib dev hxcpp "$HXCPP_BASE"
fi
