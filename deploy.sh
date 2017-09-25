#!/bin/bash
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/docker_imgs/nginxForShibboleth/
./export-to-tar.sh
cd $DIR/docker_imgs/shibboleth-sp/
./export-to-tar.sh
cd $DIR/docker_imgs/shibboleth-idp/
./export-to-tar.sh
cd $DIR/deploy/
vagrant up