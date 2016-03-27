addpath('/Users/hieule/Project/GOP/outsource/mlsm1.0 (1)');
addpath('/Users/hieule/Project/GOP/outsource/gco-v3.0/matlab');

frame =2;

InframeConnection = pop_neighbor_matrix(frame,frame,pos,20);
OutframeConnection = pop_neighbor_matrix(frame,frame-1,pos,20);
Unary = pop_unary_potentials(frame,geo_hist,pos,L_hist,A_hist,B_hist);
Unary = Unary-min(min(Unary));

%LConnection = pop_neighbor_matrix(frame-1,frame-1,pos,10);
%LPairwise = sparse(pop_pair_wise_potentials(frame-1,frame-1,geo_hist,pos,L_hist,A_hist,B_hist).*LConnection);


PConnection = pop_neighbor_matrix(frame,frame,pos,10);
Pairwise = sparse(pop_pair_wise_potentials(frame,frame,geo_hist,pos,L_hist,A_hist,B_hist).*PConnection)*0.1;
%Pairwise(logical(eye(size(Pairwise)))) = 10;
num_label = splist(frame-1);
E= inf;



%Init_w = bipartite_matching(Unary.*UConnection);


% h = GCO_Create(splist(frame),splist(frame-1)); 
% GCO_SetDataCost(h,Unary');
% GCO_SetSmoothCost(h,LPairwise);
% GCO_SetNeighbors(h,Pairwise);
% GCO_Expansion(h);

% 
% % the pair-wise cost of tsukuba is originally truncated L1 with weight
% % w_ij depending on contrast. Since truncated L1 is not submodular, we work
% % here with regular L1
% Vm = double(abs( bsxfun(@plus, 1:num_label, (1:num_label)') ));
% Vi = double(spfun(@(x) 1, Pairwise));

%Vi = ones(633,633);

%Vm (find(Vm)) =1;
%Vm = double(spfun(@(x) 1, Vm));

% 
% [x e] = MultiLabelSubModular(Unary , Pairwise, Vi, Vm');
% e
% numel(find(x==1))
% nlb = sp(:,:,2);
% nlb = convertspmap(nlb,1:splist(2),x);


%figure(3);imagesc(nlb)

