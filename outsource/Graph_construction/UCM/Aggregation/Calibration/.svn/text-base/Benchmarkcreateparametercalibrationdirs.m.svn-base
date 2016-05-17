function [thebenchmarkdir,theDir,isvalid] = Benchmarkcreateparametercalibrationdirs(filenames, paramcalibname, onlyassignnames)
%theDir txt files (for name listing) contain scores, outDir output

if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,paramcalibname,filesep]); isvalid=isvalid&isvalidtmp;
    [theDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Input',filesep]);                    isvalid=isvalid&isvalidtmp;
    
    %outDir does not to exist
else
    
    Createadir(filenames.benchmark);
    
    thebenchmarkdir = Createadir([filenames.benchmark,paramcalibname,filesep]);
    theDir = Createadir([thebenchmarkdir,'Input',filesep]);
    
    %Additionally isvalid could be generated in Createdir
end


