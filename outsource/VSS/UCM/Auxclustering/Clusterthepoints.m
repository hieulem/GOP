function [IDX,kmeansdone,offext,C]=Clusterthepoints(Y,clusteringmethod,noGroups,dimtouse,noreplicates,...
    tryonlinefirst,readidxcs,saveidxcs,filenames,options)
%The function clusters the points in Y (ISOMAP-like format) according to
%the specified clusteringmethod
%The function takes into account the points missing in Y (Y.missing)
%The function output is remapped and corresponds to original data (Y.index)
%C is not remapped, it only applies to points with a manifold position



%Input preparation
if (~exist('options','var'))
    options=[];
end
if ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=6;
end
if ( (~exist('noreplicates','var')) || (isempty(noreplicates)) )
    noreplicates=600;
end
if ( (~exist('tryonlinefirst','var')) || (isempty(tryonlinefirst)) )
    tryonlinefirst=true;
end
if ( (~exist('saveidxcs','var')) || (isempty(saveidxcs)) || (~exist('filenames','var')) || ...
        (~isstruct(filenames)) || (~isfield(filenames,'idxpicsandvideobasedir')) )
    saveidxcs=false;
end
if ( (~exist('readidxcs','var')) || (isempty(readidxcs)) || (~exist('filenames','var')) || ...
        (~isstruct(filenames)) || (~isfield(filenames,'idxpicsandvideobasedir')) )
    readidxcs=false;
end



%This check is introduced because this same function is also used for
%loading the pre-computed idx's
if ( (isempty(Y)) || (~isstruct(Y)) || (isempty(clusteringmethod)) )
    justforreading=true;
else
    justforreading=false;
end



%%%needed inputs: Y, dimtouse, noGroups%%%
IDX=[]; offext=''; kmeansdone=false; C=[]; %Empty values initialised
warning('off','stats:kmeans:EmptyCluster'); %so as to not display output of Kmeans
warning('off','stats:kmeans:FailedToConverge'); %so as to not display output of Kmeans
if (~justforreading)
    chosend=Getchosend(Y,dimtouse);
end
% chosend= find(options.dims==dimtouse,1,'first');
for agroupnumber=noGroups
    
    if ( readidxcs || saveidxcs)
        filenameidxbasename=[filenames.idxpicsandvideobasedir,'Idx',filesep,'Idx_',num2str(agroupnumber),'_',num2str(dimtouse)];
            %filename is [filenameidxbasename,offext,'.mat'] where offext is '' or 'off'
    end
    
    if (readidxcs)
        if ( (exist([filenameidxbasename,'.mat'],'file')) || (exist([filenameidxbasename,'off','.mat'],'file')) )
            if (exist([filenameidxbasename,'.mat'],'file'))
                load([filenameidxbasename,'.mat']);
                offext='';
                fprintf('%d groups, idx already computed (loaded)\n',agroupnumber);
            else %(exist([filenameidxbasename,'off','.mat'],'file')) )
                load([filenameidxbasename,'off','.mat']);
                offext='off';
                fprintf('%d groups, idx (off) already computed (loaded)\n',agroupnumber);
            end
            kmeansdone=true;
            continue;
        end
    end
    
    if (justforreading)
        fprintf('Y or clusteringmethod not defined and idx not precomputed\n');
        continue;
    end
    
    kmeansdone=false;
    if (tryonlinefirst)
        try
            % Y.coords{chosend}=[no_dims x no_points]
            % clusteringmethod='km','km2','km3','meanshift'
            if (strcmp(clusteringmethod,'km'))
                [IDX,C] = kmeans((Y.coords{chosend})',agroupnumber,'Replicates',noreplicates,'emptyaction','drop'); %online phase on
            elseif (strcmp(clusteringmethod,'km3'))
                [Ctmp,IDXtmp] = vl_kmeans((Y.coords{chosend}),agroupnumber,'NumRepetitions',noreplicates,...
                    'Initialization','randsel','Algorithm','elkan'); %,Energy
                        %,'Algorithm','elkan','lloyd'
                        %,'Initialization','randsel','plusplus'
                IDX=IDXtmp';
                C=Ctmp';
            else
                error('Clustering method not recognised\n');
            end
            IDX=Adjusttheoutliers(IDX); %outliers (-1) are incorporated as single points, outliers (-10) are preserved
            offext='';
            kmeansdone=true;
        catch MEf %#ok<NASGU>
            fprintf('%d groups, online phase on could  not find a solution\n',agroupnumber);
            try
                [IDX,C] = kmeans((Y.coords{chosend})',agroupnumber,'Replicates',noreplicates,'emptyaction','drop','onlinephase','off');
                kmeansdone=true;
                offext='off';
            catch MEs %#ok<NASGU>
                fprintf('%d groups, online phase off could  not find a solution\n',agroupnumber);
            end
        end
    else
        try
            [IDX,C] = kmeans((Y.coords{chosend})',agroupnumber,'Replicates',noreplicates,'emptyaction','drop','onlinephase','off');
            kmeansdone=true;
            offext='off';
        catch MEs %#ok<NASGU>
            fprintf('%d groups, online phase off could  not find a solution\n',agroupnumber);
        end
    end
    if (~kmeansdone)
        fprintf('%d groups: kmeans did not converge\n',agroupnumber);
        continue;
    end
    
    Printdroppedcenters(C,agroupnumber);
    
    %Print dropped IDX's and compact them
    IDX=Compactidxnew(IDX,agroupnumber);
    
    %remap IDX so that it corresponds to original points in D
    %check that Y has embedded all elements
    if (isfield(Y,'missing') && (~isempty(Y.missing)))
        remappedIDX=zeros(numel(Y.index)+numel(Y.missing),1);
        totalassigned=max(IDX);
        remappedIDX(Y.index)=IDX;
        remappedIDX(Y.missing)=(totalassigned+1):(totalassigned+numel(Y.missing));
            %reshape((totalassigned+1):(totalassigned+numel(Y.missing)),[],1);
        fprintf('%d new clusters assigned to non-embedded elements\n',numel(Y.missing));
    else
        remappedIDX=zeros(numel(Y.index),1);
        remappedIDX(Y.index)=IDX;
    end
    IDX=remappedIDX;
%     clear remappedIDX;
    
    if (saveidxcs)
        save([filenameidxbasename,offext,'.mat'], 'IDX','C','-v7.3');
    end
    fprintf('\n%d groups done\n\n',agroupnumber);
end
%%%%%%


