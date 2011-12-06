#define CC_PROTOTYPE_ANSI

#include "match.h" 
#include "stdio.h"

#ifdef CC_PROTOTYPE_ANSI

static void
    usage (char *name);
static int
    parseargs (int ac, char **av);

#else
static void
    usage ();
static int
    parseargs ();

#endif

#ifdef CC_PROTOTYPE_ANSI
extern int 
       CCutil_getedgelist_n2 (int *ncount, char *fname, int *ecount, 
           int **elist, int **elen, int **elen2, int **esolid);
#else
extern int 
       CCutil_getedgelist_n2 ();
#endif


static char match_file[256];
static char edgefilename[256];
static int nnodes_want = 0;

#ifdef CC_PROTOTYPE_ANSI
int  main (int ac, char **av)
#else
int  main (ac, av)
int ac;
char **av;
#endif
{
    int ncount, ecount;
    int *elist = (int *) NULL;
    int *elen = (int *) NULL;
    int *elen2 = (int *) NULL;
    int *esolid = (int *) NULL;
    int NumIteration;

    if ((ac != 2) && (ac !=3)){
       fprintf (stderr, "\n====================================================================\n");
       fprintf (stderr, "This is updated package (Oct 08, 2004) for Ratio-Contour algorithm.\n");
       fprintf (stderr, " (1) In this version, solid edge weight and length can be nonzero.\n");
       fprintf (stderr, " (2) Zero will be returned when no alternate cycle is in the graph.\n");
       fprintf (stderr, " (3) Fix a bug in previous release on May 06, 2004, to produce ONLY ONE cycle.\n");
       fprintf (stderr, "                    ---Song Wang, 10/08/2004.\n");           
       fprintf (stderr, "------------------------------------------------------------------\n");
       fprintf (stderr, "Usage: RatioContour3 image [NumIter(1)]\n\n");
       fprintf (stderr, "       Note: image is a image.w file with the format:\n");
       fprintf (stderr, "       Head line: #v(even)  #e \n");
       fprintf (stderr, "       Each line: v1 v2 weight length solid(1)/dashed(0)\n");     
       fprintf (stderr, "\n====================================================================\n");
       goto CLEANUP;
     }

    sprintf(edgefilename, "%s.w", av[1]);
    sprintf(match_file, "%s", av[1]); /* .cycle is added in match.c */

    if (ac == 3)
       NumIteration = atoi(av[2]);
    else 
       NumIteration = 1;
    
    ncount = 0;

    if (CCutil_getedgelist_n2 (&ncount, edgefilename, 
                               &ecount, &elist, &elen, &elen2, &esolid)) {
       fprintf (stderr, "getedgelist_n2 failed\n");
       goto CLEANUP;
     }

    if (min_ratio_cycle (ncount, ecount, &elist, 
                         &elen, &elen2, &esolid, match_file, NumIteration)){
        fprintf (stderr, "ratio-cycle finding failed\n");
        goto CLEANUP;
    }

CLEANUP:
   return 0;
}

/* function to read the edge file. elen -- 
   (first) edge weight; elen2 -- second edge weight;
   esolid -- 1 means solid edge and 0 means dashed edge */

#ifdef CC_PROTOTYPE_ANSI
extern int CCutil_getedgelist_n2 (int *ncount, char *fname, int *ecount, 
                                 int **elist, int **elen, int **elen2, int **esolid)
#else
extern int CCutil_getedgelist_n2 (ncount, fname, ecount, elist, elen, elen2, esolid)
char *fname;
int * ncount, *ecount, **elist, **elen, **elen2, **esolid;
#endif
{
    FILE *in;
    int i, k;

    *elist = (int *) NULL;
    *elen = (int *) NULL;
    *elen2 = (int *) NULL;
    *esolid =(int *) NULL;

    if ((in = fopen (fname, "r")) == (FILE *) NULL) {
        perror (fname);
        fprintf (stderr, "Unable to open %s for input\n", fname);
        return 1;
    }

    k = CCutil_readint (in);
    *ncount = k;
    *ecount = CCutil_readint (in);

    *elist = CC_SAFE_MALLOC(2 * (*ecount), int);
    if (!(*elist)) {
        fprintf (stderr, "out of memory in getedgelist\n");
        fclose (in);
        return 1;
    }

    *elen = CC_SAFE_MALLOC(*ecount, int);
    if (!(*elen)) {
        fprintf (stderr, "out of memory in getedgelist\n");
        CC_FREE (*elen, int);
        fclose (in);
        return 1;
    }

    *elen2 = CC_SAFE_MALLOC(*ecount, int);
    if (!(*elen2)) {
        fprintf (stderr, "out of memory in getedgelist\n");
        CC_FREE (*elen2, int);
        fclose (in);
        return 1;
    }

    *esolid = CC_SAFE_MALLOC(*ecount, int);
    if (!(*esolid)) {
        fprintf (stderr, "out of memory in getedgelist\n");
        CC_FREE (*esolid, int);
        fclose (in);
        return 1;
    }

    for (i = 0, k = 0; i < *ecount; i++) {
        (*elist)[k++] = CCutil_readint (in);
        (*elist)[k++] = CCutil_readint (in);
        (*elen)[i] = CCutil_readint (in); 
        (*elen2)[i] = CCutil_readint (in);
        (*esolid)[i] = CCutil_readint (in);
    }

    fclose (in);

    return 0;
}
