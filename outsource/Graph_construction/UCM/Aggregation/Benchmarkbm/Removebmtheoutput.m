function Removebmtheoutput(filenames,additionalbname)

[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatebmout(filenames, additionalbname, true);

if (isvalid)
    rmdir(outDir,'s')
    fprintf('Dir %s removed\n',outDir);
else
    fprintf('Dir %s not removed (non existing)\n',outDir);
end

