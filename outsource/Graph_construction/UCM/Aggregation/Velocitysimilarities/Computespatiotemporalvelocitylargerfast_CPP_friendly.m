function STM=Computespatiotemporalvelocitylargerfast_CPP_friendly(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,flows,mapped,thedepth,stsimilarities,temporaldepth,printonscreen, options, theoptiondata, filenames)

%paper options:
% options.stmrefv=0.5; options.stmavf=false;

%optimized options (default):
% options.stmrefv=1.0; options.stmavf=true; options.stmlmbd=true;

if ( (~exist('temporaldepth','var')) || (isempty(temporaldepth)) )
    temporaldepth=1;
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



%Computation of all median flows and storage in array of the same size as mapped
allmedianu=zeros(size(mapped));
allmedianv=zeros(size(mapped));
for f=1:noFrames
    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});

    %compute median flows at the frame (or any other descriptor)
    for alabel=1:numberofsuperpixelsperframe(f)
        themask=(labelledlevelvideo(:,:,f)==alabel);
%         themask=(labelledlevelcell{f}==alabel);
        
        if ( (f<noFrames) && (f>1) )
            
            allmedianu(f,alabel)=median([velUp(themask);-velUm(themask)]);
            allmedianv(f,alabel)=median([velVp(themask);-velVm(themask)]);
        elseif (f<noFrames) %f==1
            allmedianu(f,alabel)=median(velUp(themask));
            allmedianv(f,alabel)=median(velVp(themask));
        else %f==noFrames
            allmedianu(f,alabel)=median(-velUm(themask));
            allmedianv(f,alabel)=median(-velVm(themask));
        end
    end
end
% Init_figure_no(6), imagesc(allmedianv)



[framebelong,labelsatframe,noallsuperpixels]=Getmappedframes(mapped);
maxnumberofsuperpixelsperframe=max(numberofsuperpixelsperframe);  % used in CPP implementation



USECPPIMPLEMENTATION=true;
if (USECPPIMPLEMENTATION)
    
    % ++++++++++++++++++++++CPP Implementation+++++++++++++++++++++++++++
    [sy,sx,sv]=CPP_friendly_STM(labelsatframe,constcc,constrr,framebelong,noallsuperpixels,noFrames,temporaldepth,concc,conrr,thedepth,allmedianu,allmedianv,maxnumberofsuperpixelsperframe);
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

else
    
    %++++++++++++++++++++++Matlab Implementation+++++++++++++++++++++++++++
    similarity=sparse(noallsuperpixels,noallsuperpixels);
    similaritydone=sparse(noallsuperpixels,noallsuperpixels); %In CPP a boolean
    for f=1:noFrames
        spatf=find(framebelong==f);

        for asp=spatf %scan all superpixels at frame f
            tempneighlabels=constcc(constrr==asp); %global label
            tempneighlabels=unique([asp;tempneighlabels;constrr(constcc==asp)]);

            %determine which frames these global labels correspond to
            tempneighframes=framebelong(tempneighlabels)';

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
                        ( (allmedianu(f,neighlabel_local)-allmedianu(neighframe, volumelabel_local))^2 +...
                        (allmedianv(f,neighlabel_local)-allmedianv(neighframe, volumelabel_local))^2 );
                    similarity(neighlabel,volumelabel)=similarity(volumelabel,neighlabel);
                    similaritydone(neighlabel,volumelabel)=true;
                    similaritydone(volumelabel,neighlabel)=true;
                end

            end       
        end
    end
%     [sx,sy,sv] = find(similarity); %This version does not report the affinities defined zero

    %Get the graph from similaritydone and the value from similarity
    [sx, sy, sv]=find(similaritydone);
    sv=similarity(sub2ind(size(similarity),sx,sy));
    
    %++++++++++++++++++++++Matlab Implementation ENDS+++++++++++++++++++++++++++
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



% sx=[sxf;sxo;syo]; sy=[syf;syo;sxo]; sv=[svf;svo;svo];
% afullmatrix=false(noallsuperpixels);
% count=0;
% for i=1:numel(sx)
%     if (afullmatrix(sx(i),sy(i)))
%         count=count+1;
%         fprintf('Element %d (frame %d, local label %d) - element %d (frame %d, local label %d)\n',...
%             sx(i),framebelong(sx(i)),labelsatframe(sx(i)),sy(i),framebelong(sy(i)),labelsatframe(sy(i)) );
%     end
%     afullmatrix(sx(i),sy(i))=true;
% end
% fprintf('Double elememts %d\n',count);



STM=Getstmfromindexedrawvalues(sx, sy, sv, noallsuperpixels, options);

if (printonscreen)
    Init_figure_no(6); spy(STM(1:1000,1:1000));
    Init_figure_no(6); spy(STM);
end



%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='stm';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration([sxf;sxo;syo],[syf;syo;sxo],[svf;svo;svo],thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end





function Compare_with_velocitylargersimilarities(velocitylargersimilarities,STM) %#ok<DEFNU>

isequal(velocitylargersimilarities,STM)

isequal(full(velocitylargersimilarities)>0,full(STM)>0)

max(max(abs(full(velocitylargersimilarities)-full(STM))))







