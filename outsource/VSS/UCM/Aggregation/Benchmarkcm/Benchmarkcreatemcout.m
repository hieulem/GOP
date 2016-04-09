function [thebenchmarkdir,outDir,isvalid] = Benchmarkcreatemcout(filenames, additionalname, onlyassignnames)
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output

if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,additionalname,filesep]); isvalid=isvalid&isvalidtmp;
    [outDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Outputmc',filesep]);                    isvalid=isvalid&isvalidtmp;
    
    %outDir does not to exist
else
    
    Createadir(filenames.benchmark);
    
    thebenchmarkdir = Createadir([filenames.benchmark,additionalname,filesep]);

    outDir = Createadir([thebenchmarkdir,'Outputmc',filesep]);
    
    %Additionally isvalid could be generated in Createdir
end


