#!/bin/bash
matlab -nodisplay -r "addpath('matlab/'); convertlines('$1'); convertGraph('$1'); exit;"
./RatioContour4 $1
matlab -nodesktop -r "addpath('matlab/'); displayResults('$1'); exit;" 
