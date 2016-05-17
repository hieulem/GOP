function [matrix,vminus,vplus]=Adjustthematrix(matrix,minlimit,maxlimit)

vminus=zeros(size(matrix));
vplus=zeros(size(matrix));

whichbiggermin=(matrix>=minlimit);
whichsmallermax=(matrix<=maxlimit);

whichboth=whichbiggermin&whichsmallermax;
vminus(whichboth)=floor(matrix(whichboth));
vplus(whichboth)=ceil(matrix(whichboth));

whichonlysmaller=(~whichboth)&whichsmallermax;
whichonlybigger=(~whichboth)&whichbiggermin;

matrix(whichonlysmaller)=minlimit;
vminus(whichonlysmaller)=minlimit;
vplus(whichonlysmaller)=vminus(whichonlysmaller)+1;

matrix(whichonlybigger)=maxlimit;
vplus(whichonlybigger)=maxlimit;
vminus(whichonlybigger)=vplus(whichonlybigger)-1;

whichareequal=(vplus==vminus);
[indareequal]=find(whichareequal); %indareequal, whichareequal
equalandsmaller=(vplus(indareequal)<maxlimit);
vplus(indareequal(equalandsmaller))=vminus(indareequal(equalandsmaller))+1;
vminus(indareequal(~equalandsmaller))=vplus(indareequal(~equalandsmaller))-1;
