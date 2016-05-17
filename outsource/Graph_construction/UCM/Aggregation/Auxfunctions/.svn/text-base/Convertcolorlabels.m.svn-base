function vslabels=Convertcolorlabels(vsout,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



%Elaborate on colored image and obtain labels
vslabels=zeros([size(vsout{1},1),size(vsout{1},2),numel(vsout)]);
vslabels2=zeros([size(vsout{1},1),size(vsout{1},2),numel(vsout)]);
vslabels3=zeros([size(vsout{1},1),size(vsout{1},2),numel(vsout)]);
for f=1:numel(vsout)
    vslabels(:,:,f)=vsout{f}(:,:,1);
    vslabels2(:,:,f)=vsout{f}(:,:,2);
    vslabels3(:,:,f)=vsout{f}(:,:,3);
end
[C,ia,ic] = unique( [reshape(vslabels,[],1,1), reshape(vslabels2,[],1,1), reshape(vslabels3,[],1,1)], 'rows'); %#ok<ASGLU>

vslabels = reshape( ic , size(vslabels) );



if (printonscreen)
    Printthevideoonscreen(vslabels,printonscreen,1,false,true,false,false); %(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext)
end



%Previous code, only converting per frame without keeping label consistency
% vslabels=zeros([size(vsout{1},1),size(vsout{1},2),numel(vsout)]);
% for f=1:numel(vsout)
%     vsarray=[reshape(vsout{f}(:,:,1),[],1), reshape(vsout{f}(:,:,2),[],1), reshape(vsout{f}(:,:,3),[],1)];
%     [C,ia,ic] = unique(vsarray,'rows'); %#ok<ASGLU>
%     vslabels(:,:,f)=(reshape( ic , [size(vsout{f},1),size(vsout{f},2)] ));
% end
% printonscreeninsidefunction=false;
% if (printonscreeninsidefunction)
%     Printthevideoonscreen(vslabels,true,1,false,true,false,false); %(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext)
% end

%Previous code to convert HGB and SWA
% vslabels=zeros([size(vsout{1},1),size(vsout{1},2),numel(vsout)]);
% for f=1:numel(vsout)
%     vsarray=[reshape(vsout{f}(:,:,1),[],1), reshape(vsout{f}(:,:,2),[],1), reshape(vsout{f}(:,:,3),[],1)];
%     [C,ia,ic] = unique(vsarray,'rows'); %#ok<ASGLU>
%     vslabels(:,:,f)=(reshape( ic , [size(vsout{f},1),size(vsout{f},2)] ));
%     if (printonscreeninsidefunction)
%         Init_figure_no(2), imagesc(vslabels(:,:,f)) %#ok<UNRCH>
%         fprintf('Level %d frame %d number of labels %d\n',i,f,size(C,1));
%     end
% end
