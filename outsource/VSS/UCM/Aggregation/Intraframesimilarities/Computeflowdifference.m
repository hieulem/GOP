function [ABM,boundarylengths]=Computeflowdifference(ucm2,mapped,noallsuperpixels,flows,labelledlevelvideo,uselocalvariance,conrr,concc,printonscreen, options, theoptiondata, filenames)
%[conrr,concc]=Getconnectivityof(ifsimilarities);

%paper options:
% options.abmrefv=0.5; options.abmpfour=false;

%optimized options (default):
% options.abmrefv=1.0; options.abmpfour=false; options.abmlmbd=true;

if (any(flows.whichDone~=3))
    fprintf('\nThe flow should be temporally median filtered and spatially in-superpixel filtered\n\n');
end



if ( (~exist('uselocalvariance','var')) || (isempty(uselocalvariance)) ||...
        (~exist('conrr','var')) || (isempty(conrr)) || (~exist('concc','var')) || (isempty(concc)))
    uselocalvariance=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

printonscreeninsidefunction=false;



zerosparsevalue=0.0000001;
Keepzerosof = @(x) max(x,zerosparsevalue);



noFrames=numel(ucm2);
[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);



%output flow difference in each boundary
flowboundary=cell(1,noFrames);
for f=1:noFrames
    flowboundary{f}=zeros(size(ucm2{f}));
end



% ABM=zeros(noallsuperpixels);
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
    
    iflowsimilaritiesatframe=zeros(numberoflabels);
    lengthsatframe=zeros(numberoflabels);

    ucm3f=double(ucm2{f});
%     Init_figure_no(3), imshow(ucm3f)
    ucm3f(2:2:end, 2:2:end)=labels;
%     Init_figure_no(5), imagesc(ucm3f)
%     size(labels2)

    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
%     Init_figure_no(6), imagesc(velUp);
%     Init_figure_no(7), imagesc(velVp);
%     Init_figure_no(8), imagesc(sqrt((velUp.^2)+(velVp.^2)));
%     
%     Init_figure_no(9), imagesc(velUm);
%     Init_figure_no(10), imagesc(velVm);
%     Init_figure_no(11), imagesc(sqrt((velUm.^2)+(velVm.^2)));
%     pause;
    
    if (uselocalvariance)
        thedepth=3;
        [flowvariancep,flowvariancem]=Computeflowvariance(conrr,concc,labels,velUp,velVp,velUm,velVm,mapped,f,labelsatframe,thedepth,printonscreeninsidefunction);
    else
        flowvariancem=ones(size(labels));
        flowvariancep=ones(size(labels));
    end
    
    %Scan of horizontal edges
    for i=3:2:(size(ucm3f,1)-1) %i scans for edges
        for j=2:2:size(ucm3f,2)
            if ( (ucm3f(i,j)>0) && (ucm3f(i-1,j)~=ucm3f(i+1,j)) ) %The second test should always be true
                label1=ucm3f(i-1,j);
                label2=ucm3f(i+1,j);
                ii1=(i-1)/2;
                ii2=(i+1)/2;
                jj1=j/2;
                jj2=j/2;
                if (f<noFrames) %p case
                    normflowfactor=max(min(flowvariancep(ii1,jj1),flowvariancep(ii2,jj2)),0.0000000001);
                    flowdifferencep= sqrt(  ( (velUp(ii1,jj1)-velUp(ii2,jj2))^2 + (velVp(ii1,jj1)-velVp(ii2,jj2))^2  / normflowfactor ) );
                end
                if (f>1) %m case
                    normflowfactor=max(min(flowvariancem(ii1,jj1),flowvariancem(ii2,jj2)),0.0000000001);
                    flowdifferencem= sqrt(  ( (velUm(ii1,jj1)-velUm(ii2,jj2))^2 + (velVm(ii1,jj1)-velVm(ii2,jj2))^2  / normflowfactor ) );
                end
                if (f==1)
                    flowdifferencem=flowdifferencep;
                elseif (f==noFrames)
                    flowdifferencep=flowdifferencem;
                end
                % flowdifferencep + flowdifferencem could include halved
                iflowsimilaritiesatframe(label1,label2)=iflowsimilaritiesatframe(label1,label2)+...
                    0.5*flowdifferencep + 0.5*flowdifferencem; %This could be a max
                iflowsimilaritiesatframe(label2,label1)=iflowsimilaritiesatframe(label1,label2);
                lengthsatframe(label1,label2)=lengthsatframe(label1,label2)+1;
                lengthsatframe(label2,label1)=lengthsatframe(label1,label2);
                
                flowboundary{f}(i,j)=Keepzerosof(0.5*flowdifferencep + 0.5*flowdifferencem);
            end
        end
    end
    %Scan of vertical edges
    for i=2:2:size(ucm3f,1)
        for j=3:2:(size(ucm3f,2)-1) %j scans for edges
            if ( (ucm3f(i,j)>0) && (ucm3f(i,j-1)~=ucm3f(i,j+1)) ) %The second test should always be true
                label1=ucm3f(i,j-1);
                label2=ucm3f(i,j+1);
                ii1=i/2;
                ii2=i/2;
                jj1=(j-1)/2;
                jj2=(j+1)/2;
                if (f<noFrames) %p case
                    normflowfactor=max(min(flowvariancep(ii1,jj1),flowvariancep(ii2,jj2)),0.0000000001);
                    flowdifferencep= sqrt(  ( (velUp(ii1,jj1)-velUp(ii2,jj2))^2 + (velVp(ii1,jj1)-velVp(ii2,jj2))^2  / normflowfactor ) );
                end
                if (f>1) %m case
                    normflowfactor=max(min(flowvariancem(ii1,jj1),flowvariancem(ii2,jj2)),0.0000000001);
                    flowdifferencem= sqrt(  ( (velUm(ii1,jj1)-velUm(ii2,jj2))^2 + (velVm(ii1,jj1)-velVm(ii2,jj2))^2  / normflowfactor ) );
                end
                if (f==1)
                    flowdifferencem=flowdifferencep;
                elseif (f==noFrames)
                    flowdifferencep=flowdifferencem;
                end
                iflowsimilaritiesatframe(label1,label2)=iflowsimilaritiesatframe(label1,label2)+...
                    0.5*flowdifferencep + 0.5*flowdifferencem; %This could be a max
                iflowsimilaritiesatframe(label2,label1)=iflowsimilaritiesatframe(label1,label2);
                lengthsatframe(label1,label2)=lengthsatframe(label1,label2)+1;
                lengthsatframe(label2,label1)=lengthsatframe(label1,label2);
                
                flowboundary{f}(i,j)=Keepzerosof(0.5*flowdifferencep + 0.5*flowdifferencem);
            end
        end
    end

