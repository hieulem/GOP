function ratejointcoincide=Computejointcoincide(seta,setb)
%seta=intersectbksin; setb=intersectbks;
%seta=[1,2,3,4,5,6]; setb=[7,8,4,5,9,6,0,10];

%The function assumes that seta and setb are row vectors

%The sum of all booleans yields the overlap
%horizontal size seta, vertical size setb
countcommon=sum(sum( repmat(seta,numel(setb),1)==repmat(setb,numel(seta),1)' ));
ratejointcoincide=2*countcommon/( numel(seta) + numel(setb) );

%The correponding matlab set operation is slower
%countcommon=numel(intersect(seta,setb));
