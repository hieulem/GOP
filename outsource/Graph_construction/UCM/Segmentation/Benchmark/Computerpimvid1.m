function output=Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,minimumimagenumber,curvecolor,plotsuperpose,considervideos,bmetrics,justavideo,outputdir)
%Computerpimvid(filenames,99,'tttttSegm',true,0,true,'r')
% Fabio Galasso
% February 2014

if (~exist('justavideo','var'))
    justavideo=[];
end
if (~exist('outputdir','var'))
    outputdir=[]; %The default directory in additionalmasname is defined in the function Benchmarkcreateoutimvid
end
if ( (~exist('curvecolor','var')) || (isempty(curvecolor)) )
    curvecolor='r'; %rp curves color
end
if ( (~exist('plotsuperpose','var')) || (isempty(plotsuperpose)) )
    plotsuperpose=false; %superpose rp curves
end
if ( (~exist('minimumimagenumber','var')) || (isempty(minimumimagenumber)) )
    minimumimagenumber=0; %number of images to wait for starting computation (0 means no wait)
end
if ( (~exist('requestdelconf','var')) || (isempty(requestdelconf)) )
    requestdelconf=true;
end
if ( (~exist('nthresh','var')) || (isempty(nthresh)) )
    nthresh=5;
end
if ( (~exist('considervideos','var')) || (isempty(considervideos)) )
    considervideos=true;
end
if ( (~exist('bmetrics','var')) || (isempty(bmetrics)) )
    bmetrics={'bdry','regpr','lengthsncl'}; %'bdry','3dbdry','regpr','sc','pri','vi',,
end
if ( (~exist('additionalmasname','var')) || (isempty(additionalmasname)) )
    additionalmasname='tttttSegm';
end
if ( (~exist('filenames','var')) || (isempty(filenames)) )
    filenames.benchmark=[pwd,filesep];
end
if (~isstruct(filenames))
    tmp=filenames; clear filenames; filenames.benchmark=tmp; clear tmp;
end

%Assign input directory names and check existance of folders
onlyassignnames=true;
[sbenchmarkdir,imgDir,gtDir,inDir,isvalid] = Benchmarkcreatedirsimvid(filenames, additionalmasname, onlyassignnames); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end



%Check existance of output directory and request confirmation of deletion
onlyassignnames=true;
[sbenchmarkdir,outDir,isvalid] = Benchmarkcreateoutimvid(filenames, additionalmasname, onlyassignnames, outputdir); %#ok<ASGLU>
if ( isvalid )
    if (requestdelconf) %Setting requestdelconf to true deletes without requesting confirmation
        theanswer = input('Remove previous output? [ 1 , 0 (default) ] ');
    else
        theanswer=1;
    end
    if ( (~isempty(theanswer)) && (theanswer==1) )
        Removetheoutputimvid(filenames,additionalmasname,outputdir);
        isvalid=false;
    end
end
if (~isvalid)
    [sbenchmarkdir,outDir,isvalid] = Benchmarkcreateoutimvid(filenames, additionalmasname, [], outputdir); %#ok<ASGLU>
end



%Wait minimumimagenumber for processing
iids=Listacrossfolders(imgDir,'jpg',Inf); % iids = dir(fullfile(imgDir,'*.jpg'));
if (minimumimagenumber>0)
    while(numel(iids)<minimumimagenumber)
        pause(10);
        iids=Listacrossfolders(imgDir,'jpg',Inf); % iids = dir(fullfile(imgDir,'*.jpg'));
    end
    fprintf('All images are in the directory\n');
end
fprintf('%d images are in the folder (and first-level subfolders)\n',numel(iids));



tic;
if (isvalid)
    Benchmarksegmeval(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos,justavideo);
end
toc;



tic
if (isvalid)
    Benchmarkevalstats(imgDir, gtDir, inDir, outDir, nthresh, [], [], bmetrics, considervideos, justavideo);
end
toc



output=Plotsegmeval(outDir,plotsuperpose,curvecolor);

%     rmdir(sbenchmarkdir,'s')
%     rmdir(outDir,'s')




function test_on_cases() %#ok<DEFNU>

imgDir='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/TMP/New/renamed/Test/General_test_fullres/'
imgDir='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/TMP/New/renamed/Test/General_test_fullres/Images/'
imgDir='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdscfsegimagemahis/Images/'

