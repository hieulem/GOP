function Rewritesegmforbenchmark(filenames,filename_sequence_basename_frames_or_video,videocorrectionparameters)

% casenamescl={'Carsone','Carstwo','Carsthree','Carsfour','Carsfive','Carssix','Carsseven','Carseight','Carsnine','Carsten',...
%     'Marpleone','Marpletwo','Marplethree','Marplefour','Marplefive','Marplesix','Marpleseven','Marpleeight','Marplenine','Marpleten',...
%     'Marpleeleven','Marpletwelve','Marplethirteen','Peopleone','Peopletwo','Tennis'};
% casenames={'carsone','carstwo','carsthree','carsfour','carsfive','carssix','carsseven','carseight','carsnine','carsten',...
%     'marpleone','marpletwo','marplethree','marplefour','marplefive','marplesix','marpleseven','marpleeight','marplenine','marpleten',...
%     'marpleeleven','marpletwelve','marplethirteen','peopleone','peopletwo','tennis'};

tmpoptions=struct();
tmpoptions.newsegname='Plzhoupoptnrmff20toallalp0d95ovall'; %Use the Berkeley benchmark for the superposed video segmentations
% tmpoptions.newsegname='TMP4segmcfallpoptnrm'; %Use the Berkeley benchmark for the superposed video segmentations


load(filenames.filename_colour_images);

allthesegmentations=Loadallsegs(filenames,tmpoptions);

%Run benchmark code from Berkeley on the newucm2: add images to the directory
ucmtwolength=size(allthesegmentations{1},3);
for i=1:numel(allthesegmentations)
    if ( size(allthesegmentations{i},3) ~= ucmtwolength ), ucmtwolength=max(ucmtwolength,size(allthesegmentations{i},3)); fprintf('\n\n\nLevel %d allthesegmentations with different length\n\n\n\n\n',i); end
end
newucm2=cell(1,ucmtwolength);
additionalmasname=tmpoptions.newsegname;
maxgtframes=Inf; %used to restrict gt frames (impose same test set)
minframes=min([numel(cim), numel(newucm2), maxgtframes]);
printonscreen=false;
Addcurrentimageforrpmultgt(cim(1:minframes),newucm2(1:minframes),filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen,allthesegmentations);
    %When allthesegmentations is passed newucm2 is not used




function Run_this()

casenamescl={'Carsone','Carstwo','Carsthree','Carsfour','Carsfive','Carssix','Carsseven','Carseight','Carsnine','Carsten',...
    'Marpleone','Marpletwo','Marplethree','Marplefour','Marplefive','Marplesix','Marpleseven','Marpleeight','Marplenine','Marpleten',...
    'Marpleeleven','Marpletwelve','Marplethirteen','Peopleone','Peopletwo','Tennis'};

for i=1:numel(casenamescl)

    UCM(casenamescl{i});
    
end

%10: 'Marplenine','Marpleeleven',
%20: 'Marplenine',