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
if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json ]; then
    echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json
fi
if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json ]; then
    echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json
fi
if [ ! -f $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json ]; then
    echo "[]" > $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json
fi
ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe3.json benchmark-run/
ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe4.json benchmark-run/
ln -sfn $BENCHMARK_RESULTS_BASE/$NAME/haxe-nightly.json benchmark-run/
