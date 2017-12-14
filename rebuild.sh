#!/bin/sh

set -e

/usr/bin/env

BASE=""
LATE=""

export REVISION=$(git log --pretty=format:'%h' -n 1)
CHANGED=$(for i in `git log --name-only --pretty=oneline --full-index $GIT_PREVIOUS_COMMIT..$GIT_COMMIT | grep -vE '^[0-9a-f]{40} '`; do echo `dirname $i`; done | sort | uniq)

for dir in $CHANGED; do
    case $dir in
        videolan-base*)
            BASE="$BASE $dir"
            ;;
        .)
            ;;
        *)
            LATE="$LATE $dir"
            ;;
    esac
done

echo "Changed base images: '$BASE'"
echo "Changed late images: '$LATE'"

for b in $BASE; do
    [ -d "$b" ] || continue
    make -C $b build
    make -C $b push
done

for l in $LATE; do
    [ -d "$l" ] || continue
    make -C $l build
    make -C $l push
done
