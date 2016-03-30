function newsegmentation=Transferclustermappingtosegmentation(labelsfc,newassignedlabel,uniquelabelswhichmustlink,twlabelledlevelunique,framesdone,previouslabelsbackmap)



nnewclusters=max(labelsfc(:));



newlabeltolabelbackmap=ones(1,nnewclusters).*(-1);



newlabeltolabelbackmap( labelsfc(1:numel(previouslabelsbackmap)) ) = previouslabelsbackmap ;



for i=1:nnewclusters
    if (newlabeltolabelbackmap(i)==(-1))
        newassignedlabel=newassignedlabel+1;
        newlabeltolabelbackmap(i)=newassignedlabel;
    end
end



newsegmentation=newlabeltolabelbackmap(labelsfc  (uniquelabelswhichmustlink (twlabelledlevelunique(:,:,framesdone+1:end)) )  );



