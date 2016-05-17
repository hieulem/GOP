function corrsupertracks=Getcorrsupertracksmatrix(labelledlevelunique,labelledlowerunique,maxnotracks,noallsuperpixels)

alllabels=unique(labelledlevelunique);
% noTracks=numel(alllabels);

corrsupertracks=false(maxnotracks,noallsuperpixels);

    
for i=reshape(alllabels,1,[])

    suplabels=unique(labelledlowerunique(labelledlevelunique==i));

    corrsupertracks(i,suplabels)=true;
end


