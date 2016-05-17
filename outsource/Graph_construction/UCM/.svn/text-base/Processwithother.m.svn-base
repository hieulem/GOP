function [allthesegmentations,filename_sequence_basename_frames_or_video]=Processwithother(cim,filenames,options,...
    filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen,ucm2,flows)
%TODO: address outlier values

if (  (isfield(options,'vsmethod'))  &&  (~isempty(options.vsmethod))  &&  (strcmp(options.vsmethod,'bln'))  &&  ( (~exist('flows','var')) || (isempty(flows)) || (~exist('ucm2','var')) || (isempty(ucm2)) )  )
    error('Computation of bln and ucm2/flows\n');
end
if (  (isfield(options,'vsmethod'))  &&  (~isempty(options.vsmethod))  &&  ((strcmp(options.vsmethod,'dobho'))||(strcmp(options.vsmethod,'dob')))  &&  ( (~exist('ucm2','var')) || (isempty(ucm2)) )  )
    error('Computation of dob/dobho and ucm2\n');
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
noFrames=numel(cim);

if (strcmp(options.vsmethod,'swa'))
    imextension='png';
else
    imextension='ppm';
end



%Generate random string
if ( (any(strcmp(options.vsmethod,'gb'))) || (any(strcmp(options.vsmethod,'hgb'))) || (any(strcmp(options.vsmethod,'swa'))) || (any(strcmp(options.vsmethod,'dobho'))) || (any(strcmp(options.vsmethod,'dob'))) || (any(strcmp(options.vsmethod,'hgbs')))  )
    %Generate random string id
    rng('shuffle');
    % s = RandStream('mt19937ar','Seed','shuffle');
    % RandStream.setGlobalStream(s);
    randstr=num2str(fix(rand*100000)+1,'%06d');
end

%Write images, if required
if ( (any(strcmp(options.vsmethod,'gb'))) || (any(strcmp(options.vsmethod,'hgb'))) || (any(strcmp(options.vsmethod,'swa'))) || (any(strcmp(options.vsmethod,'hgbs'))) )
    %Write images to tmpfilenames in wrpimages in ppm format
    tmpprocessimagesthedir=[filenames.filename_directory,'wrpimages',filesep,'tmpin',randstr,filesep];
    mkdir(tmpprocessimagesthedir);
    allimagenames=cell(1,noFrames);
    for i=1:noFrames
        allimagenames{i}=[tmpprocessimagesthedir,num2str(i,'%05d'),['.',imextension]]; %,randstr
        imwrite(uint8(cim{i}), allimagenames{i}, imextension);
        unix(sprintf('convert %s %s', allimagenames{i}, allimagenames{i}));
    end

    %Outdir
    tmpprocessimagesthedirout=[filenames.filename_directory,'wrpimages',filesep,'tmpout',randstr,filesep];
    mkdir(tmpprocessimagesthedirout);
end



