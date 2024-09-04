#!/bin/bash

set -ex

TARGET=$1
OUTPUT=$2

# This script from:
#   https://github.com/codecov/swift-standard/blob/b65449b5a2e92468d5bf4cb7e6a5711450a2682b/.github/workflows/swift_macos-10.15.yml#L27-L32
# MIT License | Copyright (c) 2022 Codecov

# Search for the path of `Coverage.profdata`.
cd Build/Build/ProfileData
cd $(ls -d */|head -n 1)
directory=${PWD##*/}
pathCoverage=Build/Build/ProfileData/${directory}/Coverage.profdata
cd ../../../../

xcrun llvm-cov export \
  -format="lcov" \
  -instr-profile $pathCoverage \
  Build/Build/Products/Debug-iphonesimulator/${TARGET} > $OUTPUT

rm -rf Build/
