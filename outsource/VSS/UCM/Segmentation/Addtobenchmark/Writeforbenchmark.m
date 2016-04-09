function Writeforbenchmark(allgroundtruth, cim, ucm2, nonemptyindex, filenames, imgDir, gtDir, inDir, allthesegmentations)
%The function saves the images, cum2 and gt files for further evaluation
%The input is either ucm2 or allthesegmentations (default, if non-empty).
%ucm2 is for image segmentation, allthesegmentations is for video segmentation

if ( (~exist('allthesegmentations','var')) || (isempty(allthesegmentations)) )
    allthesegmentations=[];
end

numbernonempty=numel(allgroundtruth);

%Write images, ground truth and ucm2 to appropriate directories
for f=1:numbernonempty
    %The input image in jpg
    imwrite(cim{nonemptyindex(f)},[imgDir,filenames.casedirname,num2str(f),'.jpg'],'jpg'); %allgroundtruth does not have nonemptycounting
    
    %The ground truth in mat as cells of structs with Boundaries and Segmentation
    groundTruth=allgroundtruth{f}; %allgroundtruth has nonemptycounting
    save([gtDir,filenames.casedirname,num2str(f),'.mat'],'groundTruth');
    
    
    if (~isempty(allthesegmentations))
        Savesegs([inDir,filenames.casedirname,num2str(f),'.mat'],allthesegmentations,nonemptyindex(f)); %allthesegmentations does not have nonemptycounting
    else
        %The ucm2 variables, double the size of the images
        Saveucm2([inDir,filenames.casedirname,num2str(f),'.mat'],double(ucm2{nonemptyindex(f)})/255); %ucm2 does not have nonemptycounting
    end
end


