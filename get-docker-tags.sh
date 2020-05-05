#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo "usage: $0 <image_name>";
fi
curl https://registry.videolan.org/v2/$1/tags/list | jq '.tags |= sort_by(.)'
