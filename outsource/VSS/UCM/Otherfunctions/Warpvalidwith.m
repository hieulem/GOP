function validtop=Warpvalidwith(validtoppp,U,V)

rows=size(validtoppp,1);
cols=size(validtoppp,2);

validtop=true(rows,cols);

validtop(:)=validtoppp( sub2ind(size(validtoppp),max(1,min(rows,V(:))),max(1,min(cols,U(:)))) );
