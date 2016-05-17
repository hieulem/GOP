function STA=Computeappearancesimilaritychisquared(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,stsimilarities,temporaldepth,printonscreen, options, theoptiondata, filenames)

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

thelabs.l=cell(1,noFrames); thelabs.a=cell(1,noFrames); thelabs.b=cell(1,noFrames);
for f=1:noFrames
    [thelabs.l{f},thelabs.a{f},thelabs.b{f}] = Rgbtolab(cim{f});
end

%%%Compute histograms of Lab colors
BINLSZ = 8;
BINASZ = 8;
BINBSZ = 8;

res_l =    0: 100/BINLSZ: 100; res_l(1) = -Inf; res_l(BINLSZ+1) = Inf;
res_a = -100: 200/BINASZ: 100; res_a(1) = -Inf; res_a(BINASZ+1) = Inf;
res_b = -100: 200/BINBSZ: 100; res_b(1) = -Inf; res_b(BINBSZ+1) = Inf;

%Initialize memory for color histogram
onehistsize=( BINLSZ*BINASZ*BINBSZ );
hist_complete = zeros(onehistsize, max(numberofsuperpixelsperframe),noFrames);
for f=1:noFrames
    for alabel=1:numberofsuperpixelsperframe(f)
            themask=(labelledlevelvideo(:,:,f)==alabel);
            colorhist = ones(1,onehistsize); % 1 is inserted into the histograms for robustness
            [histtmp, bin_l]=histc(thelabs.l{f}(themask), res_l); %#ok<ASGLU> % max(bin_l), min(bin_l)
            [histtmp, bin_a]=histc(thelabs.a{f}(themask), res_a); %#ok<ASGLU> % max(bin_a), min(bin_a)
            [histtmp, bin_b]=histc(thelabs.b{f}(themask), res_b); %#ok<ASGLU> % max(bin_b), min(bin_b)

            linearInd = sub2ind([BINLSZ BINASZ BINBSZ], bin_l, bin_a, bin_b); % max(linearInd), min(linearInd)
            for i = 1:numel(linearInd)
               colorhist(linearInd(i))=colorhist(linearInd(i))+1;
            end
            %Normalize the color histogram
            colorhist = colorhist/(sum(colorhist(:))); %sum(colorhist(:))
            hist_complete(:,alabel,f) = colorhist;
    end
end

[framebelong,labelsatframe,noallsuperpixels]=Getmappedframes(mapped);
maxnumberofsuperpixelsperframe=max(numberofsuperpixelsperframe);

