#!/bin/sh

# Download parts
/usr/bin/curl -sSL https://git.io/JvSQB -o install_ruby.sh
/usr/bin/curl -sSL https://git.io/JvSQu -o install_mongodb.sh
/usr/bin/curl -sSL https://git.io/JvSdl -o deploy.sh

# Run them all
/bin/sh install_ruby.sh && /bin/sh install_mongodb.sh && /bin/sh deploy.sh

# end
