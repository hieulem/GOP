name ='girl';
addpath(genpath('../code/eval_code'));
gt = ['../video/Seg/GroundTruth/', name];
load(['VSS_Segtrack/',name]);
stat1 = eval_multi_level(allthesegmentations(1:end-1),gt);
load(['VSS_newaff_Segtrack/',name]);
stat2 = eval_multi_level(allthesegmentations(1:end-1),gt);
s= [stat1,stat2]