function Comparedircontents(dir1,dir2)

if ( (~exist('dir1','var')) || (isempty(dir1)) )
    dir1='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdscfsegimagemahis/Images_all';
end
if ( (~exist('dir2','var')) || (isempty(dir2)) )
    %Video
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfallpoptnrm/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherhgbs/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherhgbsmallnew/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherswanew/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherdob/Images_all'; %Half size
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherspbhalf/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherspbnzhalf/Images_all';
    %Image
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdscfsegimagehis/Images_all';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdscfsegimagemahis/Images_all';
    
    
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfothergb/Images'; %*IS full size
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherswa/Images'; %complete
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherspb/Images';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherspbnz/Images';
    
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherhgbsmall/Images'; %complete
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherhgbthirty/Images'; %30 levels in HGB
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherhgb/Images';
    
    %TMP directories
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherolv/Images';
    dir2='/BS/galassoandfriends/work/VideoProcessingTemp/Shared/Benchmark/Bvdssegmfotherolvhalf/Images';
end
% dir1='/BS/galasso_proj_spx/work/VideoProcessingTemp/Shared/Benchmark/Mhcompsumpoptnrmspxtracksff50mrmev1d1sel/Images';
% dir2='/BS/galasso_proj_spx/work/VideoProcessingTemp/Shared/Benchmark/Mhcompsumpoptnrmspxtracksff50mrmev1d2sel/Images';


%Read directory listings
iids1 = dir(fullfile(dir1,'*'));
iids2 = dir(fullfile(dir2,'*'));



%Put the listing names into cell arrays formats
iids1listing=cell(1,numel(iids1));
for i=1:numel(iids1)
    iids1listing{i}=iids1(i).name;
end

iids2listing=cell(1,numel(iids2));
for i=1:numel(iids2)
    iids2listing{i}=iids2(i).name;
end



%Returns the values in iids1listing which are not in iids2listing
fprintf('In dir1, not in dir2\n');
C=setdiff(iids1listing,iids2listing);
for i=1:numel(C)
    fprintf('%s ',C{i});
    if (mod(i,5)==0), fprintf('\n'); end
end
fprintf('\n');

%Returns the values in iids2listing which are not in iids1listing
fprintf('In dir2, not in dir1\n');
C=setdiff(iids2listing,iids1listing);
for i=1:numel(C)
    fprintf('%s ',C{i});
    if (mod(i,5)==0), fprintf('\n'); end
end
fprintf('\n');
