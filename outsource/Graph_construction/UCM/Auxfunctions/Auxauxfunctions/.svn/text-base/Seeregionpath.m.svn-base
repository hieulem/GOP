function label=Seeregionpath(ucm2,frame,level,correspondentPath,cim)
%In the 3D part, x is towards right, y is towards bottom, as for u and v
%Here ipos is towards bottom and jpos is towards right, as i and j

if ( (~exist('cim','var')) || (isempty(cim)) )
    cim=[];
end

labels2 = bwlabel(ucm2{frame} < level);
labels = labels2(2:2:end, 2:2:end);
        
newimage=zeros(size(labels,1),size(labels,2));
newimage(:)=correspondentPath{frame}{level}(labels(:));

figure(8), title('Select a region');
[jpos,ipos]=ginput(1);
ipos=round(ipos);
jpos=round(jpos);
label=labels(ipos,jpos);

pathindex=newimage(ipos,jpos);

Graphicalcorrespondentpath(pathindex,ucm2,correspondentPath,cim);



