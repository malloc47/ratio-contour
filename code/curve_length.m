function L=curve_length(i,j,P0,P1,P2,P3);
% Returns the length in interval i,j of the Bezier curve determined by the 4 control points.
% Input: 2 values i,j and 4 points (x,y).

L = quad(@integrand,i,j,[],[],P0,P1,P2,P3);


function f = integrand(t, P0, P1, P2, P3);
% Integrand for the calculation of length.

% Bezier Matrix
BM = [-1 3 -3 1; 3 -6 3 0; -3 3 0 0 ; 1 0 0 0 ]; 
r = BM*[P0;P1;P2;P3];

x = 3*(t.^2)*r(1,1) + 2*t*r(2,1) + r(3,1);
y = 3*(t.^2)*r(1,2) + 2*t*r(2,2) + r(3,2);

f = sqrt(x.^2 + y.^2);
