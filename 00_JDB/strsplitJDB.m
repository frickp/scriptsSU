function out = strsplitJDB(string, list,column)
% Author: Jason Buenrostro, Stanford University
% search for string and return logic indicies

% if simple string
for i = 1:length(list)
    temp = strsplit(list{i},string);
    out{i} = temp{column};
end
end
