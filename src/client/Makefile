# proxy makefile that copies all lua sources and links data

# assume unix by default
all: unix

unix: main.lua
	cp *.lua ../../build/
	rm -rf ../../build/lib
	mkdir ../../build/lib
	cp lib/*.lua ../../build/lib
	#ln -sf ../../data ../../build/data

win32: main.lua
	copy *.lua ..\..\build
	md ..\..\build\lib

	echo Data cannot be symbolically linked on Windows, please copy the \data folder to \build manually.
	pause > nul
