function Removebenchmarkbmdir(filenames,additionalbname)

[thebenchmarkdir,theDir,trackDir,isvalid] = Benchmarkcreatebmetricdirs(filenames, additionalbname, true);

if (isvalid)
    rmdir(theDir,'s')
    rmdir(trackDir,'s')
    fprintf('Dirs %s and %s removed\n',theDir,trackDir);
else
    fprintf('Dirs %s\n and %s not removed (non existing)\n',theDir,trackDir);
end

