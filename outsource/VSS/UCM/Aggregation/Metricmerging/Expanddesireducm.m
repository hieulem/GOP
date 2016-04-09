function newucm2=Expanddesireducm(newucm2,desireducmlevels,framerange)

%Expand newucm2 to the desireducmlevels
maxucm2=0;
for ff=framerange
    maxucm2=max( max(newucm2{ff}(:)) , maxucm2 );
end
multfactor=floor(desireducmlevels/double(maxucm2));
for ff=framerange
    newucm2{ff}=newucm2{ff} * multfactor;
end
