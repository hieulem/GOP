function [ stat ] = eval_one_level_chen( sv_map,path_gt )

addpath(genpath('../../../code/eval_code'));
stat=[];

    [I_h, I_w, frame_num] = size(sv_map);
    % read the ground-truth file
    [gt_map, gt_list] = read_gt_chen(path_gt, I_w, I_h);
    accu_3D = measure_accuracy_3D(gt_map, sv_map, gt_list(1,1))*100;
    ue_3D = measure_underseg_3D(gt_map, sv_map, gt_list(1,1));
    [br_3D, bp_3D, br_map_3D] = measure_boundaryrecall_3D(gt_map, sv_map);
    
    %stat = [sv_num; accu_2D; ue_2D; br_2D; accu_3D; ue_3D; br_3D; bp_3D];
    stat = [accu_3D, ue_3D, br_3D, bp_3D];


end

