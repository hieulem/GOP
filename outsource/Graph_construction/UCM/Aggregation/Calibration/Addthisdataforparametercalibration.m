function Addthisdataforparametercalibration(sxa,sya,sva,thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration) %#ok<INUSL>
%sxa=[sxo;syo];sya=[syo;sxo];sva=[svo;svo];

if ( (~exist('printonscreenincalibration','var')) || (isempty(printonscreenincalibration)) )
    printonscreenincalibration=false;
end

if ( (isfield(theoptiondata,'paramcalibname')) && (~isempty(theoptiondata.paramcalibname)) )
    paramcalibname=theoptiondata.paramcalibname;
else
    paramcalibname='Paramcstltifefff'; fprintf('Addthisdataforparametercalibration: using standard additional name %s for parameter calibration, please confirm\n',paramcalibname); pause;
end



[thebenchmarkdir,theDir] = Benchmarkcreateparametercalibrationdirs(filenames, paramcalibname); %,isvalid
% rmdir(theDir,'s')
% rmdir(thebenchmarkdir,'s')


[posbin,negbin]=Groundtruthbinningaffinityvalues(sxa,sya,sva,theoptiondata.labelsgt,thiscase,printonscreenincalibration);
%posbin and negbing are row vectors



%Write output to files posbin
thefilename=sprintf('%s_%s_posneg.txt',filenames.casedirname,thiscase);
fname = fullfile(theDir,thefilename);
fid = fopen(fname,'w');
if fid==-1,
    error('Could not open file %s for writing.',fname);
end
fprintf(fid,'%10g %10g\n', [posbin;negbin]);
fclose(fid);

%Write raw output
labelsgt=theoptiondata.labelsgt; %#ok<NASGU>
thefilename=sprintf('%s_%s_raw.mat',filenames.casedirname,thiscase);
fname = fullfile(theDir,thefilename);
save(fname,'sxa','sya','sva','labelsgt','noallsuperpixels','-v7.3');










function Othercode(ucm2) %#ok<DEFNU>

%%% Procedure to label the video with the ground truth according to the ucm2 superpixels

%Prepare parameters
noFrames=numel(cim);

Level=1;
labelledvideo=Labellevelframes(ucm2,Level,noFrames,printonscreenincalibration);
Printthevideoonscreen(labelledvideo, printonscreenincalibration, 11, true);

[mapped]=Mappedfromlabels(labelledvideo,printonscreenincalibration); %,framebelong,noalllabels,maxnolabels

labelsgt=Labelsfromgt(filename_sequence_basename_frames_or_video,mapped,ucm2,...
    videocorrectionparameters,printonscreenincalibration);

labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreenincalibration);
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
