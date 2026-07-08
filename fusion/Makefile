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
CHECKM=grep -E '^(2.+5.+8|0.95|10.+11.+12)' | wc -l | grep -q 4
FSYSCHECK=grep -E 'test.txt|Hello|World|Out:' | wc -l | grep -q 7
CSVREADERCHECK=grep -E '3 0.1|4 0.5' | wc -l | grep -q 2
CHECKMGRAPH=grep -v var | grep -v Write | grep -v MainApp | grep -E "A.+B|A.+1|D.+1.+1" | wc -l | grep -q 6
CHECKSNHA=grep -E 'M: 100,6|Chain 4: E1-F1-D1-B1|Chain 3: B1-C1-A1|Chain 2: B1-C1-D1|96.+98.+55.+9.+14' | wc -l | grep -q 5
RANDC=grep -E '(position 19.+ is 15|position 12.+13|true=1)' | wc -l | grep -q 4
## default: list existing tasks 
.PHONY: tasks
tasks:  ## list all tasks
	@grep -Eo '^[a-z0-9]+:.+' $(CURRENT_MAKEFILE) | sed -E 's/:\s+##/\t- /g'

c:	## compile C
	[ -d cm ] || mkdir cm
	fut -D $(MAIN) -D C $(FUFILES) -o cm/$(app).c
	gcc -O3 cm/$(app).c `pkg-config --cflags --libs glib-2.0` -o cm/$(app)-c -lm
	./cm/$(app)-c $(ARGS)

cpp:	## compile Cpp
	[ -d cppm ] || mkdir cppm
	fut -D $(MAIN) -D CPP  $(FUFILES) -o cppm/$(app).cpp
	g++ -O3 -std=c++20 cppm/$(app).cpp -o cppm/$(app)-cpp
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
	$(dcom) -O dm/$(app).d -of=dm/$(app)-d 
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

bjs:
	[ -d bjsm ] || mkdir bjsm
	fut -D $(MAIN) -D JS $(FUFILES) -o bjsm/$(app).js
	bun bjsm/$(app).js $(ARGS)

	
swift:
	[ -d swiftm/Sources/swift ] || mkdir -p swiftm/Sources/swift
	fut -D $(MAIN) -D SWIFT $(FUFILES) -o swiftm/Sources/swift/swift.swift
	cd swiftm && swift build -c release
	#cd swiftm && swift run
	./swiftm/.build/x86_64-unknown-linux-gnu/release/swift $(ARGS)
rand:
	make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand c | $(RANDC) && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand cpp |  $(RANDC) && echo   "C++   OK" || echo "C++   Fail"	
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand cs |  $(RANDC) && echo   "C#    OK" || echo "C#   Fail"		
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand d |  $(RANDC) && echo   "D     OK" || echo "D    Fail"			
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand java |  $(RANDC) && echo   "Java  OK" || echo "Java  Fail"				
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand js  |  $(RANDC) && echo   "Js    OK" || echo "Js   Fail"					
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand ts  |  $(RANDC) && echo   "Ts    OK" || echo "Ts   Fail"						
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" APP=Rand py  |  $(RANDC) && echo   "Py    OK" || echo "Py   Fail"							
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="RANDMAIN" LANG=SWIFT APP=Rand swift 2>/dev/null |  $(RANDC) && echo   "Swift OK" || echo "Swift  Fail"

stats:
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats c | grep -qE $(CHECK) && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats cpp | grep -qE $(CHECK) && echo   "C++   OK" || echo "C++   Fail"	
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats cs | grep -qE $(CHECK) && echo   "C#    OK" || echo "C#   Fail"		
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats d | grep -qE $(CHECK) && echo   "D     OK" || echo "D    Fail"			
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats java | grep -qE $(CHECK) && echo   "Java  OK" || echo "Java  Fail"				
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats js  | grep -qE $(CHECK) && echo   "Js    OK" || echo "Js   Fail"					
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats ts  | grep -qE $(CHECK) && echo   "Ts    OK" || echo "Ts   Fail"						
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats py  | grep -qE $(CHECK) && echo   "Py    OK" || echo "Py   Fail"							
	@make FUFILES="Rand.fu Stats.fu Matrix.fu" MAIN="STATSMAIN" APP=Stats swift 2>/dev/null | grep -qE $(CHECK) && echo   "Swift OK" || echo "Swift  Fail"

