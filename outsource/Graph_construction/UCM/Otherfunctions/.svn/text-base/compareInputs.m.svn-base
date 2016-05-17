function compareInputs()

ucm2filename.basename='D:\Data\Toyota\sr_result_seq2\ucm2\srseq2-';
ucm2filename.number_format='%02d';
ucm2filename.closure='_ucm2.bmp';
ucm2filename.startNumber=0;

ucm2filenames.basename='D:\Data\Toyota\r_result_seq2\ucm2\rseq2-';
ucm2filenames.number_format='%02d';
ucm2filenames.closure='_ucm2.bmp';
ucm2filenames.startNumber=0;

noFrames=70;

%reads the segmented video frames
ucm2=cell(1,noFrames);
ucm2s=cell(1,noFrames);
count=0;
for i=ucm2filename.startNumber:(noFrames+ucm2filename.startNumber-1)
    count=count+1;
    ucm2_each_filename=[ucm2filename.basename,num2str(i,ucm2filename.number_format),ucm2filename.closure];
    ucm2_each_filenames=[ucm2filenames.basename,num2str(i,ucm2filenames.number_format),ucm2filenames.closure];
    if (~exist(ucm2_each_filename,'file'))
        fprintf('%s not found\n',ucm2_each_filename);
        continue;
    end
    ucm2{count}=imread(ucm2_each_filename);
    if (~exist(ucm2_each_filenames,'file'))
        fprintf('%s not found\n',ucm2_each_filenames);
        continue;
    end
    ucm2s{count}=imread(ucm2_each_filenames);
    if ( any(any( ucm2{count}~=ucm2s{count} )) )
        fprintf('Differences found between %s and %s\n',ucm2_each_filename,ucm2_each_filenames);
    end
end