additionalmasname='Bvdssegmfothergt'; Computerpimvid(filenamesfs,nthresh,additionalmasname,requestdelconf,0,'k',false,[],'all',[],'Nonthickoutput'); %b*
additionalmasname='Bvdssegmfotherdob'; outob=Computerpimvid(filenamesfs,nthresh,additionalmasname,requestdelconf,0,'r',true,[],'all',[],'Nonthickoutput'); %b*Half the resolution
additionalmasname='Bvdssegmfotherdob'; outob=Computerpimvid(filenamesfs,nthresh,additionalmasname,requestdelconf,0,'g',true,[],'all'); %b*Half the resolution

localbenchdir='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/TMP/New/renamed/Benchmark/';
additionalmasname='Algorithm_ochsbrox_thick'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'b',true,[],'all',[],''); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_thinned'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'y',true,[],'all',[],'TMPnew'); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_thinned'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'c',true,[],'all',[],''); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_expanded2'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'b',true,[],'all',[],''); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_expanded'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'b',true,[],'all',[],'TMPnew'); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_expanded'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'r',true,[],'all',[],'TMPoutput'); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox_expanded'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'y',true,[],'all',[],''); %b*Half the resolution
additionalmasname='Algorithm_ochsbrox'; Computerpimvid(localbenchdir,nthresh,additionalmasname,requestdelconf,0,'y',true,[],'all',[],''); %b*Half the resolution


requestdelconf=true;
nthresh=51;
additionalmasname='tttttSegm'; %#ok<NASGU>
additionalmasname='AASegmcfallpoptnrmrep'; Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,false,'m');
additionalmasname='AASegmcsvbfallpoptnrmrep'; Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,true,'g');



function Othercode(ucm2) %#ok<DEFNU>

%%% Procedure to label the video with the ground truth according to the ucm2 superpixels

%Prepare parameters
noFrames=numel(cim);

Level=1;
labelledvideo=Labellevelframes(ucm2,Level,noFrames,printonscreen);
Printthevideoonscreen(labelledvideo, printonscreen, 11, true);

[mapped]=Mappedfromlabels(labelledvideo,printonscreen); %,framebelong,noalllabels,maxnolabels

labelsgt=Labelsfromgt(filename_sequence_basename_frames_or_video,mapped,ucm2,...
    videocorrectionparameters,printonscreen);

labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreen);
% Printthevideoonscreen(labelledvideo, true, 6, true);



%%%Procedure to determine a new cell array gtimages
newgtimages=cell(1,numel(gtimages));
for f=1:noFrames
    newgtimages{f}=[];
end
count=0;
for f=find(nonemptygt)
    startpos=numberofpixels*count+1;
    endpos=startpos-1+numberofpixels;
    count=count+1;
    
    animage=zeros(dimi,dimj);
    animage(:)=thenewrow(startpos:endpos);
    newgtimages{f}=animage;
end
%Visualization of newgtimages
Init_figure_no(10)
for f=1:numel(newgtimages)
    agtimage=newgtimages{f};
    if (~isempty(agtimage))
        agtimage(1,1)=1;
        agtimage(1,2)=numberofcolors;
        imagesc(agtimage);
    end
    title(['frame ',num2str(f)]);
    pause(0.1);
end



%%%Procedure to get ucm2 variables from the labelledvideo
%Initialisation
gtucm2=cell(1,noFrames);
for f=1:noFrames
    gtucm2{f}=uint8(zeros(size(ucm2{1})));
end
gtucm2=Addtoucm2wmex(1:noFrames,labelledvideo,gtucm2,size(labelledvideo,1),size(labelledvideo,2),noFrames);
% for ff=1:noFrames
%     gtucm2=Addtoucm2wmex(ff,labelledvideo,gtucm2,size(labelledvideo,1),size(labelledvideo,2),1);
% end

Init_figure_no(10)
for f=1:noFrames
    imagesc(gtucm2{f})
    pause(0.1)
end

%Prepare output format
for f=1:noFrames
    %The size is reduced to the image size and the edges kept
    gtucm2{f}=gtucm2{f}(3:2:end, 3:2:end);
end

Init_figure_no(10)
for f=1:noFrames
    imagesc(gtucm2{f})
    pause(0.1)
end

