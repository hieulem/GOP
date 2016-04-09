function [mostats,jistats,densitystats,lengthstats]=Getquantitativemeasurementjustlabelsfast(filename_sequence_basename_frames_or_video,labelledvideo,mintracklength,...
    videocorrectionparameters,noFrames,skipfirstlabel,printonscreen,framesforevaluation,fframe)
%The function measure the maximum achievable precision and recall, global
%and averaged over objects
%The estimation does not include the background by default

%framesforevaluation=[]; _defined according to the first frame
% framesforevaluation=framestoconsider;


%Prepare the input
if ( (~exist('noFrames','var')) || (isempty(noFrames)) )
    noFrames=size(labelledvideo,3);
end
if ( (~exist('mintracklength','var')) || (isempty(mintracklength)) )
    mintracklength=5;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('framesforevaluation','var')) || (isempty(framesforevaluation)) )
    framesforevaluation=1:noFrames;
end
if (numel(framesforevaluation)==1) %This means that at least two frames must be requested if fframe is not empty
    if ( (exist('fframe','var')) && (~isempty(fframe)) )
        framesforevaluation=fframe:fframe+framesforevaluation-1;
    end
end
if (any(framesforevaluation>noFrames))
    framesforevaluation=framesforevaluation(framesforevaluation<=noFrames);
end
if ( (~exist('skipfirstlabel','var')) || (isempty(skipfirstlabel)) )
    skipfirstlabel=false; %by default background is not included in calculations
end



ntoreadmgt=1; %1, 2, .. Inf number of gts to read - this metric only consider single gt annotations
maxgtframes=max(framesforevaluation); %Limit max frame for gt (impose same test set)
[labelledgtvideo,nonemptygt]=Getmultgtlabvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,ntoreadmgt,maxgtframes,printonscreen); %,numberofobjects,numbernonempty
%labelledgtvideo{ which gt annotation , which frame } = dimIi x dimIj double (the labels, 0 others, -1 neglect)
if (isempty(labelledgtvideo))
%     error('Could not read gt images\n');
    fprintf('GT Images missing, required mc stats not computed\n');
    mostats=[];jistats=[];densitystats=[];lengthstats=[];
    return;
end
for mid=1:size(labelledgtvideo,1)
    Printthevideoonscreen(labelledgtvideo(mid,:), printonscreen, 10, false, true,[],[]);
end



[mostats,jistats,densitystats,lengthstats]=Getallprecisionrecallcountsfast(labelledvideo,labelledgtvideo,skipfirstlabel,mintracklength,framesforevaluation);
%precisionperobject(i)=allprecisepixels(i)/allrecalledpixels(i);
%recallperobject(i)=allprecisepixels(i)/totalobjectpixels(i);
%precision and recall: global values, ratio of sum of all pixels
%averageprecision and averagerecall: averages of per object precision and recall
%allprecisepixels,allrecalledpixels,totalobjectpixels: for each object,
%correctly classified pixels, number pixels per test label, number pixels per ground truth label
%density is the number of video pixels assigned to a valid label on the total number of pixels

    

