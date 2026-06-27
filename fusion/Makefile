##-*- makefile -*-############################################################
#

CURRENT_MAKEFILE := $(lastword $(MAKEFILE_LIST))

## argument delegation
ARGS=
FUFILES=Stats.fu
APP=Stats
LANG=ALL
ARGS=
app=$(shell echo $(APP) | tr A-Z a-z)
MAIN=STATSMAIN
## D compiler check
ifeq (, $(shell which dmd 2>/dev/null))
dcom=ldc2
else
dcom=dmd
endif
CHECK='val=0.2.* rankmean=2.5'
CHECKM='(^2.+5.+8|0.95)'
FREADERCHECK=grep -E 'test.txt|Hello|World' | wc -l | grep -q 4
## default: list existing tasks 
.PHONY: tasks
tasks:  ## list all tasks
	@grep -Eo '^[a-z0-9]+:.+' $(CURRENT_MAKEFILE) | sed -E 's/:\s+##/\t- /g'

c:	## compile C
	[ -d cm ] || mkdir cm
	fut -D $(MAIN) -D C $(FUFILES) -o cm/$(app).c
	gcc cm/$(app).c `pkg-config --cflags --libs glib-2.0` -o cm/$(app)-c -lm
	./cm/$(app)-c $(ARGS)

cpp:	## compile Cpp
	[ -d cppm ] || mkdir cppm
	fut -D $(MAIN) -D CPP  $(FUFILES) -o cppm/$(app).cpp
	g++ -std=c++20 cppm/$(app).cpp -o cppm/$(app)-cpp
	./cppm/$(app)-cpp $(ARGS)
cs:
	[ -d MainApp ] && rm -rf MainApp
	dotnet new console -n MainApp --no-restore --force
	rm MainApp/Program.cs
	fut -D $(MAIN) -D CSHARP $(FUFILES) -o MainApp/$(app).cs
	cd MainApp && dotnet build -c Release
	./MainApp/bin/Release/net10.0/MainApp $(ARGS)
	
d:
	[ -d dm ] || mkdir dm
	fut -D $(MAIN) -D D $(FUFILES) -o dm/$(app).d 
	$(dcom) dm/$(app).d -of=dm/$(app)-d 
	./dm/$(app)-d $(ARGS)
