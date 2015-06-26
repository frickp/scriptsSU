function out = readtextJDB(inFile)
% Author: Jason Buenrostro, Stanford University
% Fast read text function

% calculate Md5sum
[status,cmdout] = system(['md5 ' inFile]);
temp = strsplit(cmdout,'=');
md5 = strtrim(temp{2});

% check for file
serFile = [inFile '.' md5 '.ser.mat'];
matFile = [inFile '.' md5 '.mat'];

% calculate
if exist(serFile, 'file') == 2
    disp('loading .ser.mat file...')
    temp = load(serFile);
    out = hlp_deserialize(temp.B_ser);
else if exist(matFile, 'file') == 2
    disp('loading .mat file...')
    temp = load(matFile);
    out = temp.out;
else
    disp('reading text file...')
    out = readtext(inFile);
    size = whos('out');
    if size.bytes<=2000000000;
        disp('writing .mat file...')
        save(matFile,'out','-v6')
    else;
        disp('writing .ser.mat file...')
        matFile = [inFile '.' md5 '.ser.mat'];
        B_ser = hlp_serialize(out);
        save(matFile,'B_ser','-v6');
    end
end
end
