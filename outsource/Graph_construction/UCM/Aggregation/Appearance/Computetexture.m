function [STT_max,STT_mean]=Computetexture(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,stsimilarities,temporaldepth,printonscreen, options)

%paper options:
% options.stasqv=false; options.starefv=13; options.staavf=true;

%optimized options (default):
% options.stasqv=true; options.starefv=0.005; options.staavf=true; options.stalmbd=true;

if ( (~exist('temporaldepth','var')) || (isempty(temporaldepth)) )
    temporaldepth=2;
    %graphdepth used for stsimilarities is anyway the maximum temporal depth used
end
if ( (~exist('thedepth','var')) || (isempty(thedepth)) )
    thedepth=2;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;
usecomplement=true;

noFrames=size(labelledlevelvideo,3);



%connectivity of stsimilarities is used to determine matches over-time,
%where to start building spatial neighbors from
[constrr,constcc]=Getconnectivityof(stsimilarities);

% texture
filtext = makeLMfilters;
ntext = size(filtext, 3);
[imh, imw, imc] = size(cim{1});
npix =imh*imw;
for fn=1:noFrames
imtext = zeros([imh imw ntext]);
imhsv = rgb2hsv(cim{fn});
grayim = imhsv(:, :, 3);
for f = 1:ntext
    imtext(:, :, f) = abs(imfilter(im2single(grayim), filtext(:, :, f), 'same'));    
end
[~, texthist{fn}] = max(imtext, [], 3);
textim{fn} = imtext;
end

meantext=zeros([size(mapped),ntext]);
histtext=zeros([size(mapped),ntext]);
for f=1:noFrames

    %compute median colors at the frame (or any other descriptor)
    for alabel=1:numberofsuperpixelsperframe(f)

      themask=(labelledlevelvideo(:,:,f)==alabel);
   
    % texture means
    for k = 1:ntext
        ktext = textim{f}(:,:,k);
        meantext(f,alabel,k) = mean(ktext(themask));
    end

    % texture histogram
    histtext(f,alabel, (1:ntext)) = hist(texthist{f}((themask)), (1:ntext))+1;

    end
end

[framebelong,labelsatframe,noallsuperpixels]=Getmappedframes(mapped);
maxnumberofsuperpixelsperframe=max(numberofsuperpixelsperframe);

% tic
averageconnectionthrough=4.8; averageconnectionsintra=4.8;
estimateintraterms=floor(noallsuperpixels+noallsuperpixels*(averageconnectionsintra^thedepth));
estimateinterterms=floor(estimateintraterms*(averageconnectionthrough^temporaldepth)/2);
sxf=zeros(estimateintraterms,1);
syf=zeros(estimateintraterms,1);
svf_mean=zeros(estimateintraterms,1);svf_max=zeros(estimateintraterms,1);
sxo=zeros(estimateinterterms,1);
syo=zeros(estimateinterterms,1);
svo_max=zeros(estimateinterterms,1);svo_mean=zeros(estimateinterterms,1);
noinsertedintra=0; noinsertedinter=0;
for f=1:noFrames
    spatf=find(framebelong==f);
    
    %the matrices accumulate the determined coefficient between the labels
    %at frame f and those at frames f:f+temporaldepth
    similarityatf_mean=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe); %symmetric matrix of sp at frame f
    similarityatf_max=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe); %symmetric matrix of sp at frame f
    similaritydonef=false(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe); %at f neighbors may be considered multiple times
    similarityatothers_mean=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe,temporaldepth); %similarity between sp and those at other frames
    similarityatothers_max=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe,temporaldepth); %similarity between sp and those at other frames

    similaritydoneothers=false(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe,temporaldepth); %used to extract data

    for asp=spatf %scan all superpixels at frame f
        %asp is in global labelling, localsp is in local labelling
        localsp=labelsatframe(asp);

        %the temporal connection are determined according to
        %stsimilarities, additionally only connecttions above a certain
        %threshold (minimum 1) can be considered
        tempneighlabels=constcc(constrr==asp); %global label
        tempneighlabels=[tempneighlabels;constrr(constcc==asp)]; %#ok<AGROW>

        %determine which frames these global labels correspond to
        tempneighframes=framebelong(tempneighlabels)';
        tempneighall=unique(tempneighframes);
        
        %include current frame
        tempneighall=[f;tempneighall]; %#ok<AGROW>
        %exclude frames out of bounds [f:f+temporaldepth]
        tempneighall( (tempneighall>(f+temporaldepth)) | (tempneighall<f) )=[];

        %process labels at each frame in the range
        for neighframe=tempneighall'
            if (neighframe==f)
                touchedlabels=asp;
            else
                touchedlabels=tempneighlabels(tempneighframes==neighframe);
            end

            neighlabels=Getneighborlabels(touchedlabels,concc,conrr,thedepth,printonscreeninsidefunction,labelledlevelvideo(:,:,neighframe),mapped);
