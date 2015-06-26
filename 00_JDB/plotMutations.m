function plotMutations(sortOrder,table,colIdx)
% Author: Jason Buenrostro, Stanford University
% Plots mutation information

% initalize and loop to find samples
idxTable = [];
for i = 1:length(sortOrder)
    temp = find(strfindJDB(regexprep(sortOrder(i),'[.][pHSC | Leuk].*',''),table(:,1)));
    if isempty(temp); idxTable(i) = 0; else;  idxTable(i) = temp;end
end

% initialize matrix and plot
muts = zeros(length(colIdx),length(sortOrder));
muts(:,find(idxTable)) = cell2mat(table(idxTable(idxTable>0),colIdx))';
figure;imagesc(muts);colormap(colorsJDB('color','wolfgang_extra'))
set(gca,'xtick',1:100,'xticklabels',sortOrder,'XTickLabelRotation',90);
set(gca,'ytick',1:100,'yticklabels',strrep(table(1,colIdx),'_','-'));
end

