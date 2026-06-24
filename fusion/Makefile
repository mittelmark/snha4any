##-*- makefile -*-############################################################
#

CURRENT_MAKEFILE := $(lastword $(MAKEFILE_LIST))

## argument delegation
ARGS=
FUFILES=Stats.fu
APP=Stats
app=$(shell echo $(APP) | tr A-Z a-z)
MAIN=STATSMAIN
## D compiler check
ifeq (, $(shell which dmd 2>/dev/null))
dcom=ldc2
else
dcom=dmd
endif
## default: list existing tasks 
.PHONY: tasks
tasks:  ## list all tasks
	@grep -Eo '^[a-z0-9]+:.+' $(CURRENT_MAKEFILE) | sed -E 's/:\s+##/\t- /g'

c:	## compile C
	[ -d cm ] || mkdir cm
	fut -D $(MAIN) $(FUFILES) -o cm/$(app).c
	gcc cm/$(app).c `pkg-config --cflags --libs glib-2.0` -o cm/$(app)-c -lm
	./cm/$(app)-c

cpp:	## compile Cpp
	[ -d cppm ] || mkdir cppm
	fut -D $(MAIN) $(FUFILES) -o cppm/$(app).cpp
	g++ -std=c++20 cppm/$(app).cpp -o cppm/$(app)-cpp
	./cppm/$(app)-cpp 
cs:
	[ -d MainApp ] && rm -rf MainApp
	dotnet new console -n MainApp --no-restore --force
	rm MainApp/Program.cs
	fut -D $(MAIN) $(FUFILES) -o MainApp/$(app).cs
	cd MainApp && dotnet build -c Release
	./MainApp/bin/Release/net10.0/MainApp
	
d:
	[ -d dm ] || mkdir dm
	fut -D $(MAIN) $(FUFILES) -o dm/$(app).d 
	$(dcom) dm/$(app).d -of=dm/$(app)-d 
	./dm/$(app)-d
java:
	[ -d javam ] || mkdir javam
	fut -D $(MAIN) $(FUFILES) -o javam/$(APP).java 
	javac javam/*.java
	java -cp ./javam $(APP)
js:
	[ -d jsm ] || mkdir jsm
	fut -D $(MAIN) $(FUFILES) -o jsm/$(app).js
	node jsm/$(app).js

	
py:
	[ -d pym ] || mkdir pym
	fut -D $(MAIN) $(FUFILES) -o pym/$(app).py
	python3 pym/$(app).py

ts:
	[ -d tsm ] || mkdir tsm
	fut -D $(MAIN) $(FUFILES) -o tsm/$(app).ts
	bun tsm/$(app).ts
	
swift:
	[ -d swiftm/Sources/swift ]] || mkdir -p swiftm/Sources/swift
	fut -D $(MAIN) $(FUFILES) -o swiftm/Sources/swift/swift.swift
	cd swiftm && swift build
	cd swiftm && swift run
	./swiftm/.build/x86_64-unknown-linux-gnu/debug/swift
mgraph:
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN c  | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "C    OK" || echo "C    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cpp | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo  "C++  OK" || echo "Cpp  Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cs | grep -v MainApp | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "C#   OK" || echo "C#   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN d  | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "D    OK" || echo "D    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN java | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo "Java OK" || echo "Java Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN js | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Js   OK" || echo "Js   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN ts | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Ts   OK" || echo "Ts   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN py | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Py   OK" || echo "Py   Fail"
