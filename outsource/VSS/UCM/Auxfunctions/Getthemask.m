function mask=Getthemask(ucm2f,level,label)

% tic
labels2 = bwlabel(ucm2f < level);
labels = labels2(2:2:end, 2:2:end);

mask=(label==labels);
% toc
