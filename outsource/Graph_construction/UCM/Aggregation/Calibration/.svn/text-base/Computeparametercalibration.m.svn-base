function Computeparametercalibration(filenames,paramcalibname,requestdelconf)
% paramcalibname=options.calibrateparametersname

if ( (~exist('requestdelconf','var')) || (isempty(requestdelconf)) )
    requestdelconf=true;
end
if ( (~exist('paramcalibname','var')) || (isempty(paramcalibname)) )
    paramcalibname='Paramcstltifefff';
end



%Assign input directory names and check existance of folders
onlyassignnames=true;
[thebenchmarkdir,theDir,isvalid] = Benchmarkcreateparametercalibrationdirs(filenames, paramcalibname, onlyassignnames);
if (~isvalid)
    fprintf('Some Directories are not existing\n');
    return;
end



%Check existance of output directory and request confirmation of deletion
onlyassignnames=true;
[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname, onlyassignnames);
if (isvalid)
    if (requestdelconf)
        theanswer = input('Remove previous output? [ 1 (default) , 0 ] ');
    else
        theanswer=1;
    end
    if ( (isempty(theanswer)) || (theanswer~=0) )
        Removecalibrationparametertheoutput(filenames,paramcalibname);
        isvalid=false;
    end
end
if (~isvalid)
    [thebenchmarkdir,outDir] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname);
end



tic;
Parametercalibrationbench(theDir, outDir); %, justavideo
toc;

Plotparametercalibration(outDir);



%     rmdir(thebenchmarkdir,'s')
%     rmdir(outDir,'s')






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
