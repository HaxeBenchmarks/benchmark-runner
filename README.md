# `benchmark-runner`

This is a WIP benchmark runner for [`benchs.haxe.org`](https://benchs.haxe.org/). The library code is located in [`src`](src) and contains the main benchmark runner class as well as data structures to define Haxe versions, Haxe targets, benchmark compilations, and benchmark executions. Individual benchmarks are located in [`cases`](cases). This project requires `lix` (with shimmed `haxe` and `haxelib`) and `timeout` to be available in the `PATH`. The benchmark cases should be executed using at least Haxe 4, the runner then invokes `lix` to switch versions at runtime.
