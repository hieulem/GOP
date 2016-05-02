function [ ev ] = eval_ev_multi_level( set_of_sv_map,path_gt )

addpath(genpath('../code/eval_code'));
numlv = size(set_of_sv_map,2);k=0;
ev = zeros(numlv,1);
parfor i=1:numlv
    sv_map = double(set_of_sv_map{i});
    s = explained_variation_from_sp(sv_map,path_gt);
    %stat = [sv_num; accu_2D; ue_2D; br_2D; accu_3D; ue_3D; br_3D; bp_3D];
    ev(i) = s;
end;
end

