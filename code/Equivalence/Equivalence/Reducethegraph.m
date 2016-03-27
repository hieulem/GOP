function [twreducedsimilarities,newlabelcount,uniquelabelswhichmustlink,maxnewlabelsalreadyassigned,previouslabelsbackmap,maxuniquelabelalreadylabelled]=Reducethegraph(Wfull,mustlinks,superpixelization,pointcardinality,reducespectralclustering)



if ( (~exist('reducespectralclustering','var')) || (isempty(reducespectralclustering)) )
    reducespectralclustering=false;
end
if ( (~exist('pointcardinality','var')) || (isempty(pointcardinality)) )
    pointcardinality=ones(1,size(Wfull,1));
end



[uniquelabelswhichmustlink,maxuniquelabelalreadylabelled,maxnewlabelsalreadyassigned,previouslabelsbackmap]= Computethemustlinklabels(mustlinks,superpixelization);
% uniquelabelswhichmustlink = vector relabeling superpixels with unique
%   labels coming from mustlinks (for the segmented part) and with
%   progressive indexes (for the not yet segmented part)
%   - 1:maxuniquelabelalreadylabelled = those already labelled (compact and complete values from 1 to maxnewlabelsalreadyassigned)
%   - maxuniquelabelalreadylabelled+1:numberofsuperpixels = those still to label (progressive labels from maxnewlabelsalreadyassigned+1 for each superpixels)
%
% previouslabelsbackmap = vector backmapping the new labels (the new compact and complete ones of uniquelabelswhichmustlink) back to the
%   original labels (the values in mustlinks) JUST FOR THE SEGMENTED PART
%   Size is [1 x maxnewlabelsalreadyassigned], values are those of the original labels (thus potentially indefinitely large if the algorithm has been running for some time)



%Reduce affinity matrix according to must link labels in uniquelabelswhichmustlink
[ii,jj,vv]=find(Wfull); % size(twsimilarities,1), numel(uniquelabelswhichmustlink)-maxuniquelabelalreadylabelled



if (reducespectralclustering)
    %Reduce graph with method of Hein and then reweight with the new method
    [ii,jj,vv,newlabelcount]=Reduceaffinityequivalentgraphcountmex(ii,jj,vv,uniquelabelswhichmustlink,pointcardinality); % Reduceaffinityequivalentgraphcountmex.cpp
    
    [ii,jj,vv]=Reducenewquivwithhein(ii,jj,vv,newlabelcount);
    
    %Alternative method: this uses the equations in the mex function directly, it is thus faster but does not allow for iterative use
    % [ii,jj,vv,newlabelcount]=Reducenewaffinityequivalentgraphmex(ii,jj,vv,uniquelabelswhichmustlink); % Reducenewaffinityequivalentgraphmex.cpp
else
    
    [ii,jj,vv,newlabelcount]=Reduceaffinityequivalentgraphcountmex(ii,jj,vv,uniquelabelswhichmustlink,pointcardinality); % Reduceaffinityequivalentgraphcountmex.cpp
end
%In a real iterative fashion newlabelcount is used to keep using the reduction method (in the case of the new method, as the method of Hein does not require this)



newsize=max(uniquelabelswhichmustlink(:));
twreducedsimilarities=sparse(ii,jj,vv,newsize,newsize); 

