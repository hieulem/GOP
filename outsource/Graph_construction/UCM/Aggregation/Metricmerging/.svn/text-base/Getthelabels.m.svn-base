function [labelsfc,valid]=Getthelabels(Y, treestructure, firstbelonging, level, dimtouse,saveidxcs,printonscreen,filenames)


if ( (~exist('level','var')) || (isempty(level)) )
    level=0; %level 0 corrensponds to root (1 cluster)
end
if ( (~exist('saveidxcs','var')) || (isempty(saveidxcs)) )
    saveidxcs=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=3;
end

%Consider graph of similarities to recover connections between points
    %Or define new connection based on closest
    %Issues of tractability must be considered for the full matrix
%Compute distance along connections
%Order connections
%Compute merging paradigm

%%%needed inputs: Y, dimtouse%%%
filenameidx=[filenames.idxpicsandvideobasedir,'Idx',filesep,'Idx_',num2str(level),'_',num2str(dimtouse),'.mat'];
    %filename is [filenameidxbasename,offext,'.mat'] where offext is '' or 'off'

if (exist(filenameidx,'file'))
    load(filenameidx);
    fprintf('%d level, idx already computed (loaded)\n',level);
else
    
    %%% Computation of label assignment with treestructure %%%
    IDX=Labelthetree(treestructure, firstbelonging, level)';
    C=zeros(numel(unique(IDX)),dimtouse); %only added for compatibility
    %%%%%%

    %no need to remap IDX so that it corresponds to original points in D
    %in the case of treestructure the labels are already mapped properly
    
    if (saveidxcs)
        save(filenameidx, 'IDX','C','-v7.3');
    end
end
%%%%%%

noGroups=numel(unique(IDX));



%%% graphical presentation of Kmeans clustering, case of single noGroups
if ( (exist('IDX','var')) && (~isempty(IDX)) && (numel(noGroups)==1) && (printonscreen) )
    distributecolours=true;
    includenumbers=true;
    includegraph=true;
    Visualiseclusteredpoints(Y,IDX,2,20,distributecolours,includenumbers);
    Visualiseclusteredpoints(Y,IDX,2,21,distributecolours,[],E,includegraph);
    Visualiseclusteredpoints(Y,IDX,3,22,distributecolours,includenumbers);
end



[labelsfc]=Gettmandlabelsfcfromidx(IDX);
valid=true;

%fprintf('Level %d: groups assigned %d (valid %d)\n',level,noGroups,valid);




