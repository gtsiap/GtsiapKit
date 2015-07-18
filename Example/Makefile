.PHONY: all

all: create_pre_commit_hook
	carthage update

create_pre_commit_hook:
	/bin/sh ./scripts/create_pre_commit_hook.sh
