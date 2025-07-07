#!/bin/bash

set -e

cargo build --release

mkdir -p bin
cp target/release/my-box-ip-client bin/
