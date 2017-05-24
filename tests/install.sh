#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" || ( echo "Failed to cd into tests directory" && exit 1 )

git clone --depth=1 https://github.com/sstephenson/bats.git
git clone --depth=1 https://github.com/ztombol/bats-support.git
git clone --depth=1 https://github.com/jasonkarns/bats-assert.git
