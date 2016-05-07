clear
k=100;
dts = 'Segtrack';

s1 =['bl_',num2str(k)];
s2 =['emd2d_',num2str(k),'_100_9_13_5_255_1_'];
d =dir(dts);
n=[];n2=[];
st =[];st2=[];
for i=1:length(d)
    if findstr(d(i).name,s1) ==1
        load(fullfile(dts,d(i).name));
        st=[st;s];
        n =[n;nvx];
    end
    if findstr(d(i).name,s2) ==1
        load(fullfile(dts,d(i).name));
        st2=[st2;s];
        n2 =[n2;nvx];
    end
    
end
    
ss = [st,st2]
nn =[n,n2]
st-st2