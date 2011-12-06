# Change these parameters how you want them to be
           CC = cc
       CFLAGS = -g 

# From here nothing needs to be changed
           LD = $(CC)

         LIBS = -lm 

      BLOSSOM = mat_main.c match.c

  BLOSSOMOBJS = $(BLOSSOM:.c=.o)

all    : RatioContour3

RatioContour3    : $(BLOSSOMOBJS)
	 $(LD) -o $@  $(BLOSSOMOBJS) -lm 

install : all

clean  :
	rm -f *.o RatioContour3

depend :
	makedepend $(INCDIRS) $(SEQU)

.c.o :
	$(CC) $(CFLAGS) $(INCDIRS) -c $*.c


