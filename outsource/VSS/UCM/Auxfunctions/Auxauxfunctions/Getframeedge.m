function frameEdge=Getframeedge(dimi,dimj)

frameEdge=true(dimi,dimj);
frameEdge(1:dimi,1)=0;
frameEdge(1:dimi,end)=0;
frameEdge(1,1:dimj)=0;
frameEdge(end,1:dimj)=0;
