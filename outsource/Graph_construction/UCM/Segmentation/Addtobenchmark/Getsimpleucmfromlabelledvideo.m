function ucm2=Getsimpleucmfromlabelledvideo(labelledvideo,ucm2size,printonscreen)
%Function Getucmfromlabelledvideo performs a similar task, allowing
%modification of a previously created ucm2 file and specification of Level

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('ucm2size','var')) || (isempty(ucm2size)) )
    ucm2size=[size(labelledvideo,1)*2+1,size(labelledvideo,2)*2+1];
end

noFrames=size(labelledvideo,3);

%Initialize a new ucm2
ucm2=cell(1,noFrames);
for f=1:noFrames
    ucm2{f}=uint8(zeros(ucm2size));
end
%Compute ucm2 according to the boundaries in labelledvideo
ucm2=Addtoucm2wmex(1:noFrames,labelledvideo,ucm2,size(labelledvideo,1),size(labelledvideo,2),noFrames);
% for ff=1:noFrames
%     ucm2=Addtoucm2wmex(ff,labelledvideo,ucm2,size(labelledvideo,1),size(labelledvideo,2),1);
% end

if (printonscreen)
    Init_figure_no(10)
    for f=1:noFrames
        imagesc(ucm2{f})
        pause(0.1)
    end
end

