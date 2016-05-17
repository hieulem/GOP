function [result,averages]=Readsvs()
% Readsvs();

filename='SVStmp.m'; %'SVS_work.m', 'UCM_work.m', 'UCMtmp.m', 'SVStmp.m'
casetosearch='hal'; %'mergeDfd3gd3', 'h', 'mergeMfd3', 'mergeDfd3', 'w', 'wmergeDfd3'
numberstoread=4; %4 or 7

fid = fopen(filename);

result=struct;
nocases=0;
currentcase=''; %this should never be used
while (true)
    
    tline = fgetl(fid);
    
    if ( (numel(tline)==1) && (tline==-1) )
%         fprintf('End of file reached\n');
        break;
    end
    
    if ( (numel(tline)<=0) || (~strcmp(tline(1),'%')) )
        continue;
    end
    
    if ( (numel(tline)>=3) && (strcmp(tline(1:3),'%%%')) ) %three % denote a new case name
        currentcase=tline(4:end);
%         fprintf('%s ',currentcase);
        continue;
    end
    
    wherespaces=findstr(tline,' ');
    
    if ( (isempty(wherespaces)) || (~strcmp(tline(2:(wherespaces(1)-1)),casetosearch)) )
        continue;
    end
    
    nocases=nocases+1;
    result.case{nocases}=currentcase;
    
    startpos=wherespaces(1);
    for i=1:numberstoread
        
        [anumber,startpos]=Findnextnumber(tline,startpos,' ');
        if (isempty(anumber))
            fprintf('Reading interrupted\n');
            break;
        else
            result.numbers(nocases,i)=anumber;
        end
        
    end
        
end
fclose(fid);

fprintf('Case %s, no cases found %d\n',casetosearch,nocases);


averages=mean(result.numbers,1);

disp(averages)


%Density (in percent)
%Overall (per pixel) clustering error (in percent)
%Average (per region) clustering error (in percent)
%Number of clusters merged
%Regions with less than 10%

%Region tracks   79.0786   5.1380   26.0074   0.9615   1.0000
%Brox tracks      3.3179   4.2634   25.4081   1.0385   1.0769

%[result,averages]=Readbmetrics(basedrive);
% Marpletwo: 83.037100 10.887500 51.317300 0.000000 1.000000
% Marplefive: 94.751300 6.175910 39.342500 0.000000 0.000000
% Marplethirteen: 82.476000 8.602440 37.592400 1.000000 1.000000
% Carsfour: 76.792000 0.764178 2.661590 0.000000 2.000000
% Marpleone: 70.846500 2.558950 2.433980 4.000000 1.000000
% Marplethree: 79.632900 1.492290 1.575340 4.000000 1.000000
% Marplefour: 91.252000 13.304100 9.646160 0.000000 0.000000
% Marplesix: 93.145600 22.675300 66.666700 0.000000 0.000000
% Marpleseven: 81.695700 4.531230 3.249340 2.000000 2.000000
% Marpleeight: 83.221600 7.040520 11.968400 2.000000 1.000000
% Marplenine: 89.469800 3.059390 3.639390 2.000000 2.000000
% Marpleten: 88.739200 2.951460 34.175300 0.000000 1.000000
% Marpleeleven: 91.153400 2.037380 26.969500 2.000000 0.000000
% Marpletwelve: 82.262900 6.664110 54.582700 0.000000 0.000000
% Tennis: 66.476200 7.247190 75.000000 1.000000 0.000000
% Peopleone: 77.562800 0.553147 9.144990 1.000000 0.000000
% Peopletwo: 77.164600 0.856678 11.831000 2.000000 1.000000
% Carsone: 64.273900 4.154310 3.353040 3.000000 2.000000
% Carstwo: 79.100300 3.217080 51.692700 0.000000 2.000000
% Carsthree: 72.969700 1.441060 1.226650 0.000000 2.000000
% Carsfive: 77.880000 3.697470 50.654900 0.000000 1.000000
% Carssix: 85.468600 0.838477 2.319830 0.000000 1.000000
% Carsseven: 75.407300 1.138920 1.547300 0.000000 1.000000
% Carseight: 59.747000 4.176320 35.167600 0.000000 1.000000
% Carsnine: 69.271400 7.764170 60.684400 0.000000 1.000000
% Carsten: 62.246700 5.757440 27.749000 1.000000 2.000000
% Cases 26, averages:   79.0786    5.1380   26.0074    0.9615    1.0000
% Marpletwo: 2.650370 6.570420 51.568900 0.000000 1.000000
% Marplefive: 2.398670 3.119650 36.922100 0.000000 1.000000
% Marplethirteen: 2.032380 7.458280 40.813100 1.000000 1.000000
% Carsfour: 3.351020 1.119650 9.521160 0.000000 1.000000
% Marpleone: 3.344100 1.703460 1.530160 4.000000 1.000000
% Marplethree: 3.734130 1.396640 1.365660 5.000000 1.000000
% Marplefour: 3.406150 3.064020 3.307040 0.000000 1.000000
% Marplesix: 4.101050 24.446200 66.666700 0.000000 0.000000
% Marpleseven: 3.802180 3.056890 2.351620 2.000000 2.000000
% Marpleeight: 3.603540 5.634690 10.135800 2.000000 1.000000
% Marplenine: 4.691970 2.576840 3.211270 2.000000 2.000000
% Marpleten: 4.034830 1.853250 33.613600 0.000000 1.000000
% Marpleeleven: 3.466300 1.894490 27.463000 2.000000 0.000000
% Marpletwelve: 2.496960 9.782410 54.186000 0.000000 0.000000
% Tennis: 2.338200 9.632640 75.000000 0.000000 0.000000
% Peopleone: 4.493680 0.302789 3.540350 1.000000 1.000000
% Peopletwo: 3.441240 0.860805 11.983000 2.000000 1.000000
% Carsone: 3.127060 1.966690 1.947150 3.000000 2.000000
% Carstwo: 3.680660 3.724990 51.254100 0.000000 2.000000
% Carsthree: 3.568790 1.061080 0.610717 0.000000 2.000000
% Carsfive: 3.511560 3.568020 50.313000 0.000000 1.000000
% Carssix: 2.972010 0.424344 0.220477 0.000000 1.000000
% Carsseven: 3.140300 0.701306 1.413720 0.000000 1.000000
% Carseight: 2.552520 2.690180 34.173200 2.000000 1.000000
% Carsnine: 2.972520 7.959810 60.532900 0.000000 1.000000
% Carsten: 3.352540 4.277860 26.965400 1.000000 2.000000
% Cases 26, averages:    3.3179    4.2634   25.4081    1.0385    1.0769





