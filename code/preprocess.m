
function preprocess(fname, LAMBDA);
%
% FUNCTION preprocess
%
% preprocesses the PGM image 'filename.pgm' (given without
% extension) and returns a list of fragments constructed.
%
% Joachim Stahl
% June 16, 2005
%
% This program uses the functions 'edgelink', 'lineseg', 'maxlinedev'
% and 'mergeseg' created by
%   Peter Kovesi
%   University of Western Australia
%   http://www.csse.uwa.edu.au/~pk
%



% Read original image
im = imread([fname '.pgm']);

% Do canny edge detection
bw = edge(im,'canny');

max_dist = 30; %min(size(im))/8;

edgelist = edgelink(bw, round(max(size(im))/10));
% lines is Nx5 [X1 Y1 X2 Y2 e tl], e indicates the edge track to which the
% line came from, tl is the length of that track.
lines = lineseg(edgelist, 2);


% Convert lines list to midpoint list
% mpoints = [x, y, theta, d]
mpoints=[];
for i=1:size(lines,1)
    mpoints(i,1) = lines(i,1) + (lines(i,3)-lines(i,1))/2;
    mpoints(i,2) = lines(i,2) + (lines(i,4)-lines(i,2))/2;
    if (lines(i,1) ~= lines(i,3))
        mpoints(i,3) = atan( (lines(i,4)-lines(i,2)) / (lines(i,3)-lines(i,1)) );
    else
        mpoints(i,3) = pi/2;
    end
    mpoints(i,4) = norm(lines(i,1:2)-lines(i,3:4))/2;
end



% turn off possible div. by zero warnings
% In this case, it is ok to div. by zero
% since Matlab considers atan(inf) = pi/2
warning off MATLAB:divideByZero;

