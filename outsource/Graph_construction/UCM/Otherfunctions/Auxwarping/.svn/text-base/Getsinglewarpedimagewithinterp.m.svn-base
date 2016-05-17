function [Ccp,validtop]=Getsinglewarpedimagewithinterp(theflow,theimage,validtoppp)
% [Ccp,validtop]=Getsinglewarpedimagewithinterp(theflow,theimage,validtop);

rows=size(theimage,1);
cols=size(theimage,2);


U=theflow(:,:,1);
V=theflow(:,:,2);

validtop=true(rows,cols);

if ( (exist('validtoppp','var')) && (~isempty(validtoppp)) )
    validtop=Warpvalidwith(validtoppp,ceil(U),ceil(V))&validtop;
    validtop=Warpvalidwith(validtoppp,ceil(U),floor(V))&validtop;
    validtop=Warpvalidwith(validtoppp,floor(U),ceil(V))&validtop;
    validtop=Warpvalidwith(validtoppp,floor(U),floor(V))&validtop;
end

validtop= validtop & ( (V<=rows)&(U<=cols)&(V>=1)&(U>=1) ) ;

[X,Y]=meshgrid(1:cols,1:rows);

if ( (numel(size(theimage))==3) && (size(theimage,3)==3) ) %theimage is a color image
    Ccp=zeros(rows,cols,3);
    for c=1:3
        imagepc=double(theimage(:,:,c));
        Cp=zeros(rows,cols);

    %     Cp(validtop)=griddata(X(validtop),Y(validtop),imagepc(validtop),U(validtop),V(validtop));
        Cp(validtop)=interp2(X,Y,imagepc,U(validtop),V(validtop));

        Ccp(:,:,c)=Cp(:,:);
    end
elseif ( (numel(size(theimage))==2) ) %theimage is a gray scale image
    Ccp=zeros(rows,cols);
    imagepc=double(theimage);

%     Cp(validtop)=griddata(X(validtop),Y(validtop),imagepc(validtop),U(validtop),V(validtop));
    Ccp(validtop)=interp2(X,Y,imagepc,U(validtop),V(validtop));
else
    fprintf('\n\n\n\nPlease check the size of the image to warp\n\n\n\n\n\n');
end

