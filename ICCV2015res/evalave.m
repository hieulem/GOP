clear;
dts = 'Segtrack';
d =dir(dts);

for i=1:length(d)
    d(i).name
    if d(i).isdir ==0
      
        load(fullfile(dts,d(i).name));
        avglen = avglen_one_lv(thesegmentation);
        save(fullfile(dts,d(i).name),'thesegmentation','s','nvx','avglen');
    end
    
end

clear
    
dts = 'chen';
d =dir(dts);

for i=1:length(d)
    d(i).name
    if d(i).isdir ==0
      
        load(fullfile(dts,d(i).name));
        avglen = avglen_one_lv(thesegmentation);
        save(fullfile(dts,d(i).name),'thesegmentation','s','nvx','avglen');
    end
    
end
    