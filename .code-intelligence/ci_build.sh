#!/bin/bash -eu

mkdir -p build

cd build

cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DYAML_CPP_BUILD_TESTS=OFF ..

make -j8
