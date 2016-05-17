function Removecalibrationparametertheoutput(filenames,paramcalibname)

[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname, true);

if (isvalid)
    rmdir(outDir,'s')
    fprintf('Dir %s removed\n',outDir);
else
    fprintf('Dir %s not removed (non existing)\n',outDir);
end

