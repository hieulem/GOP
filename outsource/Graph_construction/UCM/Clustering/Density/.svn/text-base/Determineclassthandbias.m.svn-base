function [bestclass,bestpos,bestnclusters,reachednpoints]=Determineclassthandbias(neworder,newrd,Rdsorted,acluster,npoints,thepos,printonscreen)
% npoints=size(x,1);
%thepos refers to Rdsorted values
%it is returned for successive searches
%neworder and newrd are extracted with Optics, they refer to each point in the
%manifold
%newrd(i) is the reachability of point x(i,:)
%neworder(i) is the neworder of point x(i,:)
%The result of the function is class and numberofclusters, in return to the
%requested acluster. thepos is to be interpreted:
%[class,numberofclusters]=Labelwiththreshold(neworder,newrd,Rdsorted(thepos),npoints)
%so the corresponding value to obtain numberofclusters is Rdsorted(thepos)
%but it should only be applied to RD with an extra value (see
%Clustertoreachability)


if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;



[bestclass,bestnclusters]=Labelwiththreshold(neworder,newrd,Rdsorted(thepos),npoints,printonscreen); %amargin is subtracted before comparison in the function
bestdistclusters=abs(bestnclusters-acluster);
bestpos=thepos;
if (printonscreeninsidefunction)
    Init_figure_no(10), bar(1:npoints,bestclass(neworder),'y')
    hold on, plot(1:npoints,repmat(Rdsorted(thepos),1,npoints),'r'), hold off;
    hold on, bar(1:npoints,Rdordered,'b'), hold off;
end



numberofclusters=bestnclusters;
while ((numberofclusters<acluster)&&(thepos<npoints))
    
    thepos=thepos+1;
    
    [class,numberofclusters]=Labelwiththreshold(neworder,newrd,Rdsorted(thepos),npoints,printonscreen); %amargin is subtracted before comparison in the function

    
    if ( abs(numberofclusters-acluster)<bestdistclusters )
        bestclass=class;
        bestnclusters=numberofclusters;
        bestdistclusters=abs(numberofclusters-acluster);
        bestpos=thepos;
    end
    
end



reachednpoints=(thepos>=npoints);



% thepos=bestpos;