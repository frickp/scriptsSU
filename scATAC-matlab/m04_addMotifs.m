% Author: Jason Buenrostro, Stanford University
% Add replication timing data

% label chip
for i = 1:length(TFlabels)
    TFlabels{i} = [TFlabels{i} ':' 'ChIP'];
end

% load motifs
motifs = load(motifFile);
if isequal(bed(:,3),motifs.bed(:,3)) == 0
    error('Bias file not correctly sorted');
end

% filter redudant
% for i = 1:length(motifs.dataHeaders)
%     try; motifs.filtIdx(i) = isequal(motifs.dataHeaders(i,2),motifs.dataHeaders(i+1,2))==0;
%     catch; motifs.filtIdx(i) = 1;
%     end
% end
% motifs.dataHeaders = motifs.dataHeaders(motifs.filtIdx,:)
% motifs.peakAssoc = motifs.peakAssoc(:,motifs.filtIdx)

% label
for i = 1:length(motifs.dataHeaders)
    motifs.dataHeaders{i} = [motifs.dataHeaders{i} ':' motifLabel];
end

% add to peakAssoc & TF labels
peakAssoc = [peakAssoc motifs.peakAssoc];
peakAssoc = logical(peakAssoc);
TFlabels = [TFlabels' motifs.dataHeaders(:,1)']';
