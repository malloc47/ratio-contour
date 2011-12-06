function batchPreprocess(dirname);

D = dir([dirname '/*.pgm']);

for i=1:size(D,1)
    fname = [dirname '/' D(i).name];
    fname = fname(1,1:size(fname,2)-4); % remove extension
    preprocess(fname);
end

return;