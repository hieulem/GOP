function thenumbers=Readbnumbers(bmetricsfile)
%Function to read the bNumbers.txt

thenumbers=zeros(1,5);

fid = fopen(bmetricsfile);

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid);
thenumbers(1)=str2double(tline); %density in percent

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid);
thenumbers(2)=str2double(tline); %overall (per pixel) clustering error (in percent)

%Here it is also possible to scan according to the number of regions
%defined in the Def.dat file
%We scan for the corresponding preceding string instead
while (true)
    tline = fgetl(fid);
    if ( (numel(tline)==1) && (tline==-1) )
        fprintf('End of file reached prematurely\n');
        return;
    end
    
    if ( (numel(tline)>=50) && (strcmp(tline(1:50),'Average (per region) clustering error (in percent)')) )
        break;
    end
end

tline = fgetl(fid);
thenumbers(3)=str2double(tline); %Average (per region) clustering error (in percent)

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid);
thenumbers(4)=str2double(tline); %Number of clusters merged

dummy = fgetl(fid); %#ok<NASGU>
dummy = fgetl(fid); %#ok<NASGU>

tline = fgetl(fid);
thenumbers(5)=str2double(tline); %Regions with less than 10%

fclose(fid);

