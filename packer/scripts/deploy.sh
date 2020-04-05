#!/bin/sh
set -e
<< COMMENT
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and
installing your bundle as root will break this application for all non-root
users on this machine.
COMMENT

/usr/bin/git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
/bin/echo "Moving systemd unit file from temporary dir to system location..."
/usr/bin/sudo mv /tmp/reddit.service /etc/systemd/system/reddit.service
/bin/echo "Changing mode..."
/usr/bin/sudo chmod 644 /etc/systemd/system/reddit.service
/bin/echo "Re-reading systemd configuration..."
/usr/bin/sudo systemctl daemon-reload
/bin/echo "Enabling service at system startup..."
/usr/bin/sudo systemctl enable reddit.service
/bin/echo "Done."
exit 0
