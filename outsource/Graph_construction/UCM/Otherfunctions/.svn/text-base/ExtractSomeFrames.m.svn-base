function ExtractSomeFrames()

%Streetwalking
video_file_name='C:\Users\Fabio\Desktop\tmp\Streetwalking.mp4';
first_frame=1; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 335
noFrames=10; %to 415
start_image_no=0; %coherent with Toyota sequence
output_filename_base='C:\Users\Fabio\Desktop\tmp\Streetwalking';


%canon_1_or-7
video_file_name='D:\Data\CrowdVideo\canon_1_or-7.avi';
first_frame=1; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 335
noFrames=50; %to 415
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\canon_1_or-7\canon17';



%static
video_file_name='D:\Data\CrowdVideo\EWC.avi';
first_frame=335; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 335
noFrames=81; %to 415
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\Frames_EWC_335to415tot81\EWCstc';


%moving
video_file_name='D:\Data\CrowdVideo\EWC.avi';
first_frame=1715; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 1715
noFrames=86; %to1800
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\Frames_EWC_1715to1800tot86\EWCmov';

%stc05
video_file_name='D:\Data\CrowdVideo\EWC_11022010\EWC005.avi';
first_frame=1724; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 1724
noFrames=117; %to1800
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\Frames_EWC05_1724to1840tot117\EWCstc05';

%mov06
video_file_name='D:\Data\CrowdVideo\EWC_11022010\EWC006.avi';
first_frame=1651; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 1651
noFrames=190; %to1800
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\Frames_EWC06_1651to1840tot190\EWCmov06';

%mov06mmp
video_file_name='D:\Data\CrowdVideo\EWC_11022010\EWC006.avi';
first_frame=3148; %this is counted from 1, so it corresponds to x-1 if counted from 0, actually for the sequence corresponds exactly to 3148
noFrames=150; %to3197
start_image_no=0; %coherent with Toyota sequence
output_filename_base='D:\Data\CrowdVideo\Frames_EWC06mmp_3148to3197tot150\EWCmov06mmp';

count=start_image_no;
for i=first_frame:(first_frame+noFrames-1)
    [outImages,filename]=Gettwoframes(video_file_name,i);
    if (size(outImages{1},1)==1)&&(size(outImages{1},2)==1)&&(outImages{1}==0) %if the matrix is a point
        fprintf('Could not load images\n');
        return;
    end
    tmpfilename=[output_filename_base,num2str(count,'%03d'),'.png'];
    imwrite(outImages{1},tmpfilename,'png')
    
    count=count+1;

end
count=count-1;

fprintf('Frames extracted\n');
