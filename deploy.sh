#!/bin/sh

<< COMMENT
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and
installing your bundle as root will break this application for all non-root
users on this machine.
COMMENT

/usr/bin/git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
