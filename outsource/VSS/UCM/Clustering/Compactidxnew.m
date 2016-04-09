function IDX=Compactidxnew(IDX,agroupnumber)
% IDX=Compactidxnew(IDX,agroupnumber);

assignedidxs=unique(IDX);

outmten=find(assignedidxs<=0);
if (~isempty(outmten))
    assignedidxs(outmten)=[]; %so the outliers <=0 are not considered among the assigned, nor any IDX<=0
end

numberassignedidxs=numel(assignedidxs);

if (numberassignedidxs~=agroupnumber)
    fprintf('Assigned %d labels instead of the requested %d\n',agroupnumber,numberassignedidxs);
end

if (max(assignedidxs)~=numberassignedidxs) %case of not compact labels
    
    labelstomove=sum(assignedidxs>numberassignedidxs);
    
    posin=1;
    posout=numel(assignedidxs)+1;
    delabels=[];
    while (labelstomove>0)
        
        if (any(assignedidxs==posin))
            posin=posin+1;
            continue;
        end
        
        outval=find(assignedidxs>=posout,1,'first');
        posout=assignedidxs(outval)+1;
        delabels=[delabels,assignedidxs(outval)]; %#ok<AGROW>
        
        IDX(IDX==assignedidxs(outval))=posin;
        labelstomove=labelstomove-1;
        posin=posin+1;
        
        if ((posin>numberassignedidxs)&&(labelstomove>0))
            fprintf('IDX compacting and label moving\n');
            break;
        end
    end
    fprintf('IDX''s compacted ( ');fprintf('%d ',delabels');fprintf(')\n');
end



function IDX=Compactidx_backup_previous(IDX,agroupnumber) %#ok<DEFNU>

assignedidxs=unique(IDX);
outmten=find(assignedidxs==(-10),1,'first'); assignedidxs(outmten)=[]; %so the outliers -10 are not considered among the assigned
if (~isempty(outmten))
    assignedidxs(outmten)=[]; %so the outliers -10 are not considered among the assigned
end
numberassignedidxs=numel(assignedidxs);
if (numberassignedidxs~=agroupnumber)
    missingidx=true(1,agroupnumber);
    missingidx(assignedidxs)=false;
    whichmissingidxs=find(missingidx);
    fprintf('Missing idxs ( '); fprintf('%d ',whichmissingidxs); fprintf(')\n');
    missingidxsordered=sort(whichmissingidxs,'descend');
    for idxord=1:numel(missingidxsordered)
        IDX(IDX>missingidxsordered(idxord))=IDX(IDX>missingidxsordered(idxord))-1;
    end
    fprintf('IDX''s compacted\n');
end
