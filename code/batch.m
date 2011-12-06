function batch(folder, LAMBDA);

list = dir(strcat(folder,'*.pgm'));

for i=1:size(list,1)
    name = list(i).name(1:(size(list(i).name,2)-4));
    CRR(strcat(folder,name), LAMBDA);
    fclose('all');
end




