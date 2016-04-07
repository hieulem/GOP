
% Spectral graph reduction code
% Maintained by Fabio Galasso <research@fabiogalasso.org>
% June 2014
%
% If using this code, please cite the following:
% Spectral graph reduction for image and streaming video segmentation
% F. Galasso, M. Keuper, T. Brox, B. Schiele
% In CVPR, 2014
%
% By using this code you abide to the license agreement enclosed in the
% file License.txt
%
% Version 1.0



% clear all;
% close all;

%% Setup


% 
% Wfull = [...
%          0    0.7836    0.6859    0.4350    0.3252    0.4594    0.6451    0.6800    0.7257    0.7285;...
%     0.7836         0    0.8037    0.2678    0.3908    0.6171    0.5164    0.7093    0.6762    0.7264;...
%     0.6859    0.8037         0    0.4430    0.3772    0.6476    0.6419    0.6697    0.6077    0.5590;...
%     0.4350    0.2678    0.4430         0    0.6623    0.5952    0.5466    0.3973    0.6447    0.5779;...
%     0.3252    0.3908    0.3772    0.6623         0    0.4648    0.6215    0.6365    0.6318    0.6383;...
%     0.4594    0.6171    0.6476    0.5952    0.4648         0    1.0000    0.7618    0.8537    0.7125;...
%     0.6451    0.5164    0.6419    0.5466    0.6215    1.0000         0    0.7019    0.9209    0.8473;...
%     0.6800    0.7093    0.6697    0.3973    0.6365    0.7618    0.7019         0    0.9195    0.8100;...
%     0.7257    0.6762    0.6077    0.6447    0.6318    0.8537    0.9209    0.9195         0    0.8469;...
%     0.7285    0.7264    0.5590    0.5779    0.6383    0.7125    0.8473    0.8100    0.8469         0 ...
%     ];

%affinity_matrix = affinity_matrix;
affinity_matrix=sparse(affinity_matrix);
figure(6), imagesc(full(affinity_matrix))
title('Full W')



%% Apply spectral graph reduction



superpixelization=1:size(affinity_matrix,1); %full(Wfull)
mustlinks=[1,1,2,3,4,5,5,6,7,7]; %Unique label ID, same label indicates must-link
pointcardinality=ones(1,size(affinity_matrix,1));
reducespectralclustering=true; %if true preserves SC, if false preserves NCut

[Wequivalent,newlabelcount,uniquelabelswhichmustlink,maxnewlabelsalreadyassigned,previouslabelsbackmap,maxuniquelabelalreadylabelled]=Reducethegraph(affinity_matrix,mustlinks,superpixelization,pointcardinality,reducespectralclustering);
figure(8), imagesc(full(Wequivalent))
title('Reduced equivalent W')



%% Cluster the reduced graph



%Here spectral clustering
%SCSolution=Spectralclustering(Wequivalent)

ndimensions=5;
[mappedX,lambda]=Newlaplacian(Wequivalent,ndimensions);

[IDX,C] = kmeans(mappedX,1000,'Replicates',100,'emptyaction','drop'); %online phase on
SCSolution=reshape(IDX,1,[]);

% SCSolution=[1,1,2,2,3,3,3]; %Example of final clustering result



%% Project the result back to the full system



%Project the solution back to the original graph
segmentationlabels=Projecttofull(SCSolution,previouslabelsbackmap,uniquelabelswhichmustlink,maxnewlabelsalreadyassigned,superpixelization)



