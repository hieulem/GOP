%The following inserts Auxbenchmark into the path
path(path,'Auxbenchmark');



%The command Computerpimvid computes the Precision-Recall curves

benchmarkpath = '../Results/'; %The directory where all results directory are contained
benchmarkdir= 'Bvdssegmfotherhgbsmallnew'; %One the computed results
requestdelconf=true; %boolean which allows overwriting without prompting a message. By default the user is input for deletion of previous calculations
nthresh=51; %Number of hierarchical levels to include when benchmarking image segmentation
superposegraph=false; %When false a new graph is initialized, otherwise the new curves are added to the graph
testtemporalconsistency=true; %this option is set to false for testing image segmentation algorithms

output=Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',superposegraph,testtemporalconsistency);
%The otuput contains the PR values in corresponding fields



%The following prints out the PR curves for the computed VS algorithms
%Video algorithms
benchmarkdir='Bvdssegmfallpoptnrm'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'b',false);
benchmarkdir='Bvdssegmfotherswanew'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'c',true); %Half resolution fix in reading
benchmarkdir='Bvdssegmfotherhgbsmallnew'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'g',true); %Half resolution fix in reading
benchmarkdir='Bvdssegmfotherdob'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'r',true); %Half the resolution
benchmarkdir='Bvdssegmfotherspbnzhalf'; spbnzout=Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'y',true);
benchmarkdir='Bvdssegmfotherspbhalf'; spbout=Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'y',true);
%Image algorithms
benchmarkdir='Bvdscfsegimagemahis'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'k',true,false); %not video
benchmarkdir='Bvdscfsegimagehis'; Computerpimvid(benchmarkpath,nthresh,benchmarkdir,requestdelconf,0,'m',true,false); %not video



%The video and image segmentations are acessible from the files allsegs<sequence>.mat
%The allsegmentations variable is a cell array.
%This segmentations are saved conveniently using Uint of the size specified by the max label, where the max possible value (255 in the case of uint8)
%is reserved for specifying that a pixel is not to be considered.
%0 is also reserved to the 'other' label, considered in the evaluation
%The back conversion is performed with the function Doublebackconv.

%Example on the airplance sequence, extracting the 3rd segmentation in the hierarchy
load ../Results/Bvdssegmfotherhgbsmallnew/Ucm2/allsegsairplane.mat
asegmentation = Doublebackconv(allthesegmentations{3});



videocase={'Bvdssegmfallpoptnrm','Bvdssegmfotherswanew','Bvdssegmfotherhgbsmallnew','Bvdssegmfotherdob','Bvdssegmfotherspbnzhalf','Bvdssegmfotherspbhalf','Bvdscfsegimagemahis','Bvdscfsegimagehis','Bvdssegmfotherhgbs','Bvdssegmfotherolv','Bvdssegmfotherolvhalf','Bvdssegmfotherbln20lev0st0d0thr','Bvdssegmfotherbln20lev1st1raf0d0thr','Bvdssegmfotherbln20lev1st0d3thr','Bvdssegmfothergttestctr'};
for i=1:numel(videocase)
    aseqname=videocase{i};
    fprintf('mkdir %s\n',aseqname);
    fprintf('cd %s\n',aseqname);
    fprintf('mkdir Groundtruth\n');
    fprintf('mkdir Images\n');
    fprintf('mkdir Ucm2\n');
    fprintf('mkdir Output\n');
    fprintf('cd ..\n');
end
for i=1:numel(videocase)
    aseqname=videocase{i};
    fprintf('scp -r %s/Groundtruth/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/%s\n',aseqname,aseqname);
    fprintf('scp -r %s/Images/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/%s\n',aseqname,aseqname);
    fprintf('scp -r %s/Ucm2/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/%s\n',aseqname,aseqname);
    fprintf('scp -r %s/Output/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/%s\n',aseqname,aseqname);
end

scp -r /BS/home-4/galasso/Desktop/Code/TCHS/UCM/Segmentation/Benchmark/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso


f=frame;
dimi=size(labelledvideo(:,:,f),1);
dimj=size(labelledvideo(:,:,f),2);
ucm2size=[dimi*2+1,dimj*2+1];
gtucm2(:,:,f)=Getsimpleucmfromlabelledvideo(labelledvideo(:,:,f),ucm2size);
dum = gtucm2(:,:,f);
allgroundtruth{mid}.Boundaries=logical(dum(3:2:end, 3:2:end));


mkdir Halfres
cd Halfres
mkdir Groundtruth
mkdir Images
cd ..
scp -r Bvdssegmfotherolvhalf/Groundtruth/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/GT/Halfres
scp -r Bvdssegmfotherolvhalf/Images/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/GT/Halfres

mkdir Fullres
cd Fullres
mkdir Groundtruth
mkdir Images
cd ..
scp -r Bvdssegmfotherolv/Groundtruth/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/GT/Fullres
scp -r Bvdssegmfotherolv/Images/ bikini:/local/www-public/transfer.d2.mpi-inf.mpg.de/galasso/GT/Fullres

zip -r GT.zip GT/