%             neighlabels=Getneighborlabels(touchedlabels,concc,conrr,thedepth,printonscreeninsidefunction,allframelabels{neighframe},mapped);
            neighlabels=unique([touchedlabels;neighlabels]); %include touchedlabels in neighlabels (included already for thedepth>1)

            for nl=1:numel(neighlabels)
                neighlabel=neighlabels(nl);
                neighlocallabel=labelsatframe(neighlabel);

                if (neighframe==f) %symmetric case
                    if (similaritydonef(localsp,neighlocallabel))
                        continue;
                    end
                    s1 = meantext(f,localsp,:);
                    s2 = meantext(f,neighlocallabel,:);
                    
                    similarityatf_mean(localsp,neighlocallabel)=pdist2(s1(:)' , s2(:)', 'L1' );  
                    similarityatf_mean(neighlocallabel,localsp)= similarityatf_mean(localsp,neighlocallabel);
                    
                    s1 = histtext(f,localsp,:);
                    s2 = histtext(f,neighlocallabel,:);
                    
                    similarityatf_max(localsp,neighlocallabel)=pdist2(s1(:)' , s2(:)', 'chisq' );  
                    similarityatf_max(neighlocallabel,localsp)= similarityatf_max(localsp,neighlocallabel);
                    

                    similaritydonef(localsp,neighlocallabel)=true;
                    similaritydonef(neighlocallabel,localsp)=true;
                else %between sp at f and all others at other frames
                    
                    s1 = meantext(f,localsp,:);
                    s2 = meantext(neighframe,neighlocallabel,:);
                    
                    similarityatothers_mean(localsp,neighlocallabel,neighframe-f)=pdist2(s1(:)' , s2(:)', 'L1' );  

              
                    s1 = histtext(f,localsp,:);
                    s2 = histtext(neighframe,neighlocallabel,:);
                    
                    similarityatothers_max(localsp,neighlocallabel,neighframe-f)=pdist2(s1(:)' , s2(:)', 'chisq' );  

                    
                    
                    
                    similaritydoneothers(localsp,neighlocallabel,neighframe-f)=true;
                end
            end

        end
    end



    %complement the symmetry (neighbors are computed on f)
    if (usecomplement)
        for cf=1:min(noFrames-f,temporaldepth)
            spatf=find(framebelong==(cf+f));

            for asp=spatf %scan all superpixels at frame cf
                %asp is in global labelling, localsp is in local labelling
                localsp=labelsatframe(asp);

                %the temporal connection are determined according to
                %stsimilarities, additionally only connecttions above a certain
                %threshold (minimum 1) can be considered
                tempneighlabels=constcc(constrr==asp); %global label
                tempneighlabels=[tempneighlabels;constrr(constcc==asp)]; %#ok<AGROW>

                %determine which frames these global labels correspond to
                tempneighframes=framebelong(tempneighlabels)';

                %process labels at frame f
                touchedlabels=tempneighlabels(tempneighframes==f);

                neighlabels=Getneighborlabels(touchedlabels,concc,conrr,thedepth,printonscreeninsidefunction,labelledlevelvideo(:,:,f),mapped);
                neighlabels=unique([touchedlabels;neighlabels]); %include touchedlabels in neighlabels (included already for thedepth>1)

                for nl=1:numel(neighlabels)
                    neighlabel=neighlabels(nl);
                    neighlocallabel=labelsatframe(neighlabel);

                    %between sp at cf+f and sp at f
                    if (similaritydoneothers(neighlocallabel,localsp,cf))
                        continue;
                    end
                    s1 = meantext(cf+f,localsp,:);
                    s2 = meantext(f,neighlocallabel,:);
                    
                    similarityatothers_mean(neighlocallabel,localsp,cf)=pdist2(s1(:)' , s2(:)', 'L1' );  

              
                    s1 = histtext(cf+f,localsp,:);
                    s2 = histtext(f,neighlocallabel,:);
                    
                    similarityatothers_max(neighlocallabel,localsp,cf)=pdist2(s1(:)' , s2(:)', 'chisq' );  


                    similaritydoneothers(neighlocallabel,localsp,cf)=true;
                end

            end
        end
    end
    
    
    %extraction from similarityatf (symmetric)
    [r,c]=find(similaritydonef);
    toinserthere=numel(r);
    if (toinserthere>0) %at least diagonal points must be non-null
        sxf(noinsertedintra+1:noinsertedintra+toinserthere)=mapped(f,r)';
        syf(noinsertedintra+1:noinsertedintra+toinserthere)=mapped(f,c)';
        svf_mean(noinsertedintra+1:noinsertedintra+toinserthere)=similarityatf_mean(sub2ind(size(similarityatf_mean),r,c));
        svf_max(noinsertedintra+1:noinsertedintra+toinserthere)=similarityatf_max(sub2ind(size(similarityatf_max),r,c));
    end
    noinsertedintra=noinsertedintra+toinserthere;
    
    for ff=1:temporaldepth
        velocitysimilarityframesff_max=similarityatothers_max(:,:,ff);
        velocitysimilarityframesff_mean=similarityatothers_mean(:,:,ff);
        velocitysimilaritydoneframesff=similaritydoneothers(:,:,ff);
        
        [r,c]=find(velocitysimilaritydoneframesff);
        toinserthere=numel(r);
        
        if (toinserthere>0)
            sxo(noinsertedinter+1:noinsertedinter+toinserthere)=mapped(f,r)';
            syo(noinsertedinter+1:noinsertedinter+toinserthere)=mapped(ff+f,c)';
            svo_max(noinsertedinter+1:noinsertedinter+toinserthere)=velocitysimilarityframesff_max(sub2ind(size(velocitysimilarityframesff_max),r,c));
            svo_mean(noinsertedinter+1:noinsertedinter+toinserthere)=velocitysimilarityframesff_mean(sub2ind(size(velocitysimilarityframesff_mean),r,c));

        end
        noinsertedinter=noinsertedinter+toinserthere;
    end
    
