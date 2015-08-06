% Author: Jason Buenrostro, Stanford University
% Cluster TF associations

% get rvalue and report
corMat = zeros(length(TFlabels));

% loop through TFs
for i = 1:length(peakAssoc(1,:))
    for j = 1:length(peakAssoc(1,:))
        rVal = corrcoef(peakAssoc(:,i)*1,peakAssoc(:,j)*1);
        corMat(i,j) = rVal(1,2);
        %corMat(i,j) = 1 - pdist([peakAssoc(:,i) peakAssoc(:,j)]','jaccard');
    end
end
%corMat = pdist(peakAssoc,'jaccard');

% replace nans
corMat(isnan(corMat)) = 0;

% cluster corrtable 
cgo = clustergram(corMat,'Cluster','all','Colormap','redbluecmap',...
    'Symmetric','false','RowLabels',TFlabels,'ColumnLabels',TFlabels);




