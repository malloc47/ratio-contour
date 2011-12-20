function extractlines(filename)
	img = imread([filename '-berkeley.pgm']);
	%img = seg2bmap(dlmread([filename '.labels'],' '));
    img = bwmorph(img,'thin',Inf);  % make sure edges are thinned.
    img = bwmorph(img,'clean'); 
	%img = seg2bmap(dlmread('regions.labels',' '));
	edgelist = edgelink(img, 1);
	lines = lineseg(edgelist, 0.1);
	display(['Lines: ' int2str(size(lines,1))]);
	fid = fopen([filename '.lines'], 'w');
	fprintf(fid, '%g %g %g %g\n', lines');
	fclose(fid);
end
