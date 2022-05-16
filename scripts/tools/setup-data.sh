#!/bin/bash

readonly NAME=$1

if [ -z "$BENCHMARK_RESULTS_BASE" ]; then
    echo "BENCHMARK_RESULTS_BASE not set - not initialising and linking up results data";
    exit 0;
fi

mkdir -p benchmark-run
if [ ! -d $BENCHMARK_RESULTS_BASE/$NAME ]; then
    mkdir $BENCHMARK_RESULTS_BASE/$NAME
fi

function linkDatafiles() {
    YEAR=$1
    if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json$YEAR ]; then
        echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json$YEAR
    fi
    if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json$YEAR ]; then
        echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json$YEAR
    fi
    if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json$YEAR ]; then
        echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json$YEAR
    fi
    if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe-pr.json$YEAR ]; then
        echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe-pr.json$YEAR
    fi
    ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json$YEAR benchmark-run/
    ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json$YEAR benchmark-run/
    ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json$YEAR benchmark-run/
    ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe-pr.json$YEAR benchmark-run/
}

linkDatafiles "";
linkDatafiles ".2019";
linkDatafiles ".2020";
linkDatafiles ".2021";
linkDatafiles ".2022";
linkDatafiles ".2023";
linkDatafiles ".2024";
linkDatafiles ".2025";
