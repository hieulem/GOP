function [thebenchmarkdir,theDir,trackDir,isvalid] = Benchmarkcreatebmetricdirs(filenames, additionalbname, onlyassignnames)
%theDir txt files (for name listing) contain scores, outDir output

if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,additionalbname,filesep]); isvalid=isvalid&isvalidtmp;
    [theDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Binput',filesep]);                    isvalid=isvalid&isvalidtmp;
    [trackDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Tracks',filesep]);                    isvalid=isvalid&isvalidtmp;
    
    %outDir does not to exist
else
    
    Createadir(filenames.benchmark);
    
    thebenchmarkdir = Createadir([filenames.benchmark,additionalbname,filesep]);
    theDir = Createadir([thebenchmarkdir,'Binput',filesep]);
    trackDir = Createadir([thebenchmarkdir,'Tracks',filesep]);
    
    %Additionally isvalid could be generated in Createdir
end


