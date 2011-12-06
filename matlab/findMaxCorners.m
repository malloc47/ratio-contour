function corners=findMaxCorners(strength, r, c, N)

list = [];
corners = [];

for i=1:size(r,1)
    list(i,:) = [r(i), c(i), strength(r(i),c(i))];
end

if (size(list) > 0)
    [Y indx] = sort(list(:,3), 1, 'descend');
else
    indx = [];
end

N = min(N, size(indx,1));

for k=1:N
    corners(k,:) = list(indx(k),:);
end

% K = list(indx(N),3);
% 
% for i=1:size(strength,1)
%     for j=1:size(strength,2)
%         if (strength(i,j) < K)
%             cimX(i,j) = 0;
%         else
%             cimX(i,j) = strength(i,j);
%         end
%     end
% end

return;
