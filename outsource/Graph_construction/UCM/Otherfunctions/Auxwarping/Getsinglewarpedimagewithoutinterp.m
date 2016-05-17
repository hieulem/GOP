function [Ccp,validtop]=Getsinglewarpedimagewithoutinterp(theflow,theimage,validtoppp)
%[Ccp,validtop]=Getsinglewarpedimagewithoutinterp(theflow,theimage,validtop);

rows=size(theimage,1);
cols=size(theimage,2);

U=theflow(:,:,1);
V=theflow(:,:,2);

if ( (numel(size(theimage))==3) && (size(theimage,3)==3) ) %theimage is a color image
    Ccp=zeros(rows,cols,3);
    Cp=zeros(rows,cols);
    for c=1:3
        imagepc=double(theimage(:,:,c));
        Cp(:)=imagepc( sub2ind(size(imagepc),max(1,min(rows,round(V(:)))),max(1,min(cols,round(U(:))))) );
        Ccp(:,:,c)=Cp(:,:);
    end
elseif ( (numel(size(theimage))==2) ) %theimage is a gray scale image
    Ccp=zeros(rows,cols);
    imagepc=double(theimage);
    Ccp(:)=imagepc( sub2ind(size(imagepc),max(1,min(rows,round(V(:)))),max(1,min(cols,round(U(:))))) );
else
    fprintf('\n\n\n\nPlease check the size of the image to warp\n\n\n\n\n\n');
end

validtop=true(rows,cols);
if ( (exist('validtoppp','var')) && (~isempty(validtoppp)) )
    validtop(:)=validtoppp( sub2ind(size(validtop),max(1,min(rows,round(V(:)))),max(1,min(cols,round(U(:))))) );
end
validtop= validtop & ( (V<=rows)&(U<=cols)&(V>=1)&(U>=1) ) ;



