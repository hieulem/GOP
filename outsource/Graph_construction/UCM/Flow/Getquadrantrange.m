function [mini,maxi,minj,maxj]=Getquadrantrange(quadrant,dimi,dimj)

%Limits are defined as following for dim
% dim=256;
% adim=dim/3;
% q1=1:round(adim); q2=round(adim)+1:round(2*adim); q3=round(2*adim)+1:round(3*adim);
% [numel(q1), numel(q2), numel(q3), numel([q1,q2,q3]), numel(unique([q1,q2,q3])), max([q1,q2,q3]), min([q1,q2,q3])]

aidim=dimi/3;
ajdim=dimj/3;


switch(quadrant)
    case 1
        mini=1;
        maxi=round(aidim);
        minj=1;
        maxj=round(ajdim);
        
    case 2
        mini=1;
        maxi=round(aidim);
        minj=round(ajdim)+1;
        maxj=round(2*ajdim);
        
    case 3
        mini=1;
        maxi=round(aidim);
        minj=round(2*ajdim)+1;
        maxj=round(3*ajdim);
        
    case 4
        mini=round(aidim)+1;
        maxi=round(2*aidim);
        minj=1;
        maxj=round(ajdim);
        
    case 5
        mini=round(aidim)+1;
        maxi=round(2*aidim);
        minj=round(ajdim)+1;
        maxj=round(2*ajdim);
        
    case 6
        mini=round(aidim)+1;
        maxi=round(2*aidim);
        minj=round(2*ajdim)+1;
        maxj=round(3*ajdim);

    case 7
        mini=round(2*aidim)+1;
        maxi=round(3*aidim);
        minj=1;
        maxj=round(ajdim);
        
    case 8
        mini=round(2*aidim)+1;
        maxi=round(3*aidim);
        minj=round(ajdim)+1;
        maxj=round(2*ajdim);
        
    case 9
        mini=round(2*aidim)+1;
        maxi=round(3*aidim);
        minj=round(2*ajdim)+1;
        maxj=round(3*ajdim);
        
    otherwise
        fprintf('Quadrant not recognized\n');
end