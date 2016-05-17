function Rewriteimages(filenames,filename_sequence_basename_frames_or_video,noFrames)

copydestfolder='/BS/galassoandfriends/work/BVDS/Videos/Test/';

basename=filename_sequence_basename_frames_or_video.basename;
numberformat=filename_sequence_basename_frames_or_video.number_format;
nameclosure=filename_sequence_basename_frames_or_video.closure;
startnumber=filename_sequence_basename_frames_or_video.startNumber;

picture_dest_folder=[copydestfolder,filenames.casedirname,filesep];
mkdir(picture_dest_folder);

count=0;
numberofmissing=[];
for i=startnumber:(noFrames+startnumber-1)
    count=count+1;
    picture_each_filename=[basename,num2str(i,numberformat),nameclosure];
    
    if (~exist(picture_each_filename,'file'))
%         fprintf('File %s missing\n',picture_each_filename);
        numberofmissing=[numberofmissing,num2str(i,numberformat),', ']; %#ok<AGROW>
        continue;
    end
    
    picture_dest_name=[picture_dest_folder,filenames.casedirname,num2str(count,'%d'),nameclosure];

    notdone=true;
    while (notdone)
        try
            copyfile(picture_each_filename,picture_dest_name,'f');
            notdone=false;
        catch ME %#ok<NASGU>
            fprintf('*');
            pause(1);
        end
    end
    
end

if (~isempty(numberofmissing))
    picture_each_filename=[basename,num2str(0,numberformat),nameclosure];
    fprintf('Missing files with format: %s\n',picture_each_filename);
    fprintf('Relative file numbers: %s\n',numberofmissing(1:end-2));
end




function Run_this()

% casenamescl={...
%     'alec_baldwin','anteater','avalanche','big_wheel','bowling','campanile','car_jump',...
%     'chrome','deoksugung','dominoes','drone','excavator','floorhockey','galapagos','gray_squirrel',...
%     'guitar','hippo_fight','horse_riding','juggling','kia_commercial','knot','lion','liontwo',...
%     'lukla_airport','pouring_tea','rock_climbing_tr','roller_coaster','rolling_pin','sailing','sea_snake','sea_turtle',...
%     'sitting_dog','snow_shoes','soccer','space_shuttle','swing','tarantula','tennis_tr','trampoline','zoo',...
%     }; %disp(numel(casenamescl));
casenamescl={...
    'airplane','angkor_wat','animal_chase','arctic_kayak','ballet','baseball','beach_volleyball',...
    'belly_dancing','beyonce','bicycle_race','birds_of_paradise','buck','buffalos','capoeira','chameleons',...
    ...
    'fisheye','fish_underwater','freight_train','frozen_lake','gokart','harley_davidson','hockey','hockey_goals',...
    'horse_gate','hummingbird','humpback','jungle_cat','kangaroo_fighting','kim_yu_na','koala','monkeys_behind_fence',...
    'nba_commercial','new_york','nordic_skiing','octopus','palm_tree','panda','panda_cub','penguins','pepsis_wasps',...
    'planet_earth_one','planet_earth_two','riverboat','rock_climbing','rock_climbingtwo','salsa','samba_kids','shark_attack',...
    'sled_dog_race','slow_polo','snow_leopards','snowboarding','snowboarding_crashes','street_food','swimming','up_dug',...
    'up_trailer','vw_commercial','white_tiger','yosemite',...
    }; %disp(numel(casenamescl));

% casenamescl={'Carsone','Carstwo','Carsthree','Carsfour','Carsfive','Carssix','Carsseven','Carseight','Carsnine','Carsten',...
%     'Marpleone','Marpletwo','Marplethree','Marplefour','Marplefive','Marplesix','Marpleseven','Marpleeight','Marplenine','Marpleten',...
%     'Marpleeleven','Marpletwelve','Marplethirteen','Peopleone','Peopletwo','Tennis'};

for i=1:numel(casenamescl)

    FSSscriptwhole(casenamescl{i});
    
end


