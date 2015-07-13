#!/usr/bin/env sh

if [[ -z $1 ]]; then
    echo "SRCROOT is missing"
    exit 1
fi

if [[ ! -d $1 ]]; then
    echo "$1 doesn't exist"
    exit 1
fi

echo "Removing spaces from files"

# http://stackoverflow.com/questions/7039130/bash-iterate-over-list-of-files-with-spaces

find . -iname "*.swift" | while read f
do
    echo $f
    sed -i "" -e 's/[[:blank:]]*$//g' "$f"
done
