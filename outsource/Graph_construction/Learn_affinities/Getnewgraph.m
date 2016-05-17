function similarities = Getnewgraph(STT,LTT,ABA,ABM,STM,STA,STM3,STA3,SD,STT_max,STT_mean,Dspx,CTR,noallsuperpixels,framebelong, options,softdecision,map)
  
%% get features for RF    
  timetic=tic;
  [Xw_1,Xw_2, Xa1_1,Xa1_2, Xa2, Xa_2, indw_1,indw_2, inda1_1,inda1_2, inda2, inda_2]= getFeatures_test_new(STT,LTT,ABA,ABM,STM,STA,STM3,STA3,SD,STT_max,STT_mean,Dspx,CTR,noallsuperpixels,framebelong, options);
  fprintf('Mex features cpp friendly %f\n',toc(timetic));
 
clear STT LTT ABA ABM STM STA CTR SD STM3 STA3 STT_max STT_mean Dspx

index =[];
score_values = [];
if options.within &&(~isempty(indw_1))  

type = 'within_n1';
timetic=tic;
Tw = getconstraints_new(Xw_1,type,options.wthreshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));

index = [index; indw_1];
score_values = [score_values; double(Tw)];
clear Tw Xw_1 indw_1
type = 'within_n2';
timetic=tic;
Tw = getconstraints_new(Xw_2,type,options.wthreshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));

index = [index; indw_2];
score_values = [score_values; double(Tw)];

clear Tw Xw_2 indw_2
end

if options.across_2&&(~isempty(inda_2))     
type = 'across_>2';
timetic=tic;
Ta_2 = getconstraints_new(Xa_2,type,options.a_2threshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));
    index = [index; inda_2];
    score_values = [score_values; double(Ta_2)];
clear Ta_2 Xa_2 inda_2
end

if options.across2&&(~isempty(inda2))   
type = 'across_2';
timetic=tic;
Ta2 = getconstraints_new(Xa2,type,options.a2threshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));
    index = [index; inda2];
    score_values = [score_values; double(Ta2)];
clear Ta2 Xa2 inda2
end

if options.across1&&(~isempty(inda1_1))   
    
type = 'across_1_n1'; 
timetic=tic;
Ta1 = getconstraints_new(Xa1_1,type,options.a1threshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));
    index = [index; inda1_1];
    score_values = [score_values; double(Ta1)];
clear Ta1 Xa1_1 inda1_1

type = 'across_1_n2'; 
timetic=tic;
Ta1 = getconstraints_new(Xa1_2,type,options.a1threshold,map);
fprintf(['RF ',type,': %f\n'],toc(timetic));
    index = [index; inda1_2];
    score_values = [score_values; double(Ta1)];
clear Ta1 Xa1_2 inda1_2

end

[ii, jj] = ind2sub4up(index);  
clear index
iii = [ii;jj];
jjj = [jj;ii];
similarities = sparse(iii,jjj,[score_values;score_values],noallsuperpixels,noallsuperpixels);

clear ii jj iii jjj score_values

end

