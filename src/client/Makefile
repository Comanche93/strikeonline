# proxy makefile that copies all lua sources and links data

# assume unix by default
all: unix

unix: main.lua
	cp *.lua ../../build/
	ln -sf ../../data ../../build/data

win32: main.lua
	copy *.lua
	echo Data cannot be symbolically linked on Windows, please copy the \data folder to \build manually.
	pause > nul
