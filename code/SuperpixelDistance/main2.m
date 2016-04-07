%function main()

addpath(genpath('C:\Users\vunguyen\Documents\SBU\ActionProposal\yu_iccv2015\pgp_code'));
addpath(genpath('C:\Users\vunguyen\Documents\SBU\ActionProposal\SketchTokens-master'));

% Run Chenping'code to get the superpixel map
option.spType = 'ers';
option.numSP = 400; 
option.sampleRate = 0.5;
option.subVolume = 4; 
option.useMotion = 0;
option.fitMethod = 2; 
option.toShow = 0; 
option.inputDIR = 'C:\Users\vunguyen\Documents\SBU\ActionProposal\yu_iccv2015\pgp_code/bmx/frames/'; 
option.motionMat = 'C:\Users\vunguyen\Documents\SBU\ActionProposal\yu_iccv2015\pgp_code/bmx/bmx.mat'; 
option.outputDIR = 'C:\Users\vunguyen\Documents\SBU\ActionProposal\yu_iccv2015\pgp_code/output/'; 

% outputs = pgpMain2(option);
vidseg = outputs{1};
nFrame = size(vidseg, 3);
height = size(vidseg, 1);
width = size(vidseg, 2);

% Run Sketch to get the edge map

load('C:\Users\vunguyen\Documents\SBU\ActionProposal\SketchTokens-master\models/forest/modelSmall.mat');

dirName = option.inputDIR;
files = dir( fullfile(dirName,'*.png') );
files = {files.name}';
for iFrame = 1:1
    seg = vidseg(:,:,iFrame);
    filepath = fullfile(dirName,files{iFrame});
    im = imread(filepath);
    im = imresize(im, [height, width]);
    st = stDetect( im, model );
    E = stToEdges( st, 1 );
%     figure;
%     imagesc(E);
    
    tic;
    aff = spAffinities(seg, E);
    toc;
    a = 3;
end

%end





