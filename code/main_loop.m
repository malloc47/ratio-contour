function [answer RC]=main_loop(input, mpoints, LAMBDA);

% FUNCTION main_loop
% Takes as parameters, input, the list of arcs generated
% by the preprocessing, mpoints, the list of line segments
% converted to midpoints list, and image I.

% constants
psize = size(mpoints,1);

% various initializations
answer = [];
minw = inf;
BigP = [];
supermax = 0;
smooth = 0;

count = 0;
temptable = [];
for i=1:size(input,1)
    % Generates input for RatioContour for each semiplane
    count = count + 1;
    temptable(count,:) = [input(i,1:2), input(i,13)+LAMBDA*input(i,14), input(i,15), 0];
end

cap = mean(temptable(:,3))*2;
count = 0;
table = [];
for i=1:psize
    count = count + 1;
    table(count,:) = [2*i-2, 2*i-1, 0, 0, 1];
end
for i=1:size(temptable,1)
    if (temptable(i,3) < cap)
        count = count + 1;
        table(count,:) = temptable(i,:);
    end
end

% Values used to normalize the values in the tables
% to the 0..100 range for RatioContour.
maxW = max(table(:,3));
maxL = max(table(:,4));

%run RatioContour on right semiplane
if (maxW > 0)
    fid = fopen('tmp/temp.w','w');
    fprintf(fid, '%g %g\n', psize*2, count);
    for i=1:count
        fprintf(fid, '%g %g %g %g %g\n', table(i,1:2), round(table(i,3)*600/maxW), round(table(i,4)*600/maxL), table(i,5));
    end
    fclose(fid);
    !./RatioContour3 tmp/temp

    fid = fopen('tmp/temp-0.cycle','r');
    num = fscanf(fid, '%d',1);
    answer = (fscanf(fid,'%d',[6,num]))';
    weight = sum(answer(:,3)) * maxW / 600;
    length = sum(answer(:,4)) * maxL / 600;
    RC = weight / length
    fclose(fid);

end

return;
