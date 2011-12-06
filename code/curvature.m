function K=curvature(P0,P1,P2,P3)
% Returns the curvature of the Bezier curve given by control points
% [P0,P1,P2,P3].

K = 0;
% delta
d = 0.01;

for i=0:(1/d)-1
    result = (curv(i*d,P0,P1,P2,P3)*curve_length(i*d, (i+1)*d,P0,P1,P2,P3));
    K = K + result;
end

return;

function k2=curv(t,P0,P1,P2,P3)
% Returns k^2

% Bezier Matrix
BM = [-1 3 -3 1; 3 -6 3 0; -3 3 0 0 ; 1 0 0 0 ]; 
r = BM*[P0;P1;P2;P3];

% x,y first derivatives; xx,yy second derivatives
x = 3*(t^2)*r(1,1) + 2*t*r(2,1) + r(3,1);
xx = 6*t*r(1,1) + 2*r(2,1);
y = 3*(t^2)*r(1,2) + 2*t*r(2,2) + r(3,2);
yy = 6*t*r(1,2) + 2*r(2,2);


if (x == 0 & y == 0)
    k2 = 0;
else
    k2 = (abs(x*yy - xx*y)/(abs(x^2 + y^2)^(3/2)))^2;
end

return;