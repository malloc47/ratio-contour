#!/bin/bash
matlab -nodisplay -r "addpath('matlab/'); extractlines('$1'); convertlines('$1',$2); convertGraph('$1'); exit;"
./RatioContour4 $1
matlab -nodesktop -r "addpath('matlab/'); displayResults('$1'); exit;" 
