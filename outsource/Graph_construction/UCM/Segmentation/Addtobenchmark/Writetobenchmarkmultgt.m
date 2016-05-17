function Writetobenchmarkmultgt(allgroundtruth, cim, ucm2, nonemptygt, filenames, imgDir, gtDir, inDir, allthesegmentations)
%The function saves the images, cum2 and gt files for further evaluation
%The input is either ucm2 or allthesegmentations (default, if non-empty).
%ucm2 is for image segmentation, allthesegmentations is for video segmentation

if ( (~exist('allthesegmentations','var')) || (isempty(allthesegmentations)) )
    allthesegmentations=[];
end

noFrames=numel(allgroundtruth);

%Write images, ground truth and ucm2 to appropriate directories
for f=1:noFrames
    if (~any(nonemptygt(:,f))) %(isempty(labelledgtvideo{mid,f}))
        continue;
    end
    
    %The input image in jpg
    imwrite(cim{f},[imgDir,filenames.casedirname,num2str(f),'.jpg'],'jpg');
    
    %The ground truth in mat as cells of structs with Boundaries and Segmentation
    groundTruth=allgroundtruth{f}; %allgroundtruth has nonemptycounting
    save([gtDir,filenames.casedirname,num2str(f),'.mat'],'groundTruth');
    
    
    if (~isempty(allthesegmentations))
        Savesegs([inDir,filenames.casedirname,num2str(f),'.mat'],allthesegmentations,f);
    else
        %The ucm2 variables, double the size of the images
        Saveucm2([inDir,filenames.casedirname,num2str(f),'.mat'],double(ucm2{f})/255);
    end
end


