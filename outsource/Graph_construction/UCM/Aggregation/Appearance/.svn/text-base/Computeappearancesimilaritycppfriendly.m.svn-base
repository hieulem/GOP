function STA=Computeappearancesimilaritycppfriendly(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,cim,mapped,thedepth,stsimilarities,temporaldepth,printonscreen, options, theoptiondata, filenames)

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



%labels for each frame at Level are stored as they are used several times
% labelledlevelvideo
% Transpose is actually unnecessary
% numberofsuperpixelsperframe=squeeze(max(max(labelledlevelvideo,[],1),[],2))';
% Level=1;
% allframelabels=cell(1,noFrames);
% numberofsuperpixelsperframe=zeros(1,noFrames);
% for f=1:noFrames
%     labels2 = bwlabel(ucm2{f} < Level);
%     allframelabels{f} = labels2(2:2:end, 2:2:end);
%     numberofsuperpixelsperframe(f)=max(allframelabels{f}(:));
%     Init_figure_no(6), imagesc(labels)
% end



% minL=0; maxL=100;
% minab=-86.1812575110439383; maxab=98.2351514395151639;
thelabs.l=cell(1,noFrames); thelabs.a=cell(1,noFrames); thelabs.b=cell(1,noFrames);
for f=1:noFrames
    [thelabs.l{f},thelabs.a{f},thelabs.b{f}] = Rgbtolab(cim{f});
%     thelabs.l{f}=thelabs.l{f}./(maxL-minL);
%     thelabs.a{f}=thelabs.a{f}./(maxab-minab);
%     thelabs.b{f}=thelabs.b{f}./(maxab-minab);
end



%Computation of all median colors and storage in array of the same size as mapped
allmedianl=zeros(size(mapped));
allmediana=zeros(size(mapped));
allmedianb=zeros(size(mapped));
for f=1:noFrames

    %compute median colors at the frame (or any other descriptor)
    for alabel=1:numberofsuperpixelsperframe(f)
        themask=(labelledlevelvideo(:,:,f)==alabel);
%         themask=(allframelabels{f}==alabel);
        
        allmedianl(f,alabel)=median(thelabs.l{f}(themask));
        allmediana(f,alabel)=median(thelabs.a{f}(themask));
        allmedianb(f,alabel)=median(thelabs.b{f}(themask));
        
    end
end
% Init_figure_no(6), imagesc(allmedianl)



[framebelong,labelsatframe,noallsuperpixels]=Getmappedframes(mapped);
maxnumberofsuperpixelsperframe=max(numberofsuperpixelsperframe);


USECPPIMPLEMENTATION=true;
if (USECPPIMPLEMENTATION)
    
    % +++++++++++++++++++++++CPP Implementation++++++++++++++++++++++
    [sy,sx,sv]=CPP_friendly_app_sim(labelsatframe,constcc,constrr,framebelong,noallsuperpixels,noFrames,temporaldepth,concc,conrr,thedepth,allmedianl,allmediana,allmedianb,maxnumberofsuperpixelsperframe);
    % +++++++++++++++++++++++CPP IMplementation ends+++++++++++++++++++++++

else
    
    % ++++++++++++++++++++++++++Matlab Implementation++++++++++++++++++++

    similarity=sparse(noallsuperpixels,noallsuperpixels);
    similaritydone=sparse(noallsuperpixels,noallsuperpixels); %In CPP a boolean
    for f=1:noFrames
        spatf=find(framebelong==f);
        for asp=spatf %scan all superpixels at frame f
            %asp is in global labelling, localsp is in local labelling
    %         localsp=labelsatframe(asp);

            %the temporal connection are determined according to
            %stsimilarities, additionally only connecttions above a certain
            %threshold (minimum 1) can be considered
            tempneighlabels=constcc(constrr==asp); %global label
            tempneighlabels=unique([asp;tempneighlabels;constrr(constcc==asp)]);

            %determine which frames these global labels correspond to
            tempneighframes=framebelong(tempneighlabels)';

    % %         neighlabelsremove=( (tempneighframes>(f+temporaldepth)) | (tempneighframes<f) ) nOT LOOKING TO THE PREVIOUS FRAME;
             neighlabelsremove =( (tempneighframes>(f+temporaldepth)) | (tempneighframes<(f-temporaldepth)) );
            tempneighlabels(neighlabelsremove)=[];
            tempneighframes(neighlabelsremove)=[];


            touchedlabels=asp;

            neighlabels=Getneighborlabels(touchedlabels,concc,conrr,thedepth,printonscreeninsidefunction,labelledlevelvideo(:,:,f),mapped);
            neighlabels=unique([touchedlabels;neighlabels]); %include touchedlabels in neighlabels (included already for thedepth>1)


            %process labels at each frame in the range
            for volumelabelidx=1:numel(tempneighlabels)
                volumelabel=tempneighlabels(volumelabelidx);
                volumelabel_local = labelsatframe(tempneighlabels(volumelabelidx));

                neighframe=tempneighframes(volumelabelidx);


                for nl=1:numel(neighlabels)
                    neighlabel=neighlabels(nl);
                    neighlabel_local = labelsatframe(neighlabels(nl));
    %                 neighlocallabel=labelsatframe(neighlabel);

                    if (similaritydone(volumelabel,neighlabel))
                        continue;
                    end
                    similarity(volumelabel,neighlabel)=...
                        ( (allmedianl(f,neighlabel_local)-allmedianl(neighframe, volumelabel_local))^2 +...
                        (allmediana(f,neighlabel_local)-allmediana(neighframe, volumelabel_local))^2 +...
                        (allmedianb(f,neighlabel_local)-allmedianb(neighframe, volumelabel_local))^2 );
                    similarity(neighlabel,volumelabel)=similarity(volumelabel,neighlabel);
                    similaritydone(neighlabel,volumelabel)=true;
                    similaritydone(volumelabel,neighlabel)=true;
                end

            end       
        end
    end
    
    %Get the graph from similaritydone and the value from similarity
    [sx, sy, sv]=find(similaritydone);
    sv=similarity(sub2ind(size(similarity),sx,sy));
    
%     [sx, sy, sv]=find(similarity); %This version does not report the affinities defined zero
%     similarity2=sparse(sx,sy,sv);
%     isequal(similarity,similarity2)
    
    % ++++++++++ Here ENDS the Matlab Implementation++++++++++++++++++++

end

% themean=mean(svf);
% thestd=std(svf);
% themin=min(svf);
% themax=max(svf);
% themedian=median(svf);
% fprintf('At frame: min %.10f, max %.10f, mean %.10f, median %.10f, std %0.10f\n',themin,themax,themean,themedian,thestd)
% themean=mean(svo);
% thestd=std(svo);
% themin=min(svo);
% themax=max(svo);
% themedian=median(svo);
% fprintf('At other frames: min %.10f, max %.10f, mean %.10f, median %.10f, std %0.10f\n',themin,themax,themean,themedian,thestd)





STA=Getstafromindexedrawvalues(sx, sy, sv, noallsuperpixels, options);

if (printonscreen)
    Init_figure_no(6); spy(STA(1:1000,1:1000));
    Init_figure_no(6); spy(STA);
    Spywithcolor(STA(1:1204,1:1204),6,mapped)
end



%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='sta';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration(sx,sy,sv,thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end






function Compare_with_velocitylargersimilarities(velocitylargersimilarities,STA) %#ok<DEFNU>

isequal(velocitylargersimilarities,STA)

isequal(full(velocitylargersimilarities)>0,full(STA)>0)

max(max(abs(full(velocitylargersimilarities)-full(STA))))





