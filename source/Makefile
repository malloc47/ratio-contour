# definitions
objRRC = main.o construct_graph.o mat_main.o match.o
srcRRC = main.cpp construct_graph.cpp mat_main.cpp match.c
objbatch = batchRRC.o
srcbatch = batchRRC.cpp
objshare = CmdLine.o
srcshare = CmdLine.cpp

#linker to use
lnk = g++
#compiler to use
cc = gcc
#uncomment for debugging
#dbg = -g -Wall

# MAKE it happen

all: RRC batchRRC

RRC: $(objRRC) $(objshare)
	$(lnk) $(dbg) -o RRC $(objRRC) $(objshare)

$(objRRC): $(srcRRC)
	$(cc) $(dbg) -c $(srcRRC)

batchRRC: $(objbatch) $(objshare)
	$(lnk) $(dbg) -o batchRRC $(objbatch) $(objshare)

$(objbatch): $(srcbatch)
	$(cc) $(dbg) -c $(srcbatch)

$(objshare): $(srcshare)
	$(cc) $(dbg) -c $(srcshare)

install:
	@mv RRC batchRRC ..

clean:
	@rm -f $(objRRC) $(objbatch) $(objshare) RRC batchRRC