%precision   recall   averageprecision(precision per object is averaged) averagerecall(precision per object is averaged)


%BVDS dataset (26 seqs, people and objects)
%
% Case wmergeDfd3al, no cases found 26
%     0.9665    0.7260    0.9129    0.6422
%
% Case hal, no cases found 26
%     0.9685    0.6331    0.9242    0.5534


%BVDS dataset (16 seqs, just people)
% 
% Case wmergeDfd3, no cases found 16
%     0.9507    0.7610    0.9506    0.7526
% 
% Case h, no cases found 16
%     0.9601    0.6583    0.9597    0.6500


%Panasonic dataset (15 seqs, only people)
%
% Case wmergeDfd3, no cases found 15
%     0.8984    0.7337    0.8565    0.7708
%
% Case h, no cases found 15
%     0.9019    0.7569    0.8614    0.7510



















%all iccv (marple+tennis+people+panasonic just people, background neglected)
% [result,averages]=Readsvs();
% 
% Case mergeDfd3, no cases found 31
%     0.9265    0.7272    0.9079    0.7416
% 
% Case mergeDfd3gd3, no cases found 31
%     0.9272    0.7229    0.9083    0.7371
% 
% Case mergeMfd3, no cases found 31
%     0.9143    0.7120    0.9024    0.7193
% 
% Case h, no cases found 31
%     0.9319    0.7060    0.9121    0.6989
% 
% Case w, no cases found 31
%     0.9312    0.7371    0.9119    0.7330
%
% Case wmergeDfd3, no cases found 31
%     0.9254    0.7478    0.9051    0.7614



%all iccv(marple+tennis+people+panasonic just people) + carsfour(review which objects) (background neglected)
%
% [result,averages]=Readsvs();
% 
% Case mergeDfd3, no cases found 32
%     0.9253    0.7304    0.9072    0.7442
% 
% Case mergeDfd3gd3, no cases found 32
%     0.9278    0.7211    0.9088    0.7357
% 
% Case h, no cases found 32
%     0.9315    0.7055    0.9129    0.7001
% 
% Case mergeMfd3, no cases found 32
%     0.9158    0.7024    0.9043    0.7095
% 
% Case w, no cases found 32
%     0.9303    0.7349    0.9118    0.7342
%
% Case wmergeDfd3, no cases found 32
%     0.9253    0.7486    0.9056    0.7618



%Marple 1 to 13 (just people, background neglected)
% Case w, no cases found 13
%     0.9576    0.7164    0.9575    0.7155
% 
% Case mergeDfd3gd3, no cases found 13
%     0.9489    0.7514    0.9489    0.7512
% 
% Case h, no cases found 13
%     0.9583    0.6497    0.9582    0.6487
% 
% Case mergeMfd3, no cases found 13
%     0.9463    0.7353    0.9463    0.7342
% 
% Case mergeDfd3, no cases found 13
%     0.9484    0.7565    0.9483    0.7562
% 
% Case wmergeDfd3, no cases found 13
%     0.9478    0.7782    0.9478    0.7777
