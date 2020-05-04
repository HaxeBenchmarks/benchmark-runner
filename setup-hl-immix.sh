#!/bin/bash

readonly HASHLINK_BASE=$TOOLING_BASE/hashlink/hashlink-immix

export LD_LIBRARY_PATH=$HASHLINK_BASE/lib:$LD_LIBRARY_PATH
export PATH=$HASHLINK_BASE/bin:$PATH
export HASHLINK_CC_PARAMS="-I $HASHLINK_BASE/include -L $HASHLINK_BASE/lib"
