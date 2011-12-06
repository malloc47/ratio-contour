#define CC_PROTOTYPE_ANSI
extern "C" {
#include "match.h" 
}
#include <cstdio>
#include <vector>
#include <string>

using namespace std;

//static void usage (char *name);
//static int parseargs (int ac, char **av);

int CCutil_getedgelist_n2 (vector<double*> *graph, int ncount, int ecount, int **elist, int **elen, int **elen2, int **esolid);


static char match_file[256];
static char edgefilename[256];
//static int nnodes_want = 0;


int RC(vector<double*> *graph, int ncount, int ecount, int NumIteration, string fname)
{
    int *elist = NULL;
    int *elen = NULL;
    int *elen2 = NULL;
    int *esolid = NULL;

    snprintf(edgefilename, sizeof(edgefilename), "%s.w", fname.c_str());
    snprintf(match_file, sizeof(match_file), "%s", fname.c_str()); /* .cycle is added in match.c */


    if (CCutil_getedgelist_n2 (graph, ncount, ecount,
                               &elist, &elen, &elen2, &esolid)) {
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

int CCutil_getedgelist_n2(vector<double*> *graph, int ncount, int ecount, 
                                 int **elist, int **elen, int **elen2, int **esolid)
{

    int i, k;
    double *edge;

    *elist = new int[2*ecount];
    *elen = new int[ecount];
    *elen2 = new int[ecount];
    *esolid = new int[ecount];


    for (i = 0, k = 0; i < ecount; i++) {
        edge = (*graph)[i];
        (*elist)[k++] = (int)edge[0];
        (*elist)[k++] = (int)edge[1];
        (*elen)[i] = (int)edge[2]; 
        (*elen2)[i] = (int)edge[3];
        (*esolid)[i] = (int)edge[4];
    }

    return 0;
}
