#!/bin/bash

readonly HASHLINK_BASE=$TOOLING_BASE/hashlink/hashlink-immix

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HASHLINK_BASE/lib
export PATH=$HASHLINK_BASE/bin:$PATH
export HASHLINK_CC_PARAMS="-m32 -I $HASHLINK_BASE/include -L $HASHLINK_BASE/lib"
