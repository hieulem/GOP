function [thebenchmarkdir,outDir,isvalid] = Benchmarkcreatebmout(filenames, additionalbname, onlyassignnames)
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output

if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,additionalbname,filesep]); isvalid=isvalid&isvalidtmp;
    [outDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Output',filesep]);                    isvalid=isvalid&isvalidtmp;
    
    %outDir does not to exist
else
    
    Createadir(filenames.benchmark);
    
    thebenchmarkdir = Createadir([filenames.benchmark,additionalbname,filesep]);

    outDir = Createadir([thebenchmarkdir,'Output',filesep]);
    
    %Additionally isvalid could be generated in Createdir
end


