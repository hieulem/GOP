baselinedir = './PGP/chen/bl_400';
d= dir('./PGP/chen/');d(1:2) =[];
for j=1:length(d)
    if ~isempty(findstr(d(j).name, 'emd_400') )
        setting = d(j).name
        ourdir = ['./PGP/chen/',setting];
        % baselinedir = 'baseline_Segtrack';
        % ourdir = 'chisq2d_Segtrack_10_9_13_5_255_0';
        output = ['./PGP/visvideo5/chen/400/',setting];
        if ~exist(output,'dir')
            mkdir(output);
        else
            continue;
        end;
        t1 = dir(baselinedir);t1(1:2) =[];
        t2 = dir(ourdir);t2(1:2) =[];
        
        for i=1:length(t1)
            i
            n = t1(i).name;
            load(['./imgfile/',n]);
            v1 = load(fullfile(baselinedir,n));
            basesp = v1.thesegmentation;
            v2 = load(fullfile(ourdir,n));
            oursp = v2.thesegmentation;
            video_from_segmetation_with_original_images(img,fullfile(output,n),basesp,oursp,TextMask1,TextMask2);
            
        end
    end
end