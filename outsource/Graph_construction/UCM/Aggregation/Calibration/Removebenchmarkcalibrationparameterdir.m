function Removebenchmarkcalibrationparameterdir(filenames,paramcalibname)

[thebenchmarkdir,theDir,isvalid] = Benchmarkcreateparametercalibrationdirs(filenames, paramcalibname, true);

if (isvalid)
    rmdir(theDir,'s')
    fprintf('Dir %s removed\n',theDir);
else
    fprintf('Dir %s not removed (non existing)\n',theDir);
end

