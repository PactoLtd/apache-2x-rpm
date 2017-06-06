#!/usr/bin/env bash

set -e

#
# Script paramters
#
__USER_ID=dockerregistry


#
# Setup user to run service as
#
id -u $__USER_ID &>/dev/null || useradd -s /usr/sbin/nologin -r -M -d /dev/null $__USER_ID


#
# Create installation directories
#
mkdir -p /opt/dockerregistry

