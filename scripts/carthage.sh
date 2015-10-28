#!/bin/sh

carthage checkout
carthage build

echo "Fix XCode autocomplete"

cp -R ./Carthage/ ./GtsiapKit/
