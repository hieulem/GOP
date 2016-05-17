function ratecoincide=Computeratecoincide(seta,setb)
%seta=intersectbksin; setb=intersectbks;
%seta=[1,2,3,4,5,6]; setb=[7,8,4,5,9,6,0,10];

%The function assumes that seta and setb are row vectors

%The sum of all booleans yields the overlap
%horizontal size seta, vertical size setb
countcommon=sum(sum( repmat(seta,numel(setb),1)==repmat(setb,numel(seta),1)' ));
rateb=countcommon/numel(setb);
ratea=countcommon/numel(seta);
ratecoincide=min(ratea,rateb);






function ratecoincide=Otherfunctions() %#ok<DEFNU>

crossmatrix=false(numel(seta),numel(setb));
for i=1:numel(seta)
    a=seta(i);
    crossmatrix(i,:)=(a==setb);
end
sumsum=sum(crossmatrix(:));
rateb=sumsum/numel(setb);
ratea=sumsum/numel(seta);
ratecoincide=min(ratea,rateb);



%No need to make it symmetric
crossmatrix=(crossmatrix|crossmatrix');
for i=1:numel(setb)
    b=setb(i);
    crossmatrix(:,i)=(seta==b)';
end

