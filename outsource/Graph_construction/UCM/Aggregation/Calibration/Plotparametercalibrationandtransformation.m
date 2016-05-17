function Plotparametercalibrationandtransformation(filenames, paramcalibname)

if ( (~exist('paramcalibname','var')) || (isempty(paramcalibname)) )
    paramcalibname='Paramcstltifefff'; fprintf('Using standard additional name %s, please confirm\n',paramcalibname); pause;
end

onlyassignnames=true;
[thebenchmarkdir,outDir,isvalid] = Benchmarkcreatecalibrationparameterout(filenames, paramcalibname, onlyassignnames); %#ok<ASGLU>
if (~isvalid)
    fprintf('Please run Computeparametercalibration first\n');
    return;
end

%List of files in Output
iids = dir(fullfile(outDir,'*.txt'));
if (numel(iids)<1)
    fprintf('Statistics to be computed\n');
    return;
end
for i = 1:numel(iids)
    
    [thepath, theaffinityname, theext] = fileparts(iids(i).name); if (~isempty(thepath)), fprintf('This dir name %s should be empty\n', thepath); end %#ok<NASGU>
    
    inFile= fullfile(outDir, iids(i).name); %[thename, theext]

    thescore = dlmread(inFile);
    posbin=thescore(:,1)';
    negbin=thescore(:,2)';
    
    figurenumber=10*i;
    Plotaffinityplots([negbin;posbin],[],theaffinityname,{'false','true'},figurenumber,false);
%     Plotaffinityplots([negbin;posbin],[],theaffinityname,{'false','true'},figurenumber+1,true,false);
    
    [posbintmp,negbintmp,bincenters,themintmp,themaxtmp,casefound]=Inittheparametercalibrationhistogram(theaffinityname); %#ok<ASGLU>

    if (casefound)
        %Plot transformed values in paper
        [bincentersout,casefound]=Transformtheaffinities(bincenters,theaffinityname); %Transform according to paper
        if (~casefound), fprintf('casefound in second instance\n'); return; end;
%         Plotaffinityplots([negbin;posbin],bincentersout,theaffinityname,{'false','true'},figurenumber+3,false,true);
        
        %Plot transformed values in paper and new
        [bincentersnew,casefound]=Transformtheaffinities(bincenters,[theaffinityname,'new']); %Transform in optimized way
        if (~casefound), fprintf('casefound in second instance\n'); return; end;
        Plotaffinityplots([negbin;posbin;negbin;posbin],[bincentersout;bincentersout;bincentersnew;bincentersnew],...
            theaffinityname,{'false','true','falsenew','truenew'},figurenumber+5,false,true);
        
        %Plot transformed values in paper and new
%         [bincentersnew2,casefound2]=Transformtheaffinities(bincenters,[theaffinityname,'new2']); %Transform in optimized way
%         if (~casefound2), fprintf('casefound in second2 instance\n'); return; end;
%         Plotaffinityplots([negbin;posbin;negbin;posbin;negbin;posbin],[bincentersout;bincentersout;bincentersnew;bincentersnew;bincentersnew2;bincentersnew2],...
%             theaffinityname,{'false','true','falsenew','truenew','falsenew2','truenew2'},figurenumber+3,false,true);
    end
    
end