%Segment the video with one available methods
switch(options.vsmethod)
    
    
    case 'gb' %Feltenszwalb and Huttenlocher IJCV '04
        motionsegcommand=['UCM',filesep,'Auxfunctions',filesep,'Svx',filesep,'gbh'];

        system( ['chmod u+x ',motionsegcommand] );
        nlevels=0;
        system( [motionsegcommand,' 100 0 100 0.5 ',sprintf('%d %s %s', nlevels, tmpprocessimagesthedir(1:end-1), tmpprocessimagesthedirout(1:end-1))] ); %[status,result]=
        %100 0 100 0.5 0
        
        
    case 'hgb' %Grundmann et al. CVPR'10
        motionsegcommand=['UCM',filesep,'Auxfunctions',filesep,'Svx',filesep,'gbh'];

        system( ['chmod u+x ',motionsegcommand] );
        nlevels=40;
        system( [motionsegcommand,' 5 200 100 0.5 ',sprintf('%d %s %s', nlevels, tmpprocessimagesthedir(1:end-1), tmpprocessimagesthedirout(1:end-1))] ); %[status,result]=
        %5 200 100 0.5 20
        %5 500 200 0.5 20
        
        
    case 'hgbs' %Xu et al. ECCV'12
        motionsegcommand=['UCM',filesep,'Auxfunctions',filesep,'Svx',filesep,'gbh_stream'];

        system( ['chmod u+x ',motionsegcommand] );
        nlevels=40;
        twindow=10;
        system( [motionsegcommand,' 5 200 100 0.5 ',sprintf('%d %d %s %s', twindow, nlevels, tmpprocessimagesthedir(1:end-1), tmpprocessimagesthedirout(1:end-1))] ); %[status,result]=
        %5 200 100 0.5 10 20
        
        
    case {'sponz','spo','dobho'} %spo    Ochs and Brox CVPR '12 - nz assigns ignore value (<0) to other pixels (non sparse trajectories)
                                 %dobho  Ochs and Brox CVPR '12 densified with Ochs and Brox ICCV '11
        
        
        if (  ( (~isfield(filename_sequence_basename_frames_or_video,'otracksfile')) || (isempty(filename_sequence_basename_frames_or_video.otracksfile)) ||...
            (~exist(filename_sequence_basename_frames_or_video.otracksfile,'file')) )  &&  (~ispc)  )
        
            filename_sequence_basename_frames_or_video=Olongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim);
            
            if ( (~isfield(filename_sequence_basename_frames_or_video,'otracksfile')) || (isempty(filename_sequence_basename_frames_or_video.otracksfile)) ||...
                    (~exist(filename_sequence_basename_frames_or_video.otracksfile,'file')) )
                error('Computation of tracks with the algorithm of Ochs and Brox CVPR12'); 
            end
        end
        
        thetracksfile=filename_sequence_basename_frames_or_video.otracksfile;
        
        
    case {'spbnz','spb','dob'} %spb   Brox and Malik ECCV '10 - nz assigns ignore value (<0) to other pixels (non sparse trajectories)
                               %dob   Ochs and Brox ICCV'11
        if (  ( (~isfield(filename_sequence_basename_frames_or_video,'btracksfile')) || (isempty(filename_sequence_basename_frames_or_video.btracksfile)) ||...
                (~isfield(filename_sequence_basename_frames_or_video,'bflowdir')) || (isempty(filename_sequence_basename_frames_or_video.bflowdir)) ||...
            (~exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) || (~exist(filename_sequence_basename_frames_or_video.bflowdir,'dir')) )  &&  (~ispc)  ) %Flow files to be computed
        
            filename_sequence_basename_frames_or_video=Blongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim);
            %filename_sequence_basename_frames_or_video:
            %bdeffileorig, bdeffile, bdeffileframes, bdeffilenb, bdeffilenbf, btracksfile
            
            if ( (~isfield(filename_sequence_basename_frames_or_video,'btracksfile')) || (isempty(filename_sequence_basename_frames_or_video.btracksfile)) ||...
                    (~isfield(filename_sequence_basename_frames_or_video,'bflowdir')) || (isempty(filename_sequence_basename_frames_or_video.bflowdir)) ||...
                    (~exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) || (~exist(filename_sequence_basename_frames_or_video.bflowdir,'dir')) )
                error('Computation of flows with brox otpical flow algorithm'); 
            end
        end
        
        thetracksfile=filename_sequence_basename_frames_or_video.btracksfile;
        
        
    case 'swa' %Xu and Corso, CVPR '12
        firstlevel=10;
        lastlevel=15;
        fp=fopen([tmpprocessimagesthedir,'config.txt'],'w');
        fprintf(fp,'InputSequence=%s%%05d.png\n',tmpprocessimagesthedir);
        fprintf(fp,'Frames=%d-%d\n',noFrames,noFrames);
        fprintf(fp,'NumOfLayers=%d\n',lastlevel);
        fprintf(fp,'MaxStCubeSize=%d\n',noFrames);
        fprintf(fp,'VizLayer=%d-%d\n',firstlevel,lastlevel);
        fprintf(fp,'VizFileName=%s\n',tmpprocessimagesthedirout);
        fclose(fp);
        
        motionsegcommand=['UCM',filesep,'Auxfunctions',filesep,'Svx',filesep,'swa'];

        system( ['chmod u+x ',motionsegcommand] );
        system( [motionsegcommand,' ',sprintf('%s%s', tmpprocessimagesthedir, 'config.txt')] ); %[status,result]=
        %100 0 100 0.5 0

    case 'GTCase' %used for scoring human performance
        fprintf('GTCase\n');

    case 'onelabelvideo' %used for debugging and to read GT
        fprintf('One label video\n');
        
    case 'bln' %Baseline method, optical flow propagation of labels on the central frame
        fprintf('Baseline\n');
                
    otherwise
        error('Video segmentation method');
end



%Read output pictures
switch(options.vsmethod)
    case {'swa'} %Xu and Corso, CVPR '12

        nlevels=lastlevel-firstlevel+1;
        allthesegmentations=cell(1,nlevels);
        printonscreeninsidefunction=false;
        count=0;
        for i=firstlevel:lastlevel
            count=count+1;
            ofbasename=[tmpprocessimagesthedirout,num2str(i,'%02d'),filesep];
            ofnumber_format='%05d';
            ofstartNumber=1;
            ofclosure='.png';
            vsout=Readpictureseries(ofbasename,ofnumber_format,ofclosure,ofstartNumber,noFrames,printonscreeninsidefunction);
            if (printonscreeninsidefunction)
                Printthevideoonscreen(vsout,printonscreeninsidefunction,1); %#ok<UNRCH>
            end
            
            %Convert the color labels into labels
            vslabels=Convertcolorlabels(vsout,printonscreeninsidefunction);
            
            allthesegmentations{count}=Uintconv(vslabels);
            if (printonscreeninsidefunction)
                fprintf('Level %d number of labels %d\n',i,numel(unique(allthesegmentations{count}))); %#ok<UNRCH>
                Printthevideoonscreen(Doublebackconv(allthesegmentations{count}),printonscreeninsidefunction,1);
            end
        end
        for i=numel(allthesegmentations):-1:2
            if (isequal(allthesegmentations(i),allthesegmentations(i-1)))
                allthesegmentations(i)=[];
            end
        end
        allthesegmentations(1:numel(allthesegmentations))=allthesegmentations(numel(allthesegmentations):-1:1);
        
    case {'gb','hgb','hgbs'}

        allthesegmentations=cell(1,nlevels+1);
        printonscreeninsidefunction=false;
        for i=0:nlevels
            ofbasename=[tmpprocessimagesthedirout,num2str(i,'%02d'),filesep];
            ofnumber_format='%05d';
            ofstartNumber=1;
            ofclosure='.ppm';
            vsout=Readpictureseries(ofbasename,ofnumber_format,ofclosure,ofstartNumber,noFrames,printonscreeninsidefunction);
            if (printonscreeninsidefunction)
                Printthevideoonscreen(vsout,printonscreeninsidefunction,1); %#ok<UNRCH>
            end
            
            %Convert the color labels into labels
            vslabels=Convertcolorlabels(vsout,printonscreeninsidefunction);

            allthesegmentations{i+1}=Uintconv(vslabels);
            if (printonscreeninsidefunction)
                fprintf('Level %d number of labels %d\n',i,numel(unique(allthesegmentations{i+1}))); %#ok<UNRCH>
                Printthevideoonscreen(Doublebackconv(allthesegmentations{i+1}),printonscreeninsidefunction,1);
            end
        end
        for i=numel(allthesegmentations):-1:2
            if (isequal(allthesegmentations(i),allthesegmentations(i-1)))
                allthesegmentations(i)=[];
            end
        end
        allthesegmentations(1:numel(allthesegmentations))=allthesegmentations(numel(allthesegmentations):-1:1);
        
    case {'spbnz','spb','sponz','spo'} %spb    Brox and Malik ECCV '10 - nz assigns ignore value (<0) to other pixels (non sparse trajectories)
                                       %spo    Ochs and Brox CVPR '12 - nz assigns ignore value (<0) to other pixels (non sparse trajectories)
                
        [btrajectories,noblabels]=Readbroxtrajectories(thetracksfile); %#ok<NASGU>
        if (isempty(btrajectories))
            error('Error loading b trajectories');
        end
        
        %some labels may be empty
        videosize=[size(cim{1},1), size(cim{1},2), noFrames];
        if ( (strcmp(options.vsmethod,'spo')) || (strcmp(options.vsmethod,'spb')) )
            allthesegmentations{1}=Uintconv(Labelbvideo(btrajectories,videosize,printonscreen,0)); %0 labels mean other, included in the computation
        else
            allthesegmentations{1}=Uintconv(Labelbvideo(btrajectories,videosize,printonscreen,-10)); %<0 labels mean ignore, neglected in computation
        end
        
        
    case {'dobho','dob'} %dobho   Ochs and Brox CVPR '12 densified with Ochs and Brox ICCV '11
                         %dob     Ochs and Brox ICCV'11
                         %thetracksfile is used to discriminate between dob and dobho
                
        tmpprocessimagesthedir=[filenames.filename_directory,'wrpimages',filesep];
        tmpbaseimage=['tmp_',randstr,'_dob'];
        tmptheimage=[tmpprocessimagesthedir,tmpbaseimage]; tmptheimagepe=[tmptheimage,'.',imextension];
        
        trackimgcommand=['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
            filesep,'Dense',filesep,'conv_Track2Img'];
        system( ['chmod u+x ',trackimgcommand] );
        motionsegcommand=['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
            filesep,'Dense',filesep,'dens100'];
        system( ['chmod u+x ',motionsegcommand] );
        
        levels=[0.05,0.10,0.15];
        nlevels=numel(levels);
        vsout=cell(1,numel(cim));
        for i=1:numel(cim)
            imwrite(uint8(cim{1}), tmptheimagepe, imextension);
        
            num=i-1; %Index in Ochs's code are from 0
            system( [trackimgcommand,' ',sprintf('%s %s %d', tmptheimagepe, thetracksfile, num)] ); %Extract the labels from the track file
            
            %Convert superpixels to piecewise constant images
            for j=1:nlevels
                thelevel=levels(j);
                
                kkk=thelevel*255; %thelevel ranges [0,1], kkk ranges [0,255], with 0 all superpixels, 255 the whole frame
            
                labels2 = bwlabel(ucm2{i} <= kkk); labels = labels2(2:2:end, 2:2:end);
