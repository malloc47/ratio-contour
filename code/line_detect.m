function lines=line_detect(bw);

goal = 40;
n = 10;

list = edgelink(bw, n);
lines = lineseg(list, 1);

% while ((size(lines,1) > goal) && (n < 100))
%     n = n + 1;
%     display(int2str(n));
%     list = edgelink(bw, n);
%     lines = lineseg(list, 1);
% end

return;