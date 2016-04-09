function Removemctheoutput(filenames,additionalname)

[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatemcout(filenames, additionalname, true);

if (isvalid)
    rmdir(outDir,'s')
    fprintf('Dir %s removed\n',outDir);
else
    fprintf('Dir %s not removed (non existing)\n',outDir);
end

