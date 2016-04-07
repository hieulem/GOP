addpath('/Users/hieule/Project/GOP/outsource/gco-v3.0/matlab');
fr = 1;


dia = 1- diag(ones(1,splist(fr)));
dia2 = 1- diag(ones(1,splist(fr+1)));


UI = pop_potentials(fr,fr+1,hist,pos,rgbhistogram);
UI = max(max(UI))- UI;
UI2 = pop_potentials(fr,fr,hist,pos,rgbhistogram);

UI2= UI2.*dia;

PI = pop_potentials(fr+1,fr+1,hist,pos,rgbhistogram);


PI = max(max(PI))- PI;
PI = PI.*dia2;

PI(PI<1e-5) = 0;

hi_pos =3;
pos_dist = pdist2(pos{fr}(:,:), pos{fr}(:,:), 'euclidean' );
pos_dist = double(exp(-pos_dist/phi_pos^2));


pos_dist = pos_dist.*dia;
% 
pos_dist(pos_dist<1e-5) = 0;

h = GCO_Create(splist(fr+1),splist(fr)); 
GCO_SetDataCost(h,UI);
GCO_SetSmoothCost(h,pos_dist);
GCO_SetNeighbors(h,PI);
GCO_Expansion(h); 
l = GCO_GetLabeling(h);
visdistance(sp(:,:,fr+1),l)
[E D S] = GCO_ComputeEnergy(h)


% 
% 
% h = GCO_Create(4,3);             % Create new object with NumSites=4, NumLabels=3
%      >> GCO_SetDataCost(h,[
%         0 9 2 0;                         % Sites 1,4 prefer  label 1
%         3 0 3 3;                         % Site  2   prefers label 2 (strongly)
%         5 9 0 5;                         % Site  3   prefers label 3
%         ]);
%      >> GCO_SetSmoothCost(h,[
%         0 1 2;      % 
%         1 0 1;      % Linear (Total Variation) pairwise cost
%         2 1 0;      %
%         ]);
%      >> GCO_SetNeighbors(h,[
%         0 1 0 0;     % Sites 1 and 2 connected with weight 1
%         0 0 1 0;     % Sites 2 and 3 connected with weight 1
%         0 0 0 2;     % Sites 3 and 4 connected with weight 2
%         0 0 0 0;
%         ]);
%      >> GCO_Expansion(h);                % Compute optimal labeling via alpha-expansion 
%      >> GCO_GetLabeling(h)
% 
% toc;