% Create fragments table
table = [];
count = 0;
display('Starting process...');
pctg = 0;
display('0 %');
for i=1:size(mpoints,1)
    if (floor( (10*i)/(size(mpoints,1))) > pctg)
        pctg = pctg + 1;
        display(strcat(int2str(pctg*10), ' %'));
    end
    m1 = (lines(i,2) - lines(i,4))/(lines(i,1) - lines(i,3));
    b1 = lines(i,2) - m1*lines(i,1);
    for j=i+1:size(mpoints,1)

        % distances between endpoints
        dist(1) = norm([lines(i,1:2)]-[lines(j,1:2)]);
        dist(2) = norm([lines(i,3:4)]-[lines(j,1:2)]);
        dist(3) = norm([lines(i,1:2)]-[lines(j,3:4)]);
        dist(4) = norm([lines(i,3:4)]-[lines(j,3:4)]);
        dist(5) = inf;

        [mindist indx] = min(dist);

        if (mindist < max_dist)
            switch indx
                case 1
                    xy1 = lines(i,1:2);
                    xy2 = lines(j,1:2);
                case 2
                    xy1 = lines(i,3:4);
                    xy2 = lines(j,1:2);
                case 3
                    xy1 = lines(i,1:2);
                    xy2 = lines(j,3:4);
                case 4
                    xy1 = lines(i,3:4);
                    xy2 = lines(j,3:4);
            end

            % total length of arc (incl. detected part)
            tlength = mpoints(i,4) + mpoints(j,4) + mindist;
            curv = curvature(mpoints(i,1:2), xy1, xy2, mpoints(j,1:2));
            tweight = (mindist + LAMBDA*curv)/tlength;

            m2 = (lines(j,2) - lines(j,4))/(lines(j,1) - lines(j,3));
            b2 = lines(j,2) - m2*lines(j,1);
            I(1) = (b2 - b1) / (m1 - m2);
            I(2) = m1*I(1) + b1;
            indxC = 0;

            if ( ( ( (lines(i,1) < I(1)) & (I(1) < lines(i,3)) ) || ( (lines(i,3) < I(1)) & (I(1) < lines(i,1)) ) ) && ( ( (lines(i,2) < I(2)) & (I(2) < lines(i,4)) ) || ( (lines(i,4) < I(2)) & (I(2) < lines(i,2)) ) ) )
                tempxy1 = I;
                mpointj = mpoints(j,1:2);
                if ( norm([tempxy1] - [lines(i,1:2)]) < norm([tempxy1] - [lines(i,3:4)]) )
                    indxC = 1;
                    mpointi = [(tempxy1(1)+lines(i,3))/2 (tempxy1(2)+lines(i,4))/2];
                else
                    indxC = 3;
                    mpointi = [(tempxy1(1)+lines(i,1))/2 (tempxy1(2)+lines(i,2))/2];
                end
                if ( norm([tempxy1] - [lines(j,1:2)]) < norm([tempxy1] - [lines(j,3:4)]) )
                    dist(5) = norm([tempxy1] - [lines(j,1:2)]);
                    tempxy2 = lines(j,1:2);
                else
                    dist(5) = norm([tempxy1] - [lines(j,3:4)]);
                    tempxy2 = lines(j,3:4);
                end
            elseif ( ( ( (lines(j,1) < I(1)) & (I(1) < lines(j,3)) ) || ( (lines(j,3) < I(1)) & (I(1) < lines(j,1)) ) ) && ( ( (lines(j,2) < I(2)) & (I(2) < lines(j,4)) ) || ( (lines(j,4) < I(2)) & (I(2) < lines(j,2)) ) ) )
                tempxy2 = I;
                mpointi = mpoints(i,1:2);
                if ( norm([tempxy2] - [lines(j,1:2)]) < norm([tempxy2] - [lines(j,3:4)]) )
                    indxC = 2;
                    mpointj = [(tempxy2(1)+lines(j,3))/2 (tempxy2(2)+lines(j,4))/2];
                else
                    indxC = 4;
                    mpointj = [(tempxy2(1)+lines(j,1))/2 (tempxy2(2)+lines(j,2))/2];
                end
                if ( norm([tempxy2] - [lines(i,1:2)]) < norm([tempxy2] - [lines(i,3:4)]) )
                    dist(5) = norm([tempxy2] - [lines(i,1:2)]);
                    tempxy1 = lines(i,1:2);
                else
                    dist(5) = norm([tempxy2] - [lines(i,3:4)]);
                    tempxy1 = lines(i,3:4);
                end
            end
            if (dist(5) ~= inf)
                curvC = curvature(mpointi, tempxy1, tempxy2, mpointj);
                tlengthC = norm(mpointi - tempxy1) + norm(mpointj - tempxy2) + dist(5);
                tweightC = (dist(5) + LAMBDA*curvC)/(tlengthC);
                if (tweightC < tweight)
                    xy1 = tempxy1;
                    xy2 = tempxy2;
                    curv = curvC;
                    mindist = dist(5);
                    tlength = tlengthC;
                    tweight = tweightC;
                    if (indxC == 1)
                        if ( (indx == 2) | (indx == 4) )
                            indx = indx - 1;
                        end
                    elseif (indxC == 2)
                        if ( (indx == 3) | (indx == 4) )
                            indx = indx - 2;
                        end
                    elseif (indxC == 3)
                        if ( (indx == 1) | (indx == 3) )
                            indx = indx + 1;
                        end
                    elseif (indxC == 4)
                        if ( (indx == 1) | (indx == 2) )
                            indx = indx + 2;
                        end
                    end
                end
            end

            MPC = [(xy1(1)+xy2(1))/2, (xy1(2)+xy2(2))/2];


            n1 = 2*i - 1;
            n2 = 2*j - 1;
            if ((indx == 1) | (indx == 3))
                n1 = n1 - 1;
            end
            if ((indx == 1) | (indx == 2))
                n2 = n2 - 1;
            end


            count = count + 1;
            % [index1, index2, M1(x,y), P1(x,y),MPC(x,y), P2(x,y), M2(x,y), length(gap-filling), curvature, length(total)]
            table(count,:) = [n1,n2,mpoints(i,1:2),xy1,MPC,xy2,mpoints(j,1:2),mindist,curv,tlength];
        end
    end
end

save([fname '-tableRC'],'table');
save([fname '-mpointsRC'],'mpoints');

return;
