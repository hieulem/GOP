function [thebenchmarkdir,outDir,isvalid] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname, onlyassignnames, printtext)
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output

if ( (~exist('printtext','var')) || (isempty(printtext)) )
    printtext=true;
end
if ( (~exist('onlyassignnames','var')) || (isempty(onlyassignnames)) )
    onlyassignnames=false;
end

isvalid=true;
if (onlyassignnames)
    
    [thebenchmarkdir,isvalidtmp] = Checkadir([filenames.benchmark,paramcalibname,filesep]); isvalid=isvalid&isvalidtmp;
    [outDir,isvalidtmp] = Checkadir([thebenchmarkdir,'Output',filesep]);                    isvalid=isvalid&isvalidtmp;
    
    %outDir does not to exist
else
    
    Createadir(filenames.benchmark,printtext);
    
    thebenchmarkdir = Createadir([filenames.benchmark,paramcalibname,filesep],printtext);

    outDir = Createadir([thebenchmarkdir,'Output',filesep],printtext);
    
    %Additionally isvalid could be generated in Createdir
end


