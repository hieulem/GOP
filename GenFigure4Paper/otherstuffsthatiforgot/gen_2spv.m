addpath('../mUtilities');
d = 'monkey';
gtd = '1';
d2 ='GTmonkey';
d3 = 'theirsol';
mkdir(d2);
a = dir(d);a(1:2) = [];
b = dir(gtd);b(1:2) =[];
for i=1:length(a)
    img=  imread(fullfile(d,a(i).name));
 %  tmp = allthesegmentations{4}(:,:,i) ;
    tmp = imread(fullfile(gtd,b(i).name));
    %tmp(tmp==1) = 0;
   % tmp = 1- tmp;
    
  % sp = repmat( tmp,[1,1,3]);
    img2 = img;
    img2(:,:,2) = img2(:,:,2) + tmp(:,:,2)/2;
    imwrite(img2,fullfile(d2,a(i).name));
end
%gen_cl_from_spmap(allthesegmentations{2},d2,customColors);
%gen_cl_from_spmap(allthesegmentations{2},d3,[customColors(2,:);customColors(1,:)]);
