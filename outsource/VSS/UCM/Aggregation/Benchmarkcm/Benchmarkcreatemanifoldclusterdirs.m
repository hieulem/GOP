function [thebenchmarkdir,theDir,isvalid,theDirf,isvalidf] = Benchmarkcreatemanifoldclusterdirs(filenames, additionalname, onlyassignnames)
%theDir txt files (for name listing) contain scores, outDir output
%theDirf txt files (for name listing) contain scores optimized according to F-measure

if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
isvalidf=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,additionalname,filesep]); isvalid=isvalid&isvalidtmp;
    [theDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Input',filesep]);                    isvalid=isvalid&isvalidtmp;
    [theDirf,isvalidtmp] = Checkadir([thebenchmarkdir,'Inputf',filesep]);                    isvalidf=isvalidf&isvalidtmp;
    
else
    
    Createadir(filenames.benchmark);
    
    thebenchmarkdir = Createadir([filenames.benchmark,additionalname,filesep]);
    theDir = Createadir([thebenchmarkdir,'Input',filesep]);
    theDirf = Createadir([thebenchmarkdir,'Inputf',filesep]);
    
    %Additionally isvalid could be generated in Createdir
end


