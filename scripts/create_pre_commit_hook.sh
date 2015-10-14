#!/bin/sh

if [ ! -d .git/hooks ]; then
    mkdir .git/hooks
fi

if [ ! -L .git/hooks/pre-commit ]; then
    ln -s $PWD/GtsiapKit/scripts/remove_spaces.sh $PWD/.git/hooks/pre-commit

    chmod +x .git/hooks/pre-commit
fi
