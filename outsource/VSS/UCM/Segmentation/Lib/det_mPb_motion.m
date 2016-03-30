function [cga1, cga2, cga3, cgb1, cgb2, cgb3] = det_mPb_motion(im)
% compute image gradients. Implementation by Michael Maire.

% compute pb parts
[ ...
    cga_r5, cga_r10, cga_r20, cgb_r5, cgb_r10, cgb_r20...
    ] = mex_pb_parts_final_selected_motion(im(:,:,1),im(:,:,2),im(:,:,3));

[sx sy sz] = size(im);
temp = zeros([sx sy 8]);

for r = [5 10 20]
    for ori = 1:8
        eval(['temp(:,:,ori) = cga_r' num2str(r) '{' num2str(ori) '};']);
    end
    eval(['cga_r' num2str(r) ' = temp;']);
end
cga1 = cga_r5; cga2 = cga_r10;  cga3 = cga_r20; 

for r = [5 10 20]
    for ori = 1:8
        eval(['temp(:,:,ori) = cgb_r' num2str(r) '{' num2str(ori) '};']);
    end
    eval(['cgb_r' num2str(r) ' = temp;']);
end
cgb1 = cgb_r5; cgb2 = cgb_r10;  cgb3 = cgb_r20; 

