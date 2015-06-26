function [peakAssoc TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inFile,label)
% Author: Jason Buenrostro, Stanford University
% Add association data

% load motifs
motifs = load(inFile);
if isequal(bed(:,3),motifs.bed(:,3)) == 0
    error('File not correctly sorted');
end

% label
for i = 1:length(motifs.dataHeaders)
    motifs.dataHeaders{i} = [motifs.dataHeaders{i} ':' label];
end

% add to peakAssoc & TF labels
peakAssoc = [peakAssoc motifs.peakAssoc];
peakAssoc = logical(peakAssoc);
TFlabels = [TFlabels' motifs.dataHeaders(:,1)']';
end