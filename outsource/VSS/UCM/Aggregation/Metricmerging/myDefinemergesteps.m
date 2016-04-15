function mergesteps=myDefinemergesteps(setclustermethod)

%merge proceeds from mergesteps(i)+1 to mergesteps(i+1) (extrema included) with 1<=i<=(numberofclusterings)

switch (setclustermethod)
    
        
    case 'adhoc'
        
        %These are the number of clusters specified for k-means, not merging steps
       % mergesteps=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,40,50,60,70,80,100,150,200,250,300,350,400,500,600];
        mergesteps=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
       % mergesteps = [20,50];
    otherwise
        
        mergesteps=[];
end


fprintf('setclustermethod %s:',setclustermethod); fprintf(' %g',mergesteps); fprintf('\n');