java:
	[ -d javam ] || mkdir javam
	fut -D $(MAIN) -D JAVA $(FUFILES) -o javam/$(APP).java 
	javac javam/*.java
	java -cp ./javam $(APP) $(ARGS)
js:
	[ -d jsm ] || mkdir jsm
	fut -D $(MAIN) -D JS $(FUFILES) -o jsm/$(app).js
	node jsm/$(app).js $(ARGS)

	
py:
	[ -d pym ] || mkdir pym
	fut -D $(MAIN) -D PYTHON $(FUFILES) -o pym/$(app).py
	python3 pym/$(app).py $(ARGS)

ts:
	[ -d tsm ] || mkdir tsm
	fut -D $(MAIN) -D TS $(FUFILES) -o tsm/$(app).ts
	bun tsm/$(app).ts $(ARGS)
	
swift:
	[ -d swiftm/Sources/swift ] || mkdir -p swiftm/Sources/swift
	fut -D $(MAIN) -D SWIFT $(FUFILES) -o swiftm/Sources/swift/swift.swift
	cd swiftm && swift build
	#cd swiftm && swift run
	./swiftm/.build/x86_64-unknown-linux-gnu/debug/swift $(ARGS)
rand:
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand c | grep -qE 'position 19.+ is 15' && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand cpp | grep -qE 'position 19.+ is 15' && echo   "C++   OK" || echo "C++   Fail"	
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand cs | grep -qE 'position 19.+ is 15' && echo   "C#    OK" || echo "C#   Fail"		
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand d | grep -qE 'position 19.+ is 15' && echo   "D     OK" || echo "D    Fail"			
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand java | grep -qE 'position 19.+ is 15' && echo   "Java  OK" || echo "Java  Fail"				
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand js  | grep -qE 'position 19.+ is 15' && echo   "Js    OK" || echo "Js   Fail"					
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand ts  | grep -qE 'position 19.+ is 15' && echo   "Ts    OK" || echo "Ts   Fail"						
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" APP=Rand py  | grep -qE 'position 19.+ is 15' && echo   "Py    OK" || echo "Py   Fail"							
	@make FUFILES="Rand.fu Stats.fu" MAIN="RANDMAIN" LANG=SWIFT APP=Rand swift 2>/dev/null | grep -qE 'position 19.+ is 15' && echo   "Swift OK" || echo "Swift  Fail"

stats:
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats c | grep -qE $(CHECK) && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats cpp | grep -qE $(CHECK) && echo   "C++   OK" || echo "C++   Fail"	
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats cs | grep -qE $(CHECK) && echo   "C#    OK" || echo "C#   Fail"		
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats d | grep -qE $(CHECK) && echo   "D     OK" || echo "D    Fail"			
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats java | grep -qE $(CHECK) && echo   "Java  OK" || echo "Java  Fail"				
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats js  | grep -qE $(CHECK) && echo   "Js    OK" || echo "Js   Fail"					
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats ts  | grep -qE $(CHECK) && echo   "Ts    OK" || echo "Ts   Fail"						
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats py  | grep -qE $(CHECK) && echo   "Py    OK" || echo "Py   Fail"							
	@make FUFILES="Rand.fu Stats.fu" MAIN="STATSMAIN" APP=Stats swift 2>/dev/null | grep -qE $(CHECK) && echo   "Swift OK" || echo "Swift  Fail"

matrix:
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix c 2>/dev/null | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix cpp | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "C++   OK" || echo "C++   Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix cs | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "C#    OK" || echo "C#     Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix d | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "D     OK" || echo "D    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix java	 | grep -E $(CHECKM) | wc -l | grep -q 2  && echo   "Java  OK" || echo "Java  Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix js | grep -E $(CHECKM) | wc -l | grep -q 2  && echo   "Js    OK" || echo "Js    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix py | grep -E $(CHECKM) | wc -l | grep -q 2  && echo   "Py    OK" || echo "Py    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix ts | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "Ts    OK" || echo "Ts    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix swift 2>/dev/null | grep -E $(CHECKM) | wc -l | grep -q 2 && echo   "Swift OK" || echo "Swift   Fail"

mgraph:
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN c    | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "C     OK" || echo "C    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cpp  | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "C++   OK" || echo "Cpp  Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cs   | grep -v MainApp | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "C#    OK" || echo "C#   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN d    | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "D     OK" || echo "D    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN java | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Java  OK" || echo "Java Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN js   | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Js    OK" || echo "Js   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN ts   | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Ts    OK" || echo "Ts   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN py   | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Py    OK" || echo "Py   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN swift 2>/dev/null| grep -v Write | grep -E "A.+B|A.+1" | wc -l | grep -q 5 && echo   "Swift OK" || echo "Swift  Fail"	

mcgraph:
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN c 2>/dev/null | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "C    OK" || echo "C     Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN cpp | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Cpp  OK" || echo "Cpp   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN cs | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "C#   OK" || echo "C#    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN d | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "D    OK" || echo "D     Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN java | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Java OK" || echo "Java Fail"	
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN js | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Js   OK" || echo "Js   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN ts	| grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Ts   OK" || echo "Ts    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN py | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Py   OK" || echo "Py    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN swift | grep -E '^(A|.+S0.+S1|1\.0)' | wc -l | grep -q 3 && echo "Swift OK" || echo "Swift    Fail"	

freader:
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt c     2> /dev/null| $(FREADERCHECK) && echo "C     OK" || echo "C     Fail"
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt cpp   2> /dev/null| $(FREADERCHECK) && echo "CPP   OK" || echo "Cpp   Fail"	
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt cs    2> /dev/null| $(FREADERCHECK) && echo "C#    OK" || echo "C#    Fail"		
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt d     2> /dev/null| $(FREADERCHECK) && echo "D     OK" || echo "D     Fail"			
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt java  2> /dev/null| $(FREADERCHECK) && echo "Java  OK" || echo "Java  Fail"				
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt js    2> /dev/null| $(FREADERCHECK) && echo "Js    OK" || echo "Js    Fail"					
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt py    2> /dev/null| $(FREADERCHECK) && echo "Py    OK" || echo "Py    Fail"						
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt swift 2> /dev/null| $(FREADERCHECK) && echo "Swift OK" || echo "Swift Fail"							
	@make FUFILES="FileReader.fu" APP=FileReader MAIN=FILEREADERMAIN ARGS=test/test.txt ts    2> /dev/null| $(FREADERCHECK) && echo "Ts    OK" || echo "Ts    Fail"								
