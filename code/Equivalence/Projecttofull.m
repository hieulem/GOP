function newsegmwithuniquelabels=Projecttofull(SCSolution,previouslabelsbackmap,uniquelabelswhichmustlink,maxnewlabelsalreadyassigned,superpixelization)
%Outputs:
% - newsegmwithuniquelabels sequence of nodes / video where the
%clustering result has been superposed to the must-link constraint result



maxassignedlabel=maxnewlabelsalreadyassigned; %This ccoincides with max(twsegmentation(:));
[twcmergetuples,newassignedlabel,previouslabelsbackmap]=Getmergingtuples(SCSolution,maxassignedlabel,previouslabelsbackmap,maxnewlabelsalreadyassigned);



framesdone=0;
newsegmentation=Transferclustermappingtosegmentation(SCSolution,newassignedlabel,uniquelabelswhichmustlink,superpixelization,framesdone,previouslabelsbackmap);

%Take unique labels for the backprojected clustered reduced graph
[tmpunique,tmplabelspos,newsegmwithuniquelabels]=unique(newsegmentation);
newsegmwithuniquelabels=reshape(newsegmwithuniquelabels,size(newsegmentation));



