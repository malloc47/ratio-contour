# definitions
objRRC = main.o construct_graph.o mat_main.o match.o CmdLine.o
srcRRC = main.cpp construct_graph.cpp mat_main.cpp match.c CmdLine.cpp

#linker to use
lnk = g++
#compiler to use
cc = gcc
#uncomment for debugging
#dbg = -g -Wall

# MAKE it happen

all: RRC 

RRC: $(objRRC)
	$(lnk) $(dbg) -o RRC $(objRRC)

$(objRRC): $(srcRRC)
	$(cc) $(dbg) -c $(srcRRC)

install:
	@mv RRC ..

clean:
	@rm -f $(objRRC) RRC

