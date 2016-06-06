vi1 = './VSS/chisq2d_Segtrack_1_9_13_5_255_0';
vi2 = './VSS/chisq2d_Segtrack_50_9_5_5_255_1';
vi3 = './VSS/chisq2d_Segtrack_20_9_13_5_255_0';
vi4 = './VSS/baseline_Segtrack';
%ourdir = 'chisq2d_chen_20_9_13_5_255_0';
%setting = 'chisq2d_chen_100_9_13_5_255_0';
lv =20;
d= dir('./VSS/');d(1:2) =[];
%for j=1:length(d)
%if ~isempty(findstr(d(j).name, 'chen') )
%   setting = d(j).name

output = ['./muparam/',num2str(lv),'/',vi4];
if ~exist(output,'dir')
    mkdir(output);
end
t1 = dir(vi4);t1(1:2) =[];
t2 = dir(ourdir);t2(1:2) =[];

%TextMask1 = RasterizeText('\mu = 2','Times New Roman',32);
%TextMask2 = RasterizeText('\mu = 0.02','Times New Roman',32);

TextMask{2}  = RasterizeText('µ = 1','Times New Roman',32);
TextMask{3}  = RasterizeText('µ = 0.1','Times New Roman',32);
TextMask{4}  = RasterizeText('µ = 0.02','Times New Roman',32);
TextMask{1}  = RasterizeText('baseline','Times New Roman',32);
for i=1:length(t1)
    i
    n = t1(i).name;
    load(['./imgfile/',n]);
    v1 = load(fullfile(vi1,n));
    sp{2}  = v1.allthesegmentations{lv};
    v2 = load(fullfile(vi2,n));
    sp{3}  = v2.allthesegmentations{lv};
    v3 = load(fullfile(vi3,n));
    sp{4}  = v3.allthesegmentations{lv};
    v4 = load(fullfile(vi4,n));
    sp{1}  = v4.allthesegmentations{lv};
    video_from_segmetation_s(img,fullfile(output,n),sp,TextMask,0.75);
end
