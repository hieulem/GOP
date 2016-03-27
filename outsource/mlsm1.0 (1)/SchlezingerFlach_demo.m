function SchlezingerFlach_demo
%
% demo usage of multilabel submodular optimization
%

fprintf(1, 'Running synthetic example.\n');

% demo using synthetic energy on a grid
sz = [10 15]; % grid size
N = prod(sz); % num of variables
L = 7;        % num of labels

% grid
lin = reshape(1:N, sz);
vec = @(x) x(:);

ii = vertcat( vec(lin(:,1:end-1)),...
    vec(lin(1:end-1,:)) );

jj = vertcat( vec(lin(:,2:end)),...
    vec(lin(2:end,:)) );

E = numel(ii); % number of edges

Vm(:,:,1) = abs( bsxfun(@minus, 1:L, (1:L)') ); % L1 term
Vm(:,:,2) = Vm(:,:,1).^2; % L2 term

% random data cost
D = 20*rand(N, L); 

W = sparse(ii, jj, .1 + .9*rand(E,1), N, N);
Vi = sparse(ii, jj, randi(2, E, 1), N, N); % choose randomly between L1 and L2


% run the optimization
[x e] = MultiLabelSubModular(D, W, Vi, Vm);

figure;
imagesc( reshape(x, sz) );axis image;colorbar
title(sprintf('optimal labeling energy = %.1f', e(1)));


%------------------------------------------------------------------------%
% Run Tsukuba example with L1 norm (not truncated as in middlebury
% benchmark)

fprintf(1, '\n\nRunning tsukuba stereo example.\n');
fprintf(1, 'This example requires large RAM and may fail if not enough memory exists\n');

load('./middlebury_mrf_tsu.mat','Dc', 'W', 'sz');

nl = size(Dc,2);

% the pair-wise cost of tsukuba is originally truncated L1 with weight
% w_ij depending on contrast. Since truncated L1 is not submodular, we work
% here with regular L1
Vm = 15*abs( bsxfun(@minus, 1:nl, (1:nl)') );
Vi = spfun(@(x) 1, W);

[x e] = MultiLabelSubModular(Dc, W, Vi, Vm);

figure;
imagesc( reshape(x,sz) ); axis image; colormap gray; colorbar
title( sprintf('optimal labeling energy = %d', e(1) ) );

fprintf(1, 'Done.\n\n');

