

seeds = [];
% video_name = 'bmx';
% supDIR = ['./temp/' video_name, '/'];
% load(['./CPres/',video_name, '.mat']);
% load([supDIR 'x.mat']);%load([supDIR 'y.mat']);load([supDIR 'z.mat']);
%load('y.mat');
%load('z.mat');
numx = squeeze(sum(xedges>0,1));

meanx = squeeze(sum(xedges,1))./numx;
%meanx(meanx<0.1) = 0;
minx = squeeze(max(xedges,[],1));
slicex = squeeze(xedges(1,:,:));
nsv = size(xedges,2);
meanx = sparse(meanx);
%diagmatrix = diag(ones(1,nsv));

% numy = squeeze(sum(yedges>0,1));
% numz = squeeze(sum(zedges>0,1));
% meany = squeeze(sum(yedges,1))./numy;
% meanz = squeeze(sum(zedges,1))./numz;
% 
% meanall = (squeeze(sum(xedges,1))+squeeze(sum(yedges,1))+squeeze(sum(zedges,1))) ...
%             ./ (numx+numy+numz);
% meanall(isnan(meanall)) = 0; 
% figure(1);imshow(meanall);
% meanall = sparse(double(meanall));
%meanx(isnan(meanx)) = 0;
seeds = extract_seeds(nseeds,meanx);
% tic;
% for i=1:input.numi
%     graph = squeeze(xedges(i,:,:));
%     seeds(i,:) = extract_seeds(nseeds,graph);
%   
% end
% n=1;
% toc;
mask=[];
mask = outputs{1} ==seeds(1) ;
for i=1:nseeds
    mask = mask | (outputs{1} ==seeds(i)) ;
end

mask = uint8(mask);
%figure(4);playMovie([permute(input.imgs,[1,2,4,3]) 200*permute(repmat(mask,[1,1,1,3]),[1,2,4,3])],5,-1,struct('hasChn',1));

figure(4);playMovie([permute(input.imgs,[1,2,4,3]) permute(input.imgs,[1,2,4,3]).*permute(repmat(uint8(mask),[1,1,1,3]),[1,2,4,3])],10,-4,struct('hasChn',1,'showLines',1));
outdir = ['./out/', int2str(numsp), '/',video_name];
mkdir(outdir);
cd(outdir);

a= [permute(input.imgs,[1,2,4,3]) permute(input.imgs,[1,2,4,3]).*permute(repmat(uint8(mask),[1,1,1,3]),[1,2,4,3])];
for i=1:input.numi
    imwrite(squeeze(a(:,:,:,i)),[ video_name num2str(i,'%03d') '.jpg'])
end
cd('..');cd('..');cd('..');

% mask = zeros(size(outputs{1},1),size(outputs{1},2),size(outputs{1},3));
% 
% for i=1:input.numi
%     for j=1:nseeds
%         mask(:,:,i) =  mask(:,:,i) | (outputs{1}(:,:,i) == seeds(i,j));
%     end
% end;
% figure(4);playMovie([permute(input.imgs,[1,2,4,3]) 200*permute(repmat(mask,[1,1,1,3]),[1,2,4,3])],5,-1,struct('hasChn',1));
% figure(4);playMovie([permute(input.imgs,[1,2,4,3]) permute(input.imgs,[1,2,4,3]).*permute(repmat(uint8(mask),[1,1,1,3]),[1,2,4,3])],5,-1,struct('hasChn',1,'showLines',1));
% 
% 
% 
