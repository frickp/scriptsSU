function out = strfindJDBexact(string, list)
% Author: Jason Buenrostro, Stanford University
% search for string and return logic indicies

% if simple string
if isstr(string)
    found = strcmp(list,string);
    out = found;
end

% if array
if iscell(string)
    % initialize
    out = zeros(length(list),1);
    
    % regexp
    for i = 1:length(string)
        found = strcmp(list,string(i));
        out = out+found;
    end
    
    % resolve
    out = logical(out>0);
end

end
