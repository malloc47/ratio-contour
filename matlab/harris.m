% HARRIS - Harris corner detector
%
% Usage:  [cim, r, c] = harris(im, sigma, thresh, radius, disp)
%
% Arguments:   
%            im     - image to be processed.
%            sigma  - standard deviation of smoothing Gaussian. Typical
%                     values to use might be 1-3.
%            thresh - threshold (optional). Try a value ~1000.
%            radius - radius of region considered in non-maximal
%                     suppression (optional). Typical values to use might
%                     be 1-3.
%            disp   - optional flag (0 or 1) indicating whether you want
%                     to display corners overlayed on the original
%                     image. This can be useful for parameter tuning.
%
% Returns:
%            cim    - binary image marking corners.
%            r      - row coordinates of corner points.
%            c      - column coordinates of corner points.
%
% If thresh and radius are omitted from the argument list 'cim' is returned
% as a raw corner strength image and r and c are returned empty.

% References: 
% C.G. Harris and M.J. Stephens. "A combined corner and edge detector", 
% Proceedings Fourth Alvey Vision Conference, Manchester.
% pp 147-151, 1988.
%
% Alison Noble, "Descriptions of Image Surfaces", PhD thesis, Department
% of Engineering Science, Oxford University 1989, p45.
%
%
% Author: 
% Peter Kovesi   
% Department of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au  
% http://www.csse.uwa.edu.au/~pk
%
% March 2002    - original version
% December 2002 - updated comments

function [cim, r, c] = harris(im, sigma, thresh, radius, disp)
    
    error(nargchk(2,5,nargin));
    
    dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
    dy = dx';
    
    %Ix = conv2(im, dx, 'same');    % Image derivatives
    %Iy = conv2(im, dy, 'same');
    Ix = imfilter(im, dx, 'replicate');
    Iy = imfilter(im, dy, 'replicate');

    % Generate Gaussian filter of size 6*sigma (+/- 3sigma) and of
    % minimum size 1x1.
    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
    
%     Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
%     Iy2 = conv2(Iy.^2, g, 'same');
%     Ixy = conv2(Ix.*Iy, g, 'same');
    Ix2 = imfilter(Ix.^2, g, 'replicate');
    Iy2 = imfilter(Iy.^2, g, 'replicate');
    Ixy = imfilter(Ix.*Iy, g, 'replicate');

    % Compute the Harris corner measure. Note that there are two measures
    % that can be calculated.  I prefer the first one below as given by
    % Nobel in her thesis (reference above).  The second one (commented out)
    % requires setting a parameter, it is commonly suggested that k=0.04 - I
    % find this a bit arbitrary and unsatisfactory. 

    cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); % My preferred  measure.
%    k = 0.04;
%    cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; % Original Harris measure.

    if nargin > 2   % We should perform nonmaximal suppression and threshold
	
	% Extract local maxima by performing a grey scale morphological
	% dilation and then finding points in the corner strength image that
	% match the dilated image and are also greater than the threshold.
	sze = 2*radius+1;                   % Size of mask.
	%mx = ordfilt2(cim,sze^2,ones(sze)); % Grey-scale dilate.
    mx = imdilate(cim, strel('square',sze));
	cim = (cim==mx)&(cim>thresh);       % Find maxima.
	
	[r,c] = find(cim);                  % Find row,col coords.
	
	if nargin==5 & disp      % overlay corners on original image
	    imagesc(im), hold on, axis off, axis equal, colormap(gray);
	    p = plot(c,r,'r.');
        set(p,'MarkerSize',20);
	end
    
    else  % leave cim as a corner strength image and make r and c empty.
	r = []; c = [];
    end
