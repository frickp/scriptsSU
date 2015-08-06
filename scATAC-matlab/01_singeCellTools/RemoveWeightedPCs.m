function [x] = RemoveWeightedPCs(PCvector,dataMatrix,weights)
% Author: Jason Buenrostro, Stanford University

% A script that will remove weighted PCs
% attributes, and calculated observed and expected variance.

% initialize variables
x = dataMatrix;
ndim = 1;  %%%%%%% correct?
[n,p] = size(x);

% make PCs
[coeff,score,~,~,explained] = pca(x,'Economy',true,'weights',weights+.000001);

% plot before
figure;subplot(1,length(PCvector)+1,1)
scatter(score(:,1),score(:,2),20,'filled','markerfacecolor',[.5 .5 .5]);hold on
scatter(score(weights,1),score(weights,2),20,'filled','markerfacecolor',[1 0 0]);
text(score(weights,1)+1,score(weights,2),num2str(find(weights==1)));
xlabel(['PC1: ' num2str(explained(1)) '%']);ylabel(['PC2: ' num2str(explained(2)) '%']);title('Before');

% loop through
for i = 1:length(PCvector)
    % vect to remove
    rVect = PCvector(i);
    
    % remove PC
    %reconstructed = repmat(mean(x,1),n,1) + score(:,1:ndim)*coeff(:,1:ndim)';
    reconstructed = repmat(mean(x,1),n,1) + score(:,rVect)*coeff(:,rVect)';
    x = x - reconstructed;
    
    % make PCs
    [coeff,score]= pca(x,'Economy',true,'weights',weights+.000001);

    % plot final
    subplot(1,length(PCvector)+1,i+1)
    scatter(score(:,1),score(:,2),20,'filled','markerfacecolor',[.5 .5 .5]);hold on
    scatter(score(weights,1),score(weights,2),20,'filled','markerfacecolor',[1 0 0]);
    text(score(weights,1)+1,score(weights,2),num2str(find(weights==1)));
    xlabel(['PC1: ' num2str(explained(1+PCvector(i))) '%']);ylabel(['PC2: ' num2str(explained(2+PCvector(i))) '%']);title(['Remove PC:' num2str(i)]);
end
end