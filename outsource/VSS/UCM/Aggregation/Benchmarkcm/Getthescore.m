function score=Getthescore(stepk,createdk,mostats,jistats,densitystats,lengthstats,evstat,useglobal)

if ( (~exist('useglobal','var')) || (isempty(useglobal)) )
    useglobal=true;
end



if (useglobal) %average and global values are summed over the all dataset sequences
    score=[stepk,createdk,mostats.nprec,mostats.avgprec,mostats.avgrec,...
        mostats.cntprec,mostats.sumprec,mostats.sumrec, densitystats.coveredpixels,densitystats.totpixels, lengthstats.cntlengths,lengthstats.cntsqlengths,...
        jistats.avgprec,jistats.avgrec, jistats.cntprec,jistats.sumprec, evstat, mostats.cntrec,mostats.nrec, jistats.cntrec,jistats.nrec,jistats.nprec,jistats.sumrec];
else %average and global values in each sequence are averaged over the dataset (each sequence get equal weight)
    score=[stepk,createdk,-1,mostats.avgprec,mostats.avgrec,...
        mostats.globprec,-1,-1, densitystats.density,-1, lengthstats.meanlength,lengthstats.stdlength,...
        jistats.avgprec,jistats.avgrec, jistats.globprec,-1, evstat, mostats.globrec,-1, jistats.globrec,-1,-1,-1];
end
