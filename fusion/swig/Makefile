# --- Modules

# --- Configuration ---
MODULE_NAME = mglib

INTERFACE   = $(MODULE_NAME).i
WRAPPER     = $(MODULE_NAME)_wrap.c
TARGET      = $(MODULE_NAME).so

# Paths for Tcl 8.6 (System Default)
TCL8_INC = /usr/include/tcl8.6
TCL8_LIB = -ltcl8.6

# Paths for Tcl 9 (User Local)
TCL9_ROOT = $(HOME)/.local/opt
TCL9_INC  = $(TCL9_ROOT)/include
TCL9_LIB  = -L$(TCL9_ROOT)/lib -ltcl9.0

# --- Directories ---
SRC_DIR = src
SWIG_DIR = swig
BIN_DIR = bin

# --- Tools & General Flags ---
CC = gcc
SWIG = swig
CFLAGS = -O2 -fPIC $(shell pkg-config --cflags glib-2.0)
LIBS = $(shell pkg-config --libs glib-2.0)

# --- Language Specific Setup ---
# Tcl
ifneq ("$(wildcard /usr/include/tcl8.6)","")
   TCL8_INC = -I/usr/include/tcl8.6
   TCL8_LIB = -ltcl8.6
   TCL9_ROOT = $(HOME)/.local/opt
   TCL9_INC  = -I$(TCL9_ROOT)/include
   TCL9_LIB  = -L$(TCL9_ROOT)/lib -ltcl9.0
   #TCL_INC = -I/usr/include/tcl8.6 # Change to 8.6 if needed
else
   TCL_INC = -I/usr/include/ # Change to 8.6 if needed
   TCL9_ROOT = /usr
   TCL9_INC  = -I$(TCL9_ROOT)/include
   TCL9_LIB  = -L$(TCL9_ROOT)/lib -ltcl9.0
endif	
TCL_LIB = -ltcl

# Lua (Auto-detecting 5.1 vs 5.4)
LUA_INC = -I/usr/include
ifneq ("$(wildcard /usr/include/lua5.1)","")
    LUA_INC = -I/usr/include/lua5.1
    LUA_LIB = -llua5.1
else
    LUA_LIB = -llua
endif

# Python
PY_INC = $(shell pkg-config --cflags python3)
PY_LIB = $(shell pkg-config --libs python3)

# --- Testing Targets ---

.PHONY: tcl-test lua-test py-test test-all

# Create directories if they don't exist
# Core Object Files
OFILES = $(BIN_DIR)/ghash.o $(BIN_DIR)/garray.o $(BIN_DIR)/glist.o $(BIN_DIR)/gtree.o $(BIN_DIR)/gqueue.o
TFILES = $(BIN_DIR)/gtree_test.o $(BIN_DIR)/glist_test.o $(BIN_DIR)/ghash_test.o

all: prepare tcl8 tcl9 lua python

prepare:
	@mkdir -p $(BIN_DIR)/tcl8 $(BIN_DIR)/tcl9 $(BIN_DIR)/lua $(BIN_DIR)/python

# Compile C Logic
$(BIN_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# --- Tcl Build ---
tcl8: $(OFILES) $(TFILES)
	$(SWIG) -tcl8 -namespace -o $(BIN_DIR)/$@/mglib_wrap.c $(SWIG_DIR)/mglib.i
	$(CC) $(CFLAGS) $(TCL8_INC) -c $(BIN_DIR)/$@/mglib_wrap.c -o $(BIN_DIR)/$@/mglib_wrap.o
	$(CC) -shared $(OFILES) $(TFILES) $(BIN_DIR)/$@/mglib_wrap.o -o $(BIN_DIR)/$@/mglib.so $(LIBS) $(TCL_LIB)

tcl9: $(OFILES) $(TFILES)
	$(SWIG) -tcl -namespace -o $(BIN_DIR)/$@/mglib_wrap.c $(SWIG_DIR)/mglib.i
	$(CC) $(CFLAGS) $(TCL9_INC) -c $(BIN_DIR)/$@/mglib_wrap.c -o $(BIN_DIR)/$@/mglib_wrap.o
	$(CC) -shared $(OFILES) $(TFILES) $(BIN_DIR)/$@/mglib_wrap.o -o $(BIN_DIR)/$@/mglib.so $(LIBS) $(TCL9_LIB)

# --- Lua Build ---
lua: $(OFILES) $(TFILES)
	$(SWIG) -lua -o $(BIN_DIR)/lua/mglib_wrap.c $(SWIG_DIR)/mglib.i
	$(CC) $(CFLAGS) $(LUA_INC) -c $(BIN_DIR)/lua/mglib_wrap.c -o $(BIN_DIR)/lua/mglib_wrap.o
	$(CC) -shared $(OFILES) $(TFILES) $(BIN_DIR)/lua/mglib_wrap.o -o $(BIN_DIR)/lua/mglib.so $(LIBS) $(LUA_LIB)

# --- Python Build ---
py: $(OFILES) $(TFILES)
	$(SWIG) -python -o $(BIN_DIR)/python/mglib_wrap.c $(SWIG_DIR)/mglib.i
	$(CC) $(CFLAGS) $(PY_INC) -c $(BIN_DIR)/python/mglib_wrap.c -o $(BIN_DIR)/python/mglib_wrap.o
	$(CC) -shared $(OFILES) $(TFILES) $(BIN_DIR)/python/mglib_wrap.o -o $(BIN_DIR)/python/_mglib.so $(LIBS) $(PY_LIB)

clean:
	rm -rf $(BIN_DIR)

tcl9-test: tcl9
	@echo "Running Tcl Tests..."
	cd $(BIN_DIR)/tcl9 && LD_LIBRARY_PATH=~/.local/opt/lib tclsh ../../tests/garray.tcl
	cd $(BIN_DIR)/tcl9 && LD_LIBRARY_PATH=~/.local/opt/lib tclsh ../../tests/ghash.tcl
	cd $(BIN_DIR)/tcl9 && LD_LIBRARY_PATH=~/.local/opt/lib tclsh ../../tests/glist.tcl
	cd $(BIN_DIR)/tcl9 && LD_LIBRARY_PATH=~/.local/opt/lib tclsh ../../tests/gtree.tcl
	cd $(BIN_DIR)/tcl9 && LD_LIBRARY_PATH=~/.local/opt/lib tclsh ../../tests/gqueue.tcl

tcl8-test: tcl8
	@echo "Running Tcl Tests..."
	cd $(BIN_DIR)/tcl8 && tclsh ../../tests/garray.tcl
	cd $(BIN_DIR)/tcl8 && tclsh ../../tests/ghash.tcl
	cd $(BIN_DIR)/tcl8 && tclsh ../../tests/glist.tcl
	cd $(BIN_DIR)/tcl8 && tclsh ../../tests/gtree.tcl
	cd $(BIN_DIR)/tcl8 && tclsh ../../tests/gqueue.tcl

# Lua Test
lua-test: lua
	@echo "Running Lua Tests..."
	# LUA_CPATH tells Lua where to find .so files
	cd $(BIN_DIR)/lua && LUA_CPATH="./?.so;;" lua ../../tests/garray.lua
	cd $(BIN_DIR)/lua && LUA_CPATH="./?.so;;" lua ../../tests/ghash.lua
	cd $(BIN_DIR)/lua && LUA_CPATH="./?.so;;" lua ../../tests/glist.lua
	cd $(BIN_DIR)/lua && LUA_CPATH="./?.so;;" lua ../../tests/gtree.lua
	cd $(BIN_DIR)/lua && LUA_CPATH="./?.so;;" lua ../../tests/gqueue.lua

# Python Test
py-test: py
	@echo "Running Python Tests..."
	# PYTHONPATH tells Python where to find .py and _example.so files
	cd $(BIN_DIR)/python && PYTHONPATH=. python3 ../../tests/garray.py
	cd $(BIN_DIR)/python && PYTHONPATH=. python3 ../../tests/ghash.py	
	cd $(BIN_DIR)/python && PYTHONPATH=. python3 ../../tests/glist.py
	cd $(BIN_DIR)/python && PYTHONPATH=. python3 ../../tests/gtree.py
	cd $(BIN_DIR)/python && PYTHONPATH=. python3 ../../tests/gqueue.py

# Run all tests in sequence
test-all: tcl-test lua-test py-test
	@echo "All 'Holy Trinity' tests passed!"
