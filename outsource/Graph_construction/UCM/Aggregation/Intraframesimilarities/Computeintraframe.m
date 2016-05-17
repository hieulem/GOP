function [ABA,boundarylengths]=Computeintraframe(ucm2,mapped,noallsuperpixels,labelledlevelvideo, options, theoptiondata, filenames)

%paper options:
% options.abathmax=false;
% options.abauexp=false; options.abalambd=13; options.abasqv=false;

%optimized options (default):
% options.abathmax=true;
% options.abauexp=false; options.abalambd=13; options.abasqv=false;



zerosparsevalue=0.0000001;



noFrames=numel(ucm2);



if ( (isfield(options,'abathmax')) && (~isempty(options.abathmax)) )
    usetheoreticalmax=options.abathmax;
else
    usetheoreticalmax=true; %false correspond to the maximum ucm2 value in the video sequence
end
if (usetheoreticalmax)
    maxucm2=255;
else
    maxucm2=-1;
    for f=1:noFrames
        maxucm2=max(maxucm2,max(ucm2{f}(:)));
    end
    maxucm2=double(maxucm2);
end



% ABA=zeros(noallsuperpixels);
% boundarylengths=zeros(noallsuperpixels);
% Level=1;
sx=[];
sy=[];
sv=[];
lv=[];

for f=1:noFrames
    labels = labelledlevelvideo(:,:,f);
%     labels2 = bwlabel(ucm2{f} < Level);
%     labels = labels2(2:2:end, 2:2:end);
%     Init_figure_no(6), imagesc(labels)

    numberoflabels=max(labels(:));
    ifsimilaritiesatframe=zeros(numberoflabels);
    lengthsatframe=zeros(numberoflabels);

    ucm3f=double(ucm2{f});
%     Init_figure_no(3), imshow(ucm3f)
    ucm3f(2:2:end, 2:2:end)=labels;
%     Init_figure_no(5), imagesc(ucm3f)
%     size(labels2)

    %Scan of horizontal edges
    for i=3:2:(size(ucm3f,1)-1) %i scans for edges
        for j=2:2:size(ucm3f,2)
            if ( (ucm3f(i,j)>0) && (ucm3f(i-1,j)~=ucm3f(i+1,j)) ) %The second test should always be true
                label1=ucm3f(i-1,j);
                label2=ucm3f(i+1,j);
                ifsimilaritiesatframe(label1,label2)=ifsimilaritiesatframe(label1,label2)+ucm3f(i,j); %This could be a max
                ifsimilaritiesatframe(label2,label1)=ifsimilaritiesatframe(label1,label2);
                lengthsatframe(label1,label2)=lengthsatframe(label1,label2)+1;
                lengthsatframe(label2,label1)=lengthsatframe(label1,label2);
            end
        end
    end
    %Scan of vertical edges
    for i=2:2:size(ucm3f,1)
        for j=3:2:(size(ucm3f,2)-1) %j scans for edges
            if ( (ucm3f(i,j)>0) && (ucm3f(i,j-1)~=ucm3f(i,j+1)) ) %The second test should always be true
                label1=ucm3f(i,j-1);
                label2=ucm3f(i,j+1);
                ifsimilaritiesatframe(label1,label2)=ifsimilaritiesatframe(label1,label2)+ucm3f(i,j); %This could be a max
                ifsimilaritiesatframe(label2,label1)=ifsimilaritiesatframe(label1,label2);
                lengthsatframe(label1,label2)=lengthsatframe(label1,label2)+1;
                lengthsatframe(label2,label1)=lengthsatframe(label1,label2);
            end
        end
    end

%     numel(find(lengthsatframe>0))
%     numel(find(ifsimilaritiesatframe>0))
%     Init_figure_no(7), imagesc(lengthsatframe>0)
%     Init_figure_no(8), imagesc(ifsimilaritiesatframe>0)
%     unique(ifsimilaritiesatframe)
%     unique(lengthsatframe)


    %If max is adopted this step is not necessary
    ifsimilaritiesatframe(lengthsatframe>0)=max(zerosparsevalue,  ( maxucm2 - (ifsimilaritiesatframe(lengthsatframe>0)./lengthsatframe(lengthsatframe>0)) ) / maxucm2  );

    [r,c]=find(lengthsatframe>0);

    sx=[sx;mapped(f,r)'];
    sy=[sy;mapped(f,c)'];
    sv=[sv;ifsimilaritiesatframe(sub2ind(size(ifsimilaritiesatframe),r,c))];
    lv=[lv;lengthsatframe(sub2ind(size(ifsimilaritiesatframe),r,c))];
end



ABA=Getabafromindexedrawvalues(sx,sy,sv,noallsuperpixels,options);
boundarylengths=sparse(sx,sy,lv,noallsuperpixels,noallsuperpixels);



%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='aba';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration(sx,sy,sv,thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end
