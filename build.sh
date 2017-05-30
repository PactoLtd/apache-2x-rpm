#!/usr/bin/env bash

set -e

#
# Script vars
#
__HTTPD_VERSION=2.2.31
__SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
__PARENT_DIR="$(dirname "$__SCRIPT_DIR")"


#
# Compile and compress httpd
#
function compile(){
  while [ $# -gt 0 ]; do
    case "$1" in
      --epoch=*)
        __VERSION_EPOCH="${1#*=}"
        ;;       
      *)
        printf "***************************\n"
        printf "* Error: Invalid argument.*\n"
        printf "***************************\n"
        exit 1
    esac
    shift
  done

  curl -O http://mirror.cogentco.com/pub/apache/httpd/httpd-$__HTTPD_VERSION.tar.gz

  tar -xvf httpd-$__HTTPD_VERSION.tar.gz

  # Build and install apr 1.4
  cd httpd-$__HTTPD_VERSION/srclib/apr
  ./configure --prefix=/usr/local/apr-httpd/
  make
  make install

  # Build and install apr-util 1.4
  cd ../apr-util
  ./configure --prefix=/usr/local/apr-util-httpd/ --with-apr=/usr/local/apr-httpd/
  make
  make install

  # Configure httpd
  cd ../../
  ./configure --with-apr=/usr/local/apr-httpd/ \
              --with-apr-util=/usr/local/apr-util-httpd/ \
              --prefix=/opt/claimportal \
              --exec-prefix=/opt/claimportal \
              --enable-modules=all \
              --enable-deflate \
              --enable-mods-shared \
              --enable-actions=shared \
              --enable-alias=shared \
              --enable-asis=shared \
              --enable-auth-basic=shared \
              --enable-authn-default=shared \
              --enable-authn-file=shared \
              --enable-authz_default=shared \
              --enable-authz_groupfile=shared \
              --enable-authz_host=shared \
              --enable-authz_user=shared \
              --enable-autoindex=shared \
              --enable-cgi=shared \
              --enable-dir=shared \
              --enable-env=shared \
              --enable-headers=shared \
              --enable-deflate=shared \
              --enable-include=shared \
              --enable-isapi=shared \
              --enable-log-config=shared \
              --enable-mime=shared \
              --enable-auth-mellon= shared \
              --enable-negotiation=shared \
              --enable-proxy=shared \
              --enable-access-compat=shared \
              --enable-proxy-http=shared \
              --enable-rewrite=shared \
              --with-z=/usr/lib64 
  
  make
  make install

  echo "tar -czvf httpd-$__HTTPD_VERSION.$__VERSION_EPOCH.tar.gz /opt/claimportal"
  cd ..
  tar -czvf httpd-$__HTTPD_VERSION.$__VERSION_EPOCH.tar.gz /opt/claimportal 
}


#
# Clean workspace
#
function clean(){
  echo "Cleaning workspace of created artifacts"
  rm -f *.tar.gz
  rm -rf httpd-*
}

function test(){
  compile --epoch=$(date +%s)
}

"$@"