matrix:
	make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix c 2>/dev/null | $(CHECKM) && echo   "C     OK" || echo "C     Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix cpp | $(CHECKM) && echo   "C++   OK" || echo "C++   Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix cs | $(CHECKM) && echo   "C#    OK" || echo "C#     Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix d | $(CHECKM) && echo   "D     OK" || echo "D    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix java |  $(CHECKM)  && echo   "Java  OK" || echo "Java  Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix js |  $(CHECKM)  && echo   "Js    OK" || echo "Js    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix py | $(CHECKM)  && echo   "Py    OK" || echo "Py    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix ts 2>/dev/null | $(CHECKM)  && echo   "Ts    OK" || echo "Ts    Fail"
	@make FUFILES="Stats.fu Matrix.fu" MAIN="MATRIXMAIN" APP=Matrix swift 2>/dev/null |  $(CHECKM) && echo   "Swift OK" || echo "Swift   Fail"

mgraph:
	make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN c    | $(CHECKMGRAPH) && echo   "C     OK" || echo "C    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cpp  | $(CHECKMGRAPH) && echo   "C++   OK" || echo "Cpp  Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN cs   | $(CHECKMGRAPH)  && echo   "C#    OK" || echo "C#   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN d    | $(CHECKMGRAPH) && echo   "D     OK" || echo "D    Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN java | $(CHECKMGRAPH) && echo   "Java  OK" || echo "Java Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN js   | $(CHECKMGRAPH) && echo   "Js    OK" || echo "Js   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN ts   | $(CHECKMGRAPH) && echo   "Ts    OK" || echo "Ts   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN py   | $(CHECKMGRAPH) && echo   "Py    OK" || echo "Py   Fail"
	@make FUFILES="Rand.fu Stats.fu Matrix.fu Mgraph.fu" APP=Mgraph MAIN=MGRAPHMAIN swift 2>/dev/null| $(CHECKMGRAPH) && echo   "Swift OK" || echo "Swift  Fail"	

mcgraph:
	make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN c 2>/dev/null | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "C    OK" || echo "C     Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN cpp | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Cpp  OK" || echo "Cpp   Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN cs | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "C#   OK" || echo "C#    Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN d | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "D    OK" || echo "D     Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN java | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Java OK" || echo "Java Fail"	
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN js | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Js   OK" || echo "Js   Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN ts	| grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Ts   OK" || echo "Ts    Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN py | grep -E '^(A|.+S0.+S1|1)' | wc -l | grep -q 3 && echo "Py   OK" || echo "Py    Fail"
	@make FUFILES="Timeit.fu Rand.fu Stats.fu Matrix.fu Mgraph.fu Mcgraph.fu" APP=Mcgraph MAIN=MCGRAPHMAIN swift | grep -E '^(A|.+S0.+S1|1\.0)' | wc -l | grep -q 3 && echo "Swift OK" || echo "Swift    Fail"	


csvparser:
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN c     2> /dev/null| $(CSVREADERCHECK) && echo "C     OK" || echo "C     Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN cpp   2> /dev/null| $(CSVREADERCHECK) && echo "C++   OK" || echo "C++   Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN cs    2> /dev/null| $(CSVREADERCHECK) && echo "C#    OK" || echo "C#    Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN d     2> /dev/null| $(CSVREADERCHECK) && echo "D     OK" || echo "D     Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN java  2> /dev/null| $(CSVREADERCHECK) && echo "Java  OK" || echo "Java  Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN js    2> /dev/null| $(CSVREADERCHECK) && echo "Js    OK" || echo "Js  Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN py    2> /dev/null| $(CSVREADERCHECK) && echo "Py    OK" || echo "Py  Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN swift  2> /dev/null| $(CSVREADERCHECK) && echo "Swift OK" || echo "Swift Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Matrix.fu Stats.fu CSVParser.fu" ARGS=test/testm.csv APP=CSVParser MAIN=CSVPARSERMAIN ts    2> /dev/null| $(CSVREADERCHECK) && echo "Ts    OK" || echo "Ts  Fail"

