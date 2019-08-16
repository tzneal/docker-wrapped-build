#!/bin/sh
BASE_DIR=$(readlink -f $(pwd))
USER=$(id -u)
GROUP=$(id -g)
IMG=$1
TGT=$2

# I typically add another volume entry or two for any build caches I want to use:
# PKG=$(go env GOPATH)/pkg
# -v$PKG:/root/go/pkg 

docker run -w /src --rm -it -eUSER=$USER -eGROUP=$GROUP -v$BASE_DIR:/src $IMG make $TGT