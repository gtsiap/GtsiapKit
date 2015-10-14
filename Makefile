.PHONY: all carthage

all: create_pre_commit_hook carthage
	git submodule init
	git submodule update

carthage:
	/bin/sh ./GtsiapKit/scripts/carthage.sh

create_pre_commit_hook:
	/bin/sh .GtsiapKit/scripts/create_pre_commit_hook.sh

pull:
	git submodule foreach git pull origin master
