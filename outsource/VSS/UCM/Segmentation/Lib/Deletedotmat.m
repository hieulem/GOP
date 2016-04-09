function thestring=Deletedotmat(thestring)
wheredot=findstr(thestring,'.');
if (~(numel(wheredot)<1)) %if there is at least a dot
    thestring=thestring(1:wheredot(end)-1); %excludes dot
end
