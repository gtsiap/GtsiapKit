#!/usr/bin/env sh

SRCROOT=$(git rev-parse --show-toplevel)

echo "Removing spaces from files"

# http://stackoverflow.com/questions/7039130/bash-iterate-over-list-of-files-with-spaces

find $SRCROOT -iname "*.swift" | while read f
do
    sed -i "" -e 's/[[:blank:]]*$//g' "$f"
done

echo "done"
