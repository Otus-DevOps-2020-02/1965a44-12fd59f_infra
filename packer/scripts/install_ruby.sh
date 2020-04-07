#!/bin/sh
set -e
/usr/bin/apt-get -q update
/usr/bin/apt-get -qq install ruby-full ruby-bundler build-essential
