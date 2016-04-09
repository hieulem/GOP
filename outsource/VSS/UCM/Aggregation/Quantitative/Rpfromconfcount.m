function [cntprec,sumprec,cntrec,sumrec,avgsumprec,nprec,avgsumrec,nrec,ntlabels]=Rpfromconfcount(confcountssized,indextouse,segareas,gtareas,skipfirstlabel)
%ntlabels generally coincides with nrec and nprec, unless the first label
%is skipped

if ( (~exist('skipfirstlabel','var')) || (isempty(skipfirstlabel)) )
    skipfirstlabel=false; %The first label in the GT is generally the background
end

%The dependency of variables is taken from the function Getaccuracies

newconfcount=zeros(size(confcountssized,2)); %the confidence count matrix given by the optimal assignment indicated in indextouse
for i=1:size(confcountssized,2)
    newconfcount(i,:)=newconfcount(i,:)+sum(confcountssized(indextouse==i,:),1);
end

overlapseg=max(newconfcount,[],2);
overlapsGT = max(newconfcount, [], 1);

%%%Global
%Precision (unaffected by the reassignment)
cntprec = sum(overlapseg); %overlapseg for the max overlap case can also be the original one
sumprec = sum(segareas); %Zeros labels are counted for the areas, -1 labels are not counted at all (regions of frames are ignored)
%Recall
cntrec = sum(overlapsGT);
sumrec = sum(gtareas); %Zeros labels are counted for the areas, -1 labels are not counted at all (regions of frames are ignored)

%%%Average
segareasp=sum(newconfcount,2);
gtareasp=sum(newconfcount,1);

%Number of non empty GT labels
ntlabels=sum(gtareasp>0);

%Initialization, in case of empty values
avgsumprec=0;
avgsumrec=0;

precnotzero=(segareasp>0);
if (any(precnotzero))
    avgsumprec = sum ( overlapseg(precnotzero) ./ segareasp(precnotzero) );
end
nprec = ntlabels; %Non assigned GT elements (non used labels) contribute 0 precision and recall

recnotzero=(gtareasp>0);
if (any(recnotzero))
    avgsumrec = sum ( overlapsGT(recnotzero) ./ gtareasp(recnotzero) );
end
nrec = ntlabels; %Non assigned GT elements (non used labels) contribute 0 precision and recall

if (skipfirstlabel)
    cntprec=cntprec-overlapseg(1);
    sumprec=sumprec-segareasp(1);
    cntrec=cntrec-overlapsGT(1);
    sumrec=sumrec-gtareasp(1);
    
    if (precnotzero(1))
        avgsumprec=avgsumprec- ( overlapseg(1) ./ segareasp(1) );
        nprec=nprec-1;
    end
    if (recnotzero(1))
        avgsumrec=avgsumrec- ( overlapsGT(1) ./ gtareasp(1) );
        nrec=nrec-1;
    end
end
