function Removebenchmarkmcdir(filenames,additionalname)

[thebenchmarkdir,theDir,isvalid] = Benchmarkcreatemanifoldclusterdirs(filenames, additionalname, true);

if (isvalid)
    rmdir(theDir,'s')
    fprintf('Dir %s removed\n',theDir);
else
    fprintf('Dir %s not removed (non existing)\n',theDir);
end