%                 Init_figure_no(1), imagesc(labels); disp(numel(unique(labels)));
                m = max(max(labels)); d = floor(32768/m);
                A(:,:,1) = labels*d; A(:,:,2) = labels*d; A(:,:,3) = labels*d;
                A(:,:,1) = floor(A(:,:,1) / (32*32)); A(:,:,2) = mod(A(:,:,2), 32*32);
                A(:,:,2) = floor(A(:,:,2) / 32); A(:,:,3) = mod(A(:,:,3), 32); A = A * 8;
                imwrite(uint8(A),sprintf('%s_seg%d.%s',tmptheimage,j-1,imextension)); % Init_figure_no(1), imagesc(uint8(A));
            end
            
            labelsimage=sprintf('%s_labels%04d.ppm',tmpbaseimage,num);
            system( [motionsegcommand,' ',sprintf('%s %d %s', tmptheimagepe, nlevels, labelsimage)] );
            
            %Read the output image
            vsout{i}=imread([tmpprocessimagesthedir,'OchsBroxResults',filesep,tmpbaseimage,'_dense.ppm']);
            
            %Delete tmp files
            delete([tmpprocessimagesthedir,labelsimage]);
        end
%         Printthevideoonscreen(vsout,true,1,false,false,false,false); %(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext)
        
        %Delete tmp directory
        for j=1:nlevels, delete(sprintf('%s_seg%d.%s',tmptheimage,j-1,imextension)); end
        delete(tmptheimagepe);
        %Delete tmp files in OchsBroxResults directory
        delete([tmpprocessimagesthedir,'OchsBroxResults',filesep,tmpbaseimage,'_dense.ppm']);
        delete([tmpprocessimagesthedir,'OchsBroxResults',filesep,tmpbaseimage,'_dense_soft.ppm']);
        delete([tmpprocessimagesthedir,'OchsBroxResults',filesep,tmpbaseimage,'_initialLabels.ppm']);
