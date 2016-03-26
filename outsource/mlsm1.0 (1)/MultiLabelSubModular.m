function [x e] = MultiLabelSubModular(D, W, Vi, Vm)
%
%
%
%
% Discrete optimization of the following multi-label functional
%
% x = argmin \sum_i D_i(x_i) + \sum_ij w_ij V_k (x_i, x_j)
%
% for N-dimensional x, over L discrete labels
% Provided that the energy is multilabel submodular.
%
% Usage:
%   [x e] = MultiLabelSubModular(D, G, Vi, Vm)
%
% Inputs:
%   D   - Data term of size NxL
%   W   - Pair-wise weights (w_ij) of size NxN
%   Vi  - Index k for each pair ij, selecting the pair-wise interaction V_k. 
%         Vi is of size NxN
%         note that for each non-zero entry in W there must be a
%         corresponding non-zero entry in Vi. Entries must be proper
%         indices into Vm, i.e., integer numbers in the range
%         [1..size(Vm,3)]
%   Vm  - A concatanation of matrices V_k of size LxLxK
%
% Outputs:
%   x   - optimal assignment
%   e   - energy of optimal assignment
%
% 
%-------------------------------------- 
%
% NOTE
% requires compilation of mex file
%
% >> mex -O -largeArrayDims -DNDEBUG graph.cpp maxflow.cpp...
%        MultiLabelSubModular_mex.cpp -output MultiLabelSubModular_mex
%
%--------------------------------------
%
% Copyright (c) Bagon Shai
% Department of Computer Science and Applied Mathmatics
% Wiezmann Institute of Science
% http://www.wisdom.weizmann.ac.il/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
%
%
% If used in an academic research, the follwoing citation must be included
% in any resulting publication:
%
%   [1] D. Schlesinger and B. Flach, 
%       "Transforming an arbitrary MinSum problem into a binary one", 
%       Technical report TUD-FI06-01, Dresden University of Technology, April 2006.
%       http://www1.inf.tu-dresden.de/~ds24/publications/tr_kto2.pdf
%
%   [2] Yuri Boykov and Vladimir Kolmogorov,
%       "An Experimental Comparison of Min-Cut/Max-Flow Algorithms for 
%       Energy Minimization in Computer Vision",
%       PAMI, September 2004. 
% 
%   [3] Shai Bagon 
%       "Matlab Implementation of Schlezinger and Flach Submodular Optimization",
%       June 2012.
%
%
%
% 
%


% check Monge
assert( IsMonge(Vm), 'MultiLabelSubModular:submodularityV',...
    'Matrices Vm are not submodular');


% make sure W is non negative
assert( all( nonzeros(W) > 0 ), 'MultiLabelSubModular:submodularityW',...
    'weights w_ij must be non-negative');





% remove diagonal of W
[wi wj wij] = find(W);
sel = wi < wj;
if ~any(sel)
    sel = wi > wj;
end
[vi vj vij] = find(Vi);
assert( isequal(vi, wi) && isequal(wj, vj), 'MultiLabelSubModular:Vi', ...
    'Index matrix Vi must have non-zeros pattern matching W');

assert( all(vij == round(vij)), 'MultiLabelSubModular:Vi',...
    'Vi must have integer index entries');

assert( all( vij>= 1 ) && all( vij <= size(Vm,3) ),...
    'MultiLabelSubModular:Vi',...
    'Vi entries must be between 1 and %d', size(Vm,3));

W = sparse(wi(sel), wj(sel), wij(sel) + 1i*vij(sel), size(W,1), size(W,2));



% run the optimization
x = MultiLabelSubModular_mex(D', W, Vm);

if nargout > 1 % compute energy as well
    N = size(D,1);
    
    e(3) = Vm( sub2ind( size(Vm), x(wi), x(wj), vij') ) * wij; % pair-wise term
    e(2) = sum( D( sub2ind( size(D), 1:N, x) ) ); % data term (unary)
    e(1) = sum(e(2:3));
end


%-------------------------------------------------------------------------%
function tf = IsMonge(M)
%
% Checks if matrix M is a Monge matrix.
%
% The following must hold for a Monge matrix (with finite entries):
%   M_ik + M_jl <= M_il + M_jk \forall 1 <= i <= j <= m, 1 <= k <= l <= n
%
% M may be 3D array, in which case each 2D "slice" is checked for Monge
% property
%

tf = true;

for si=1:size(M,3)
    [m n] = size(M(:,:,si));
    for ii=1:(m-1)
        for kk=1:(n-1)
            tf =  ( M(ii,kk) + M(ii+1,kk+1) <= M(ii, kk+1) + M(ii+1, kk) );
            if ~tf, return; end
        end
    end
end