fsystem:
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-c.txt"     c     2> /dev/null| $(FSYSCHECK) && echo "C     OK" || echo "C     Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-cpp.txt"   cpp   2> /dev/null| $(FSYSCHECK) && echo "CPP   OK" || echo "Cpp   Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-cs.txt"    cs    2> /dev/null| $(FSYSCHECK) && echo "C#    OK" || echo "C#    Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-d.txt"     d     2> /dev/null| $(FSYSCHECK) && echo "D     OK" || echo "D     Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-java.txt"  java  2> /dev/null| $(FSYSCHECK) && echo "Java  OK" || echo "Java  Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-js.txt"    js    2> /dev/null| $(FSYSCHECK) && echo "Js    OK" || echo "Js    Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-py.txt"    py    2> /dev/null| $(FSYSCHECK) && echo "Py    OK" || echo "Py    Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-swift.txt" swift 2> /dev/null| $(FSYSCHECK) && echo "Swift OK" || echo "Swift Fail"
	@make FUFILES="FileSystem.fu" APP=FileSystem MAIN=FILESYSTEMMAIN ARGS="test/test.txt test/out-ts.txt"    ts    2> /dev/null| $(FSYSCHECK) && echo "Ts    OK" || echo "Ts    Fail"

snha:
	make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN c     | $(CHECKSNHA) && echo "C     OK" || echo "C     Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN cpp   | $(CHECKSNHA) && echo "C++   OK" || echo "C++   Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN cs    | $(CHECKSNHA) && echo "C#    OK" || echo "C#    Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN d     | $(CHECKSNHA) && echo "D     OK" || echo "D     Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN java  | $(CHECKSNHA) && echo "Java  OK" || echo "Java  Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN js    | $(CHECKSNHA) && echo "Js    OK" || echo "Js    Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN py    | $(CHECKSNHA) && echo "py    OK" || echo "py    Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN swift | $(CHECKSNHA) && echo "Swift OK" || echo "Swift Fail"
	@make FUFILES="FileSystem.fu FloatVector.fu Rand.fu Matrix.fu CSVParser.fu ListUtils.fu Stats.fu SNHA.fu" APP=SNHA MAIN=SNHAMAIN ts    | $(CHECKSNHA) && echo "Ts    OK" || echo "Ts    Fail"

timeit:
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN c     | grep Required && echo "C     OK" || echo "C     Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN cpp   | grep Required && echo "C++   OK" || echo "C++   Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN cs    | grep Required && echo "C#    OK" || echo "C#    Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN d     | grep Required && echo "D     OK" || echo "D     Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN java  | grep Required && echo "Java  OK" || echo "Java  Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN js    | grep Required && echo "Js    OK" || echo "Js    Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN py    | grep Required && echo "Py    OK" || echo "Py    Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN swift | grep Required && echo "Swift OK" || echo "Swift Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN ts    | grep Required && echo "Ts    OK" || echo "Ts    Fail"
	@make FUFILES="Timeit.fu" APP=Timeit  MAIN=TIMEITMAIN bjs    | grep Required && echo "BJs    OK" || echo "BJs    Fail"	

listutils:
	make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN c      | grep -q OK && echo "C     OK" || echo "C     Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN cpp   | grep -q OK && echo "C++   OK" || echo "C++   Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN cs    | grep -q OK && echo "C#    OK" || echo "Cs    Fail"	
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN d     | grep -q OK && echo "D     OK" || echo "D     Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN java  | grep -q OK && echo "Java  OK" || echo "Java  Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN js    | grep -q OK && echo "Js    OK" || echo "Js    Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN py    | grep -q OK && echo "Py    OK" || echo "py    Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN ts    | grep -q OK && echo "Ts    OK" || echo "Ts    Fail"
	@make FUFILES="ListUtils.fu" APP=ListUtils MAIN=LISTUTILSMAIN swift 2>/dev/null | grep -q OK && echo "Swift OK" || echo "Swift Fail"
