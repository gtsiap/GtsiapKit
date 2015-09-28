.PHONY: all

all: create_pre_commit_hook
	/bin/sh ./scripts/carthage.sh

carthage:
	/bin/sh ./scripts/carthage.sh

create_pre_commit_hook:
	/bin/sh ./scripts/create_pre_commit_hook.sh
