function Computebm(filenames,additionalbname,requestdelconf)

if ( (~exist('requestdelconf','var')) || (isempty(requestdelconf)) )
    requestdelconf=true;
end
if ( (~exist('additionalbname','var')) || (isempty(additionalbname)) )
    additionalbname='Bmcstltifeff';
end



%Assign input directory names and check existance of folders
onlyassignnames=true;
[thebenchmarkdir,theDir,trackDir,isvalid] = Benchmarkcreatebmetricdirs(filenames, additionalbname, onlyassignnames);
%theDir txt files (for name listing) contain scores, outDir output
if (~isvalid)
    fprintf('Data directory is not existing\n');
    return;
end



%Check existance of output directory and request confirmation of deletion
onlyassignnames=true;
[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatebmout(filenames, additionalbname, onlyassignnames);
if (isvalid)
    if (requestdelconf)
        theanswer = input('Remove previous output? [ 1 (default) , 0 ] ');
    else
        theanswer=1;
    end
    if ( (isempty(theanswer)) || (theanswer~=0) )
        Removebmtheoutput(filenames,additionalbname);
        isvalid=false;
    end
end
if (~isvalid)
    [thebenchmarkdir,outDir] = Benchmarkcreatebmout(filenames, additionalbname);
end



allcodes=Bmdetectallclusternumbers(theDir);

for cc=1:numel(allcodes)
    
    thecode=allcodes{cc};
    Bmgather(theDir, thecode, outDir);
    
end

%Add Cbest code
allcodes=Bmcreatebestcases(allcodes,theDir,outDir);

for cc=1:numel(allcodes)
    
    thecode=allcodes{cc};
    Bmevaluate(thecode, outDir);
    
end

for cc=1:numel(allcodes)
    
    thecode=allcodes{cc};
    Bmprint(thecode, outDir);
    
end



%     rmdir(thebenchmarkdir,'s')
%     rmdir(outDir,'s')


