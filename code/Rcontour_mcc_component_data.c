/*
 * MATLAB Compiler: 4.3 (R14SP3)
 * Date: Thu Dec 15 16:35:36 2005
 * Arguments: "-B" "macro_default" "-m" "-W" "main" "-T" "link:exe"
 * "Rcontour.m" "batch.m" "curvature.m" "curve_length.m" "display_cycle.m"
 * "display_lines.m" "display_mpoints.m" "edgelink.m" "generate_lines_img.m"
 * "get_canny.m" "line_detect.m" "lineseg.m" "main_loop5.m" "main_loop.m"
 * "maxlinedev.m" "mergeseg.m" "overlap_cycle.m" "preprocess.m" "Rcontour.m" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_Rcontour_session_key[] = {
        '7', 'C', '8', '0', '5', '6', '6', 'E', '6', '1', 'F', '7', '0', 'B',
        '3', '9', '1', '0', '1', '2', '2', '2', '0', '8', 'A', '7', '4', '8',
        '0', '8', '2', 'E', 'B', '5', 'B', '3', '4', '5', 'D', '4', 'F', '2',
        'E', 'A', '1', 'A', '3', '7', 'F', 'C', 'C', '5', 'E', '6', 'B', '9',
        '0', '5', 'D', '1', 'F', 'E', '5', '5', '0', 'C', 'C', '0', '3', '3',
        '1', '7', '2', '1', '2', 'D', '3', 'D', 'B', '6', 'E', 'F', '2', '5',
        'D', 'D', 'A', 'D', '1', 'D', 'F', 'E', '3', 'A', '3', '8', '8', '7',
        '9', '8', '4', '3', '7', 'C', '9', '2', '8', '1', 'D', 'A', 'B', '8',
        '2', 'A', '7', '7', '4', '2', 'F', '8', 'C', '9', '3', '1', '5', '2',
        'B', '1', '5', '6', '9', 'E', '8', 'A', 'E', 'B', 'C', '1', '0', '8',
        '0', '9', 'D', '1', 'F', '6', '9', 'A', '7', '2', '1', 'F', '7', '5',
        '3', '4', '9', '8', '3', '7', '6', 'D', '1', '4', '6', 'A', '7', '2',
        '6', '2', 'F', '9', 'B', '1', '2', '9', '1', '6', '8', '1', '7', '6',
        '8', '6', '9', '4', 'B', '0', '7', '7', '8', '4', 'A', 'A', 'D', '7',
        '8', 'D', '4', '1', '9', '4', '5', 'A', '3', 'E', '4', '3', '4', '5',
        '3', 'B', '9', '7', 'B', '7', '3', 'A', 'A', 'E', 'E', '6', 'E', '1',
        '1', '5', '3', 'F', '8', 'C', 'A', 'F', 'E', '8', '5', '0', '8', 'C',
        '9', 'B', 'C', '9', '7', 'F', '5', '2', 'B', '2', 'A', 'C', '4', '2',
        'F', '9', '7', '2', '\0'};

const unsigned char __MCC_Rcontour_public_key[] = {
        '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9',
        '2', 'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1',
        '0', '1', '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B',
        '0', '0', '3', '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1',
        '0', '0', 'C', '4', '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3',
        'A', '5', '2', '0', '6', '5', '8', 'F', '6', 'F', '8', 'E', '0', '1',
        '3', '8', 'C', '4', '3', '1', '5', 'B', '4', '3', '1', '5', '2', '7',
        '7', 'E', 'D', '3', 'F', '7', 'D', 'A', 'E', '5', '3', '0', '9', '9',
        'D', 'B', '0', '8', 'E', 'E', '5', '8', '9', 'F', '8', '0', '4', 'D',
        '4', 'B', '9', '8', '1', '3', '2', '6', 'A', '5', '2', 'C', 'C', 'E',
        '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4', 'D', '0', '8', '5',
        'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2', 'E', 'D', 'E',
        '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6', '3', '7',
        '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E', '6',
        '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
        '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1',
        'B', 'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9',
        '9', '0', '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0',
        'B', '6', '1', 'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B',
        '5', '8', 'F', 'C', '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6',
        'E', 'B', '7', 'E', 'C', 'D', '3', '1', '7', '8', 'B', '5', '6', 'A',
        'B', '0', 'F', 'A', '0', '6', 'D', 'D', '6', '4', '9', '6', '7', 'C',
        'B', '1', '4', '9', 'E', '5', '0', '2', '0', '1', '1', '1', '\0'};

static const char * MCC_Rcontour_matlabpath_data[] = 
    { "Rcontour/", "toolbox/compiler/deploy/",
      "$TOOLBOXMATLABDIR/general/", "$TOOLBOXMATLABDIR/ops/",
      "$TOOLBOXMATLABDIR/lang/", "$TOOLBOXMATLABDIR/elmat/",
      "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
      "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
      "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
      "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
      "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
      "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
      "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
      "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
      "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
      "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
      "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
      "$TOOLBOXMATLABDIR/demos/", "$TOOLBOXMATLABDIR/timeseries/",
      "$TOOLBOXMATLABDIR/hds/", "toolbox/local/", "toolbox/compiler/",
      "toolbox/images/images/", "toolbox/images/imuitools/",
      "toolbox/images/iptutils/", "toolbox/shared/imageslib/",
      "toolbox/images/medformats/", "toolbox/optim/" };

static const char * MCC_Rcontour_classpath_data[] = 
    { "java/jar/toolbox/images.jar" };

static const char * MCC_Rcontour_libpath_data[] = 
    { "" };

static const char * MCC_Rcontour_app_opts_data[] = 
    { "" };

static const char * MCC_Rcontour_run_opts_data[] = 
    { "" };

static const char * MCC_Rcontour_warning_state_data[] = 
    { "" };


mclComponentData __MCC_Rcontour_component_data = { 

    /* Public key data */
    __MCC_Rcontour_public_key,

    /* Component name */
    "Rcontour",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_Rcontour_session_key,

    /* Component's MATLAB Path */
    MCC_Rcontour_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    39,

    /* Component's Java class path */
    MCC_Rcontour_classpath_data,
    /* Number of directories in the Java class path */
    1,

    /* Component's load library path (for extra shared libraries) */
    MCC_Rcontour_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_Rcontour_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_Rcontour_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "Rcontour_63CEF3FFA1BE1716DDB3E52EE2C967B1",

    /* MCR warning status data */
    MCC_Rcontour_warning_state_data,
    /* Number of MCR warning status modifiers */
    0,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