end

sxf(noinsertedintra+1:end)=[];
syf(noinsertedintra+1:end)=[];
svf_max(noinsertedintra+1:end)=[];svf_mean(noinsertedintra+1:end)=[];
sxo(noinsertedinter+1:end)=[];
syo(noinsertedinter+1:end)=[];
svo_max(noinsertedinter+1:end)=[];svo_mean(noinsertedinter+1:end)=[];
fprintf('STA ratio estimate of terms to inserted intra %f (%d,%d), inter %f (%d,%d)\n',...
    estimateintraterms/noinsertedintra,estimateintraterms,noinsertedintra,...
    estimateinterterms/noinsertedinter,estimateinterterms,noinsertedinter);

STT_max= Getsttmfromindexedrawvalues([sxf;sxo;syo], [syf;syo;sxo], [svf_max;svo_max;svo_max], noallsuperpixels, options);
STT_mean= Getstm3fromindexedrawvalues([sxf;sxo;syo], [syf;syo;sxo], [svf_mean;svo_mean;svo_mean], noallsuperpixels, options);

if (printonscreen)
    Init_figure_no(6); spy(STA(1:1000,1:1000));
    Init_figure_no(6); spy(STA);
    Spywithcolor(STA(1:1204,1:1204),6,mapped)
end


%Add data to paramter calibration directory
% if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
%     thiscase='sta';
%     printonscreenincalibration=false;
%     Addthisdataforparametercalibration([sxf;sxo;syo],[syf;syo;sxo],[svf;svo;svo],thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
% end






function Compare_with_velocitylargersimilarities(velocitylargersimilarities,STA) %#ok<DEFNU>

isequal(velocitylargersimilarities,STA)

isequal(full(velocitylargersimilarities)>0,full(STA)>0)

max(max(abs(full(velocitylargersimilarities)-full(STA))))





