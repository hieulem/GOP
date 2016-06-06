
baselinedir = './PGP/chen/bl_100';
%setting = 'emd2d_100_100_9_13_5_255_0';
d= dir('./PGP/chen/');d(1:2) =[];
for j=1:length(d)
    if ~isempty(findstr(d(j).name, 'emd_100') )
        setting = d(j).name
        ourdir = ['./PGP/chen/',setting];
        % baselinedir = 'baseline_Segtrack';
        % ourdir = 'chisq2d_Segtrack_10_9_13_5_255_0';
        output = ['./Final/PGP/chen/100/',setting];
        if ~exist(output,'dir')
            mkdir(output);
        else
            continue;
        end;
        t1 = dir(baselinedir);t1(1:2) =[];
        t2 = dir(ourdir);t2(1:2) =[];
        if length(t2)~=length(t1)
            continue;
        end;
        for i=1:14
            i
            n = t1(i).name;
            load(['./imgfile/',n]);
            v1 = load(fullfile(baselinedir,n));
            basesp = v1.thesegmentation;
            v2 = load(fullfile(ourdir,n));
            oursp = v2.thesegmentation;
            
            sp{1} = basesp;
            sp{2} = oursp;
            
            
            
            video_from_segmetation_s(img,fullfile(output,n),sp,TextMask,0.6);
            
        end
    end
end

% ourdir = ['./PGP/Segtrack/',setting];
% % baselinedir = 'baseline_Segtrack';
% % ourdir = 'chisq2d_Segtrack_10_9_13_5_255_0';
% output = ['./PGP/visvideo/Segtrack/',setting];
% if ~exist(output,'dir')
%     mkdir(output);
% else
%     return;
% end;
% t1 = dir(baselinedir);t1(1:2) =[];
% t2 = dir(ourdir);t2(1:2) =[];
%
% for i=1:length(t1)
%     i
%     n = t1(i).name;
%     v1 = load(fullfile(baselinedir,n));
%     basesp = v1.thesegmentation;
%     v2 = load(fullfile(ourdir,n));
%     oursp = v2.thesegmentation;
%     video_from_segmetation(fullfile(output,n),basesp,oursp);
%
% end