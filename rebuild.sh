#!/bin/sh

/usr/bin/env

BASE=""
LATE=""

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
    make -C $b build
    make -C $b push
    make -C $b swarm
done

for l in $LATE; do
    make -C $l build
    make -C $l push
    make -C $l swarm
done
