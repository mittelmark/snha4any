##-*- makefile -*-############################################################
#

CURRENT_MAKEFILE := $(lastword $(MAKEFILE_LIST))

## argument delegation
ARGS=
FUFILES=Stats.fu
APP=stats
MAIN=STATSMAIN
## default: list existing tasks 
.PHONY: tasks
tasks:  ## list all tasks
	@grep -Eo '^[a-z0-9]+:.+' $(CURRENT_MAKEFILE) | sed -E 's/:\s+##/\t- /g'

cpp:	## compile Cpp
	[ -d cppm ] || mkdir cppm
	fut -D $(MAIN) $(FUFILES) -o cppm/$(APP).cpp
	g++ -std=c++20 cppm/$(APP).cpp -o cppm/$(APP)
	./cppm/$(APP) | tail -n 20