%         rmdir([tmpprocessimagesthedir,'OchsBroxResults',filesep],'s'); %This directory is left, just in case of concurrently computation of dob and dobho

        %Convert the color labels into labels
        printonscreeninsidefunction=false;
        vslabels=Convertcolorlabels(vsout,printonscreeninsidefunction);
        
        allthesegmentations=cell(1,1);
        allthesegmentations{1}=Uintconv(vslabels);
        if (printonscreeninsidefunction)
            fprintf('Number of labels %d\n',numel(unique(allthesegmentations{1}))); %#ok<UNRCH>
            Printthevideoonscreen(Doublebackconv(allthesegmentations{1}),printonscreeninsidefunction,1);
        end
        

    case 'GTCase'
        
        printonscreeninsidefunction=false;
        ntoreadmgt=Inf; %1, 2, .. Inf number of gts to read
        maxgtframes=Inf; %Limit max frame for gt (impose same test set)
        [labelledgtvideo,nonemptygt]=Getmultgtlabvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,ntoreadmgt,maxgtframes,printonscreeninsidefunction); %,numberofobjects,numbernonempty
        %labelledgtvideo{ which gt annotation , which frame } = dimIi x dimIj double (the labels, 0 others, -1 neglect)
        if (printonscreeninsidefunction)
            for mid=1:size(labelledgtvideo,1)
                Printthevideoonscreen(labelledgtvideo(mid,:), printonscreeninsidefunction, 10, false, true,[],[]);
            end
        end
        
        if (  (isfield(options,'GTNum'))  &&  (~isempty(options.GTNum))  )
            GTNum=options.GTNum;
        else
            GTNum=1;
        end
        
        if (GTNum>size(labelledgtvideo,1))
            error('Requested non existent GT');
        end

        %Copy the valid frames into the appropriate output or include -1 to not consider the frames
        thevideo=zeros(size(cim{1},1) , size(cim{1},2) , noFrames);
        for f=1:noFrames
            if (nonemptygt(GTNum,f))
                thevideo(:,:,f)=labelledgtvideo{GTNum,f};
            else
                thevideo(:,:,f)=ones( size(cim{1},1) , size(cim{1},2) ).*-1;
            end
        end
        allthesegmentations{1}=Uintconv(  thevideo  );
        

    case 'onelabelvideo' %used for debugging and to read GT
        
        allthesegmentations=cell(1);
        allthesegmentations{1}=Uintconv(  ones( size(cim{1},1) , size(cim{1},2) , noFrames )  );

    case 'bln'
        
        if (  (isfield(options,'blnnlev'))  &&  (~isempty(options.blnnlev))  )
            blnnlev=options.blnnlev;
        else
            blnnlev=51;
        end
        if (  (isfield(options,'blnthr'))  &&  (~isempty(options.blnthr))  )
            blnthr=options.blnthr;
        else
            blnthr=0.1;
        end
        if (  (isfield(options,'blnstflow'))  &&  (~isempty(options.blnstflow))  &&  (options.blnstflow)  )
            %tmpflows is null
            [XX,YY]=meshgrid(1:size(flows.flows{1}.Up,2),1:size(flows.flows{1}.Up,1));
            tmpflows=flows;
            for i=1:numel(flows.flows)
                tmpflows.flows{i}.Vp=YY;
                tmpflows.flows{i}.Up=XX;
                tmpflows.flows{i}.Vm=YY;
                tmpflows.flows{i}.Um=XX;
            end
        else
            tmpflows=flows;
        end
        if (  (isfield(options,'blnraf'))  &&  (~isempty(options.blnraf))  )
            blnraf=options.blnraf; %Re-initialize at each frame
        else
            blnraf=false;
        end
        
        
        allthesegmentations=Computelabelpropagateis(cim,ucm2,tmpflows,blnnlev,blnthr,blnraf,printonscreen); %[allthesegmentations,propagated]

        allthesegmentations(1:numel(allthesegmentations))=allthesegmentations(numel(allthesegmentations):-1:1); %Re-order so lower indices indicate segmentations with fewer clusters

        
%Not needed, this is checked above
%     otherwise
%         error('Video segmentation method');
end



%Clear all temporary files, if created
if ( (any(strcmp(options.vsmethod,'gb'))) || (any(strcmp(options.vsmethod,'hgb'))) || (any(strcmp(options.vsmethod,'swa'))) || (any(strcmp(options.vsmethod,'hgbs'))) )
    rmdir(tmpprocessimagesthedir,'s');
    rmdir(tmpprocessimagesthedirout,'s');
end



%filename_sequence_basename_frames_or_video is modified regarding btracksfile and bflowdir


