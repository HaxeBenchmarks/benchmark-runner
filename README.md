# `benchmark-runner`

This is a WIP benchmark runner for [`benchs.haxe.org`](https://benchs.haxe.org/). The library code is located in [`src`](src) and contains the main benchmark runner class as well as data structures to define Haxe versions, Haxe targets, benchmark compilations, and benchmark executions. Individual benchmarks are located in [`cases`](cases). This project requires `lix` (with shimmed `haxe` and `haxelib`) and `timeout` to be available in the `PATH`. The benchmark cases should be executed using at least Haxe 4.1, the runner then invokes `lix` to switch versions at runtime.

## Running a benchmark case - all versions and all targets

- `cd cases/<testcase>`
- `npx haxe run.hxml`

You will find test results in console output and in three JSON files inside subfolder `benchmark-run`.

## Running a benchmark case with one Haxe version

- `cd cases/<testcase>`
- `export BENCHMARK_VERSIONS=haxe-nightly` or `set BENCHMARK_VERSIONS=haxe-nightly`
- `npx haxe run.hxml`

Available versions are:

- `haxe3` for Haxe 3.4.7
- `haxe4` for Haxe 4.0.5
- `haxe-nightly` for latest Haxe nightly build

## Running a benchmark case for specific targets

- `cd cases/<testcase>`
- `export BENCHMARK_TARGETS=java,jvm` or `set BENCHMARK_TARGETS=java,jvm`
- `npx haxe run.hxml`

Runs benchmark for `java` and `jvm` targets using all three Haxe versions.

You can use combinations of `BENCHMARK_VERSIONS` and `BENCHMARK_TARGETS`.

Available targets are:

- `cpp`
- `cppGCGen`
- `cppia`
- `cs`
- `eval`
- `hl`
- `hlc`
- `hlGCImmix`
- `hlcGCImmix`
- `java`
- `jvm`
- `js`
- `js-es6`
- `lua`
- `neko`
- `php`
- `python`
