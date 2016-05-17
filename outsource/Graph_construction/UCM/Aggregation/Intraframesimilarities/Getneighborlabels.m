function neighlabels=Getneighborlabels(alabel,concc,conrr,thedepth,printonscreen,labels,mapped)
%Computes the neighbor labels to alabel, including label
%requires concc and conrr, the neighbor map obtained by 
%     labelledvideo=Labellevelframes(ucm2,Level,noFrames,printonscreen);
%     [mapped,framebelong,noalllabels,maxnolabels]=Mappedfromlabels(labelledvideo);
%     [ifsimilarities,boundarylengths]=Computeintraframe(ucm2,mapped,numberofpoints,labelledlevelvideo);
%     [conrr,concc]=Getconnectivityof(ifsimilarities);
%labels and mapped are only necessary for the output
%alabel and neighlabels are global labels, referred to the indexes assigned
%in mapped
%The function accepts multiple labels in alabel
%labels alabel are included in the neighlabels for thedepth>1

%alabel=i;

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

if (numel(alabel)>1)
    neighlabels=[];
    for ala=1:numel(alabel)
        thelabel=alabel(ala);
        neighlabels=[neighlabels;concc(conrr==thelabel)]; %#ok<AGROW>
        neighlabels=[neighlabels;conrr(concc==thelabel)]; %#ok<AGROW>
    end
    neighlabels=unique(neighlabels);
    %remove the original labels (alabel) from the neighlabels
    for ala=1:numel(alabel)
        thelabel=alabel(ala);
        neighlabels(neighlabels==thelabel)=[];
    end
elseif (numel(alabel)==1)
    neighlabels=concc(conrr==alabel);
    neighlabels=[neighlabels;conrr(concc==alabel)];
    % neighlabels=unique(neighlabels); _not needed: by constructions the neighbours of a point are not repeated
    % neighlabels(neighlabels==alabel)=[]; _not needed: by construction a point is not a neighbour of itself
else
    neighlabels=[];
    return;
end

prevneighbours=neighlabels;
for d=2:thedepth
    newneighlabels=concc(ismember(conrr,prevneighbours));
    newneighlabels=[newneighlabels;conrr(ismember(concc,prevneighbours))]; %#ok<AGROW>

    if ( (thedepth>2) && (d<thedepth) )
        prevneighbours=setdiff(newneighlabels,neighlabels);
        if (d==2)
            if (numel(alabel)>1)
                for ala=1:numel(alabel)
                    thelabel=alabel(ala);
                    prevneighbours(prevneighbours==thelabel)=[];
                end
            else
                prevneighbours(prevneighbours==alabel)=[];
            end
        end
    end
    neighlabels=unique([neighlabels;newneighlabels]); %Includes labels alabel (for thedepth>1)
    
    %code to remove alabel labels from neighlabels, alabel labels must be considered
%     if (numel(alabel)>1)
%         for ala=1:numel(alabel)
%             thelabel=alabel(ala);
%             neighlabels(neighlabels==thelabel)=[];
%         end
%     else
%         neighlabels(neighlabels==alabel)=[];
%     end
end

if (printonscreen)
    [framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped);

%     locallabel=labelsatframe(alabel);

    localneighbors=labelsatframe(neighlabels);
    themask=ismember(labels,localneighbors);
    Init_figure_no(12), imagesc(themask)


%     themask=ismember(labels,neighlabels);
%     Init_figure_no(12), imagesc(themask)
end