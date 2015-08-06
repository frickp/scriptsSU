function out = strfindJDB(string, list)
% Author: Jason Buenrostro, Stanford University
% search for string and return logic indicies

% if simple string
if isstr(string)
    found = regexpi(list,string);
    out = cellfun(@isempty,found)==0;
end

% if array
if iscell(string)
    % initialize
    out = zeros(length(list),1);
    
    % regexp
    for i = 1:length(string)
        found = regexpi(list,string(i));
        out = out+double(cellfun(@isempty,found)==0);
    end
    
    % resolve
    out = logical(out>0);
end

end
