% DESCRIPTION:
%   Code to compute globalPb and hierarchical regions, as described in:
%
%   P. Arbelaez, M. Maire, C. Fowlkes and J. Malik. 
%   From Contours to Regions: An Empirical Evaluation. CVPR 2009.
%
%   M. Maire, P. Arbelaez, C. Fowlkes and J. Malik. 
%   Using Contours to Detect and Localize Junctions in Natural Images. CVPR
%   2008.
% 
% WARNINGS:
%   This code is still under development and testing. It is being distributed on its
%   present form for educational and research purposes only. The final public
%   release will probably be different. 
%
%   If you use any portion of this code, please acknowledge our work by
%   citing the two papers above.
%
%   Please report any bugs or improvements to the address below.
%
%   latest version : April 1st 2009
%
%   Pablo Arbelaez.
%   <arbelaez@eecs.berkeley.edu>

%% DIRECTIONS: 
%  unzip and update the absolute path in the file lib/spectralPb.m
% 

%%
% addpath('lib')

range=1; %1:120
for i=range
%%
    imgFileBig=['/home/fabio/Data/Toyota/seq3/seq3-',num2str(i-1,'%03d'),'.png'];
    imgFile=['/home/fabio/Data/Toyota/result_seq3/srseq3-',num2str(i-1,'%03d'),'.png'];
    img=imread(imgFileBig);
    img=imresize(img,0.5);
    imwrite(img,imgFile);
    clear img;
    
    outFile=['/home/fabio/Data/Toyota/result_seq3/srseq3-',num2str(i-1,'%03d'),'_gPb.mat'];
    ucmf=['/home/fabio/Data/Toyota/result_seq3/srseq3-',num2str(i-1,'%03d'),'_ucm.bmp'];
    ucm2f=['/home/fabio/Data/Toyota/result_seq3/srseq3-',num2str(i-1,'%03d'),'_ucm2.bmp'];

    %% compute globalPb
%     clearvars -except imgFile outFile ucmf ucm2f i;
%     % clear all;
%     close all; clc;

    % imgFile = 'data/101087.jpg';
    % outFile = 'data/101087_gPb.mat';
    rsz = 1.0;

    [gPb_orient, gPb_thin, textons] =globalPb(imgFile, outFile, rsz);
    clear gPb_thin;
    clear textons;

    %% compute Hierarchical Regions
%     clearvars -except imgFile outFile ucmf ucm2f i;
%     % clear all;
%     close all; clc;

%     load(outFile,'gPb_orient');
    % load data/101087_gPb.mat gPb_orient

    % for boundaries
    ucm = contours2ucm(gPb_orient, 'imageSize');
    imwrite(ucm,ucmf);

    % for regions
    ucm2 = contours2ucm(gPb_orient, 'doubleSize');
    imwrite(ucm2,ucm2f);

%     %% usage example
% %     clearvars -except imgFile outFile ucmf ucm2f i;
% %     % clear all;
% %     close all; clc;
% 
%     %read double sized ucm
%     ucm2 = imread(ucm2f);
% 
%     % convert ucm to the size of the original image
%     ucm = ucm2(3:2:end, 3:2:end);
% 
%     % get the boundaries of segmentation at scale k in range [1 255]
%     k = 100;
%     bdry = (ucm >= k);
% 
%     % get the partition at scale k without boundaries:
%     labels2 = bwlabel(ucm2 <= k);
%     labels = labels2(2:2:end, 2:2:end);
% 
%     figure(1);imshow(imgFile);
%     figure(2);imshow(ucm);
%     figure(3);imshow(bdry);
%     figure(4);imshow(labels,[]);colormap(jet);

    %%
    clear gPb_orient;
    clear ucm;
    clear ucm2;
    
    fprintf('\nDone image %s\n\n',imgFileBig);
end



