#!/bin/bash

set -o errexit -o nounset -o xtrace

cd "$1"
aunpack -eD "${@:1}"