averageconnectionthrough=4.8; averageconnectionsintra=4.8;
estimateintraterms=floor(noallsuperpixels+noallsuperpixels*(averageconnectionsintra^thedepth));
estimateinterterms=floor(estimateintraterms*(averageconnectionthrough^temporaldepth)/2);
sxf=zeros(estimateintraterms,1);
syf=zeros(estimateintraterms,1);
svf=zeros(estimateintraterms,1);
sxo=zeros(estimateinterterms,1);
syo=zeros(estimateinterterms,1);
svo=zeros(estimateinterterms,1);
noinsertedintra=0; noinsertedinter=0;
for f=1:noFrames
    spatf=find(framebelong==f);
    
    %the matrices accumulate the determined coefficient between the labels
    %at frame f and those at frames f:f+temporaldepth
    similarityatf=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe); %symmetric matrix of sp at frame f
    similaritydonef=false(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe); %at f neighbors may be considered multiple times
    similarityatothers=zeros(maxnumberofsuperpixelsperframe,maxnumberofsuperpixelsperframe,temporaldepth); %similarity between sp and those at other frames
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
            neighlabels=unique([touchedlabels;neighlabels]); %include touchedlabels in neighlabels (included already for thedepth>1)

            for nl=1:numel(neighlabels)
                neighlabel=neighlabels(nl);
                neighlocallabel=labelsatframe(neighlabel);

                if (neighframe==f) %symmetric case
                    if (similaritydonef(localsp,neighlocallabel))
                        continue;
                    end
                    
                     similarityatf(localsp,neighlocallabel)=...
                        Computechisquared(hist_complete(:,localsp,f),hist_complete(:,neighlocallabel,f));    
                    similarityatf(neighlocallabel,localsp)= similarityatf(localsp,neighlocallabel);
                    similaritydonef(localsp,neighlocallabel)=true;
                    similaritydonef(neighlocallabel,localsp)=true;
                else %between sp at f and all others at other frames
                    
                    similarityatothers(localsp,neighlocallabel,neighframe-f)=...
                        Computechisquared(hist_complete(:,localsp,f),hist_complete(:,neighlocallabel,neighframe));                 
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

                    similarityatothers(neighlocallabel,localsp,cf)=... 
                        Computechisquared(hist_complete(:,localsp,cf+f),hist_complete(:,neighlocallabel,f));                   
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
        svf(noinsertedintra+1:noinsertedintra+toinserthere)=similarityatf(sub2ind(size(similarityatf),r,c));
    end
    noinsertedintra=noinsertedintra+toinserthere;
    
    for ff=1:temporaldepth
        velocitysimilarityframesff=similarityatothers(:,:,ff);
        velocitysimilaritydoneframesff=similaritydoneothers(:,:,ff);
        [r,c]=find(velocitysimilaritydoneframesff);
        toinserthere=numel(r);
        if (toinserthere>0)
            sxo(noinsertedinter+1:noinsertedinter+toinserthere)=mapped(f,r)';
            syo(noinsertedinter+1:noinsertedinter+toinserthere)=mapped(ff+f,c)';
            svo(noinsertedinter+1:noinsertedinter+toinserthere)=velocitysimilarityframesff(sub2ind(size(velocitysimilarityframesff),r,c));
        end
        noinsertedinter=noinsertedinter+toinserthere;
    end
    
end
sxf(noinsertedintra+1:end)=[];
syf(noinsertedintra+1:end)=[];
svf(noinsertedintra+1:end)=[];
sxo(noinsertedinter+1:end)=[];
syo(noinsertedinter+1:end)=[];
svo(noinsertedinter+1:end)=[];
fprintf('STA ratio estimate of terms to inserted intra %f (%d,%d), inter %f (%d,%d)\n',...
    estimateintraterms/noinsertedintra,estimateintraterms,noinsertedintra,...
    estimateinterterms/noinsertedinter,estimateinterterms,noinsertedinter);

STA=Getsta3fromindexedrawvalues([sxf;sxo;syo], [syf;syo;sxo], [svf;svo;svo], noallsuperpixels, options);
if (printonscreen)
    Init_figure_no(6); spy(STA(1:1000,1:1000));
    Init_figure_no(6); spy(STA);
    Spywithcolor(STA(1:1204,1:1204),6,mapped)
end


%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='sta';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration([sxf;sxo;syo],[syf;syo;sxo],[svf;svo;svo],thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end






function chi_dist = Computechisquared( hist_1, hist_2 )

chi_dist = 0.5*sum(   ((hist_1 -hist_2).^2)   ./   (hist_1 +hist_2)   );



function Compare_with_velocitylargersimilarities(velocitylargersimilarities,STA) %#ok<DEFNU>

isequal(velocitylargersimilarities,STA)

isequal(full(velocitylargersimilarities)>0,full(STA)>0)

max(max(abs(full(velocitylargersimilarities)-full(STA))))



function Test_this_function() %#ok<DEFNU>

[x,y,z]=meshgrid(10:20:90,-80:40:80,-80:40:80);
[histtmp, bin_l]=histc(x(:), res_l); %#ok<ASGLU> %max(bin_l), min(bin_l)
[histtmp, bin_a]=histc(y(:), res_a); %#ok<ASGLU> %max(bin_a), min(bin_a)
[histtmp, bin_b]=histc(z(:), res_b); %#ok<ASGLU> %max(bin_b), min(bin_b)