%     numel(find(lengthsatframe>0))
%     numel(find(iflowsimilaritiesatframe>0))
%     Init_figure_no(7), imagesc(lengthsatframe>0)
%     Init_figure_no(8), imagesc(iflowsimilaritiesatframe>0)
%     unique(iflowsimilaritiesatframe)
%     unique(lengthsatframe)
%     Init_figure_no(2), imagesc(iflowsimilaritiesatframe)


    %If max is adopted this step is not necessary
    iflowsimilaritiesatframe(lengthsatframe>0)=(iflowsimilaritiesatframe(lengthsatframe>0)./lengthsatframe(lengthsatframe>0));
    iflowsimilaritiesatframe(lengthsatframe>0)=Keepzerosof( iflowsimilaritiesatframe(lengthsatframe>0) );

    
    [r,c]=find(lengthsatframe>0);

    sx=[sx;mapped(f,r)'];
    sy=[sy;mapped(f,c)'];
    sv=[sv;iflowsimilaritiesatframe(sub2ind(size(iflowsimilaritiesatframe),r,c))];
    lv=[lv;lengthsatframe(sub2ind(size(iflowsimilaritiesatframe),r,c))];
end



%Output results
[ABM,Normalizesv,Putinrange]=Getabmfromindexedrawvalues(sx, sy, sv, noallsuperpixels, options);

boundarylengths=sparse(sx,sy,lv,noallsuperpixels,noallsuperpixels);

if (printonscreen)
    Init_figure_no(5); spy(ABM(1:1000,1:1000));
    Init_figure_no(5); spy(ABM);
end



%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='abm';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration(sx,sy,sv,thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end



if (printonscreen)
    toscramble=false;
    showcolorbar=true;
    Printthevideoonscreen(flowboundary, true, 10, toscramble, showcolorbar);
end





%%%The part below compute statistics of edge flows based on flowboundary



if (printonscreen)
    newflowboundary=flowboundary;
    for f=1:noFrames
        newflowboundary{f}=Putinrange( Normalizesv(flowboundary{f}) ); %For normalization purposes 1-similarity
    end
    
    toscramble=false;
    showcolorbar=true;
    Printthevideoonscreen(newflowboundary, true, 10, toscramble, showcolorbar);
end

if (false)
    %This uses values averaged over each edge length to show statictics of edge flow, i.e. one value per edge
    %Statistics should consider all values, not the already averaged ones
    
    themean=mean(sv);
    thestd=std(sv);
    themin=min(sv);
    themax=max(sv);
    themedian=median(sv);
    quantilevalue=0.92;
    thequantile=quantile(sv,quantilevalue);
    fprintf('Min %.10f, max %.10f, mean %.10f, median %.10f, std %0.10f\n',themin,themax,themean,themedian,thestd)
    
end

if (printonscreen)
    %Use all edges to show statictics of edge flow
    whereflowboundary=cell(1,noFrames);
    for f=1:noFrames
        whereflowboundary{f}=flowboundary{f}>0;
    end
    if (printonscreen)
        toscramble=false;
        Printthevideoonscreen(whereflowboundary, true, 10, toscramble);
    end

    numberofedges=0;
    for f=1:noFrames
        numberofedges=numberofedges+sum(whereflowboundary{f}(:));
    end

    allvalues=zeros([numberofedges,1]);
    count=0;
    for f=1:noFrames
        edgesatframe=sum(whereflowboundary{f}(:));
        allvalues(count+1:count+edgesatframe)=flowboundary{f}(whereflowboundary{f});
        count=count+edgesatframe;
    end

    themean=mean(allvalues);
    thestd=std(allvalues);
    themin=min(allvalues);
    themax=max(allvalues);
    themedian=median(allvalues);
    
    fprintf('Min %.10f, max %.10f, mean %.10f, median %.10f, std %0.10f\n',themin,themax,themean,themedian,thestd)
end


