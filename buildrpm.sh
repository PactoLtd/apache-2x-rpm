#!/usr/bin/env bash

set -e

#
# Global variables
#
__SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
__PARENT_DIR="$(dirname "$__SCRIPT_DIR")"
__NEXUS_HOST
__NEXUS_API=$__NEXUS_HOST/service/local/artifact/maven/redirect
__TARGET_DIR=target
__TMP_DIR=/opt/docker-registry


#
# Create target dir  (must be run as root)
#
function createTarget(){
  mkdir -p $__PARENT_DIR/$__TARGET_DIR
  mkdir -p $__TMP_DIR

  defaultUser="ec2-user"
  user=`who am i | awk '{print $1}'`

  if [ -z "${param// }" ] 
    then
    user=$defaultUser
  fi

  echo "user = [$user]"

  chown ${user?$defaultUser} $__PARENT_DIR/$__TARGET_DIR
  chown ${user?$defaultUser} $__PARENT_DIR/$__TARGET_DIR/.
  chown ${user?$defaultUser} $__PARENT_DIR/$__TARGET_DIR/..
  chown ${user?$defaultUser} $__TMP_DIR
  chown ${user?$defaultUser} $__TMP_DIR/.
  chown ${user?$defaultUser} $__TMP_DIR/..

  echo "Created $__PARENT_DIR/$__TARGET_DIR & $__TMP_DIR"
}


#
# Move scripts to target dir
#
function updateConfig(){
  cp -fR $__PARENT_DIR/usr $__PARENT_DIR/$__TARGET_DIR
  cp -f $__PARENT_DIR/conf/httpd.conf $__PARENT_DIR/$__TARGET_DIR/opt/claimportal/conf/httpd.conf
  cp -f $__PARENT_DIR/conf/httpd.template $__PARENT_DIR/$__TARGET_DIR/opt/claimportal/conf/httpd.template
  cp -fR $__PARENT_DIR/conf.d $__PARENT_DIR/$__TARGET_DIR/opt/claimportal/conf.d

  echo "Copied httpd.conf, conf.d to target"
}


#
# Copy content to target directories
#
function setupRpm(){
  cp -fR $__PARENT_DIR/$__TARGET_DIR/opt/claimportal /opt/
  cp -fR $__PARENT_DIR/$__TARGET_DIR/usr /opt/claimportal/usr

  echo "Copied target contents to /opt/claimportal"
}


#
# Create rpm
#
function createRpm(){
  while [ $# -gt 0 ]; do
    case "$1" in
      --epoch=*)
        epoch="${1#*=}"
        ;;       
      *)
        printf "***************************\n"
        printf "* Error: Invalid argument.*\n"
        printf "***************************\n"
        exit 1
    esac
    shift
  done

  fpm -s dir \
    -t rpm \
    --pre-install scripts/pre-install.sh \
    --post-install scripts/post-install.sh \
    --after-remove scripts/post-uninstall.sh \
    --rpm-user dockerregistry \
    --rpm-group dockerregistry \
    --rpm-compression gzip \
    --rpm-os linux \
    --depends apr-util \
    --depends apr \
    --log debug \
    --verbose \
    --directories '/opt/claimportal' \
    --rpm-summary "httpd 2.4.x installation with some custom node modules aka Guidewire Mobile & Portal." \
    -n dockerregistry \
    -v 1.0.$epoch $__TMP_DIR

    mv claimportal-1.0.$epoch-1.x86_64.rpm $__PARENT_DIR/$__TARGET_DIR

    echo "Create RPM and moved to target folder"
}

# --post-install FILE           (DEPRECATED, use --after-install) A script to be run after package installation
#    --pre-install FILE            (DEPRECATED, use --before-install) A script to be run before package installation
#    --post-uninstall FILE         (DEPRECATED, use --after-remove) A script to be run after package removal
#    --pre-uninstall FILE          (DEPRECATED, use --before-remove) A script to be run before package removal
#    --after-install FILE          A script to be run after package installation
#    --before-install FILE         A script to be run before package installation
#    --after-remove FILE           A script to be run after package removal
#    --before-remove FILE          A script to be run before package removal
#    --after-upgrade FILE
# --rpm-changelog FILEPATH      (rpm only) Add changelog from FILEPATH contents

# -description "Describe the artifact"
# -a all
# --config-files
# --directories


#
# clean rpm
#
function cleanRpm(){
  rm -fr $__TMP_DIR/*
  rm -f $__PARENT_DIR/$__TARGET_DIR/*.rpm
  rm -f $__PARENT_DIR/*.rpm
}


#
# Clean up
#
function clean(){
  rm -fr $__PARENT_DIR/$__TARGET_DIR
  rm -fr $__TMP_DIR
  rm -f httpd-*.tar.gz
  rm -f *.zip
}






"$@"
