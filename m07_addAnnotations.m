% Author: Jason Buenrostro, Stanford University
% Add annotations

% enhancer v promoter
add1 = strfindJDB('promoter',bed(:,7));
add2 = strfindJDB('promoter',bed(:,7))==0;
peakAssoc = [peakAssoc add1 add2];
TFlabels = [TFlabels' 'Promoter:Homer' 'Distal:Homer']';

% add state calls
try
    % add global calls
    add3 = strfindJDB('promoter',bed(:,15));
    add4 = strfindJDB('enhancer',bed(:,15));
    peakAssoc = [peakAssoc add3 add4];
    TFlabels = [TFlabels' 'Promoter:HMM' 'State:Enhancer:HMM']';
    
    % add state calls
    states = unique(bed(strfindJDB(',',bed(:,15))==0,15));
    for i = 1:length(states)
        add = strfindJDB(states(i),bed(:,15));
        peakAssoc = [peakAssoc add];
        TFlabels = [TFlabels' states(i)]';
    end
catch
end

% add repeats
try
    % read
    repeats = readtext(inRepeats);
    
    % add repeats
    states = [{'NA'},unique(strrep(unique(regexprep(unique(repeats(:,end)),',.*','')),'?',''))']';
    lookup = strcat({','},repeats(:,end),{','});
    for i = 1:length(states)
        add = strfindJDB([',' states{i} ','],lookup);
        peakAssoc = [peakAssoc add];
        TFlabels = [TFlabels' states(i)]';
    end
    
    % add repeats2
    states = [{'NA'},unique(strrep(unique(regexprep(unique(repeats(:,end-1)),',.*','')),'?',''))']';
    lookup = strcat({','},repeats(:,end-1),{','});
    for i = 1:length(states)
        add = strfindJDB([',' states{i} ','],lookup);
        peakAssoc = [peakAssoc add];
        TFlabels = [TFlabels' states(i)]';
    end

%     % add repeats3
%     states = [{'NA'},unique(strrep(unique(regexprep(unique(repeats(:,end-2)),',.*','')),'?',''))']';
%     lookup = strcat({','},repeats(:,end-2),{','});
%     for i = 1:length(states)
%         add = strfindJDB([',' states{i} ','],lookup);sum(add)
%         peakAssoc = [peakAssoc add];
%         TFlabels = [TFlabels' states(i)]';
%     end
catch
end


%[TFlabels num2cell(sum(full(peakAssoc)))']