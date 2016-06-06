clear
baselinedir = './VSS/baseline_Segtrack';
%ourdir = 'chisq2d_chen_20_9_13_5_255_0';
setting = 'chisq2d_Segtrack_50_9_13_5_255_1';
ourdir=['./VSS/',setting];
lv =20;
d= dir('./VSS/');d(1:2) =[];
%for j=1:length(d)
    %if ~isempty(findstr(d(j).name, 'chen') )
     %   setting = d(j).name
        
        output = ['./Final/VSS_Segtrack/',num2str(lv),'/',setting];
        if ~exist(output,'dir')
            mkdir(output);
        end
        t1 = dir(baselinedir);t1(1:2) =[];
        t2 = dir(ourdir);t2(1:2) =[];
        
        %TextMask1 = RasterizeText('\mu = 2','Times New Roman',32);
        %TextMask2 = RasterizeText('\mu = 0.02','Times New Roman',32);

        TextMask{1}  = RasterizeText('baseline','Times New Roman',32);
        TextMask{2}  = RasterizeText('+our feature','Times New Roman',32);
        %TextMask{3}  = RasterizeText('µ = 2','Times New Roman',32);
        for i=1:length(t1)
            i
            n = t1(i).name;
            load(['./imgfile/',n]);
            v1 = load(fullfile(baselinedir,n));
            basesp = v1.allthesegmentations{lv};
            v2 = load(fullfile(ourdir,n));
            oursp = v2.allthesegmentations{lv};
            sp{1} = basesp;
            sp{2} = oursp;
            %sp{3} = oursp;
         %   video_from_segmetation_with_original_images(img,fullfile(output,n),basesp,oursp,TextMask1,TextMask2);
            video_from_segmetation_s(img,fullfile(output,n),sp,TextMask,0.6);
            
        end
   % end;
    
%end;