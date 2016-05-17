function Computecm(filenames,additionalname,requestdelconf,plotcolor,addtoprevious,justavideo)

if (~exist('justavideo','var'))
    justavideo=[];
end
if ( (~exist('addtoprevious','var')) || (isempty(addtoprevious)) )
    addtoprevious=false;
end
if ( (~exist('plotcolor','var')) || (isempty(plotcolor)) )
    plotcolor='r';
end
if ( (~exist('requestdelconf','var')) || (isempty(requestdelconf)) )
    requestdelconf=true;
end
if ( (~exist('additionalname','var')) || (isempty(additionalname)) )
    additionalname='Cstltifeff';
end



%Assign input directory names and check existance of folders
onlyassignnames=true;
[thebenchmarkdir,theDir,isvalid,theDirf,isvalidf] = Benchmarkcreatemanifoldclusterdirs(filenames, additionalname, onlyassignnames);
%theDir txt files (for name listing) contain scores, outDir output
if (~isvalid)
    fprintf('Data directory is not existing\n');
    return;
end



%Check existance of output directory and request confirmation of deletion
onlyassignnames=true;
[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatemcout(filenames, additionalname, onlyassignnames);
if (isvalid)
    if (requestdelconf)
        theanswer = input('Remove previous output? [ 1 (default) , 0 ] ');
    else
        theanswer=1;
    end
    if ( (isempty(theanswer)) || (theanswer~=0) )
        Removemctheoutput(filenames,additionalname);
        isvalid=false;
    end
end
if (~isvalid)
    [thebenchmarkdir,outDir] = Benchmarkcreatemcout(filenames, additionalname);
end



Mcbench(theDir, outDir, justavideo);
if (isvalidf)
    Mcbench(theDirf, outDir, justavideo,'evaluationsf.txt');
end
%The explained variation index is only written in evaluationf.txt
%In evaluation.txt the correponding index is 0, for compatibility

Mcploterrorrate(outDir,plotcolor,addtoprevious);
% Mcplot(outDir,plotcolor,addtoprevious);



%     rmdir(thebenchmarkdir,'s')
%     rmdir(outDir,'s')


