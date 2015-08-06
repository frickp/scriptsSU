% Author: Jason Buenrostro, Stanford University
% Plot variance results
addpath(genpath('/Users/jbuenros/Documents/MATLAB/bin'));
addpath(genpath('/Volumes/jbuenros/Documents/MATLAB/bin'));

% calculate error
%try;load('TreatmeantVariance.mat');disp(output);catch;end
%try;load('CollectedData.mat');disp(output);catch;end
expType='mDC' %SU048
%expType='K562wCNV' %SU048
%expType=cellType

% load data
try;dataStruct = output.(expType);catch;dataStruct = outputTreat.(expType);end
try;shuffStruct = shuffled.(expType);catch;shuffStruct = shuffledTreat.(expType);end
normReads = dataStruct.reads;
normTFlabels = strrep(dataStruct.filteredTFlabels,'_','-');
normError = dataStruct.deviationError;
normSampleHeaders = dataStruct.filteredSampleHeaders;

% calculate variance
devMatrix = dataStruct.normalizedDeviationMatrix;
normVar = calculateNormVar(devMatrix,dataStruct.expectedVarPerTFandCell);
%sigIdx = normVar > nanmean(normVar)+nanstd(normVar);
sigIdx = normVar > 1.3;
%sigIdx = strfindJDB('idxPeak',normTFlabels) || normVar' > 1.3;
%sigIdx = strfindJDB('sig',normTFlabels);

% calculate rand variance
RANDnormReads = shuffStruct.reads;
RANDdevMatrix = shuffStruct.normalizedDeviationMatrix;
RANDnormVar = calculateNormVar(RANDdevMatrix,dataStruct.expectedVarPerTFandCell);

% plot variance rank
figure;
[a,b] = sort(normVar,'descend');[a,bRAND] = sort(RANDnormVar,'descend');
errorbarJDB(1:length(normVar),normVar(b),normError)
scatter(1:length(normVar),normVar(b),20,[.5 .5 .5],'marker','.');hold on
scatter(1:length(normVar),RANDnormVar(bRAND),20,[.5 0 .75],'marker','.');hold on
x=(1:length(normVar))+5;y=normVar(b);z=normTFlabels(b);
text(x(sigIdx(b)),y(sigIdx(b)),z(sigIdx(b)));
xlabel('Rank Sorted','FontName','Helvetica','FontSize',12);
ylabel('Cell-cell variance','FontName','Helvetica','FontSize',12);
legend('Error','Observed','Permuted');legend('boxoff')

xlim([-5 length(normVar)+5])
%ylim([.5 2.5])
%[normTFlabels num2cell(normVar')]
[normTFlabels num2cell(normVar)' num2cell(full(sum(output.(expType).filteredPeakAssoc))')]

%%
sampleIdx = strfindJDB('DC4hr',normSampleHeaders)
% cluster
cgo = clustergram(devMatrix(sigIdx,sampleIdx),'Cluster','all','Standardize', 'none',...
    'Colormap',colormap(colorsJDB('color','solar_extra')),...
    'Symmetric','true','DisplayRange',5,'rowlabels',normTFlabels(sigIdx),'columnlabels',normSampleHeaders(sampleIdx));

%%
mapcaplot(devMatrix,normTFlabels)
mapcaplot(devMatrix(sigIdx,:),normTFlabels(sigIdx))
mapcaplot(devMatrix',dataStruct.filteredSampleHeaders)

% plot model accuracy
figure;ksdensity((RANDnormReads*156.9220-normReads)./RANDnormReads)

figure;
plot(normReads,RANDnormReads,'x');text(normReads(sigIdx),RANDnormReads(sigIdx),normTFlabels(sigIdx))
figure;
plot(dataStruct.bias,shuffStruct.bias,'rx');
text(dataStruct.bias(sigIdx),shuffStruct.bias(sigIdx),normTFlabels(sigIdx));hold on


idx = find(strfindJDB('CEBPA',output.mDC.filteredTFlabels)); idx = idx(1);output.mDC.filteredTFlabels(idx)
output.mDC.normalizedDeviationMatrix(idx,:)
ksdensity(output.mDC.normalizedDeviationMatrix(idx,:))

%%
cellPopulation = 'cd24'; cellIdx = strfindJDB(cellPopulation,filteredSampleHeaders);
figure;scatter(coeff(:,1),coeff(:,2))
text(coeff(cellIdx,1),coeff(cellIdx,2),filteredSampleHeaders(cellIdx))
%text(score(:,1),score(:,2),normTFlabels)

figure;scatter3(score(:,1),score(:,2),score(:,3),20,'filled','markerfacecolor',[.5 .5 .5]);hold on
scatter3(score(repli,1),score(repli,2),score(repli,3),20,'filled','markerfacecolor',[1 0 0])
text(score(repli,1),score(repli,2),score(repli,3),normTFlabels(repli))

% mapped_data = compute_mapping(devMatrix(repli,:), 'tSNE', 2)
% %mapped_data = compute_mapping(devMatrix(repli,:)', 'tSNE', 1);figure;ksdensity(mapped_data)
% figure;
% scatter(mapped_data(:,1),mapped_data(:,2),20,'filled','markerfacecolor',[.5 .5 .5]);hold on
% %scatter(mapped_data(repli,1),mapped_data(repli,2),20,'filled','markerfacecolor',[1 0 0]);
% %text(mapped_data(repli,1),mapped_data(repli,2),normTFlabels(repli))
% cellPopulation = 'cd24'; cellIdx = strfindJDB(cellPopulation,filteredSampleHeaders);
% scatter(mapped_data(cellIdx,1),mapped_data(cellIdx,2),20,'filled','markerfacecolor',[1 0 0]);
% %text(mapped_data(:,1),mapped_data(:,2),filteredSampleHeaders)

%% Rank variance
% recalculate stuff with PC's removed
expectedVarPerTFandCell = dataStruct.expectedVarPerTFandCell;
normVar = calculateNormVar(devMatrix,expectedVarPerTFandCell);
sigIdx = normVar > mean(normVar)+std(normVar);

% plot variance rank
figure;% subplot(2,2,[1 2])
[a,b] = sort(normVar,'descend');
%[a,bRAND] = sort(RANDnormVar,'descend');
h1=errorbar(1:length(normVar),normVar(b), normError,'Marker','.','LineStyle','none','Color',[.8 .8 .8]);hold on
scatter(1:length(normVar),normVar(b),20,[.5 .5 .5],'filled');hold on
%scatter(1:length(normVar),RANDnormVar(bRAND),20,'filled','markerfacecolor',[.5 0 .75]);hold on
errorbar_tick(h1,0);hold on;
x=(1:length(normVar))+5;y=normVar(b);z=normTFlabels(b);
text(x(sigIdx(b)),y(sigIdx(b)),z(sigIdx(b)));%text(x((b)),y((b)),z((b)));
errorbar_tick(h1,0);hold on;
xlabel('Rank Sorted','FontName','Helvetica','FontSize',12);
ylabel('Cell-cell variance','FontName','Helvetica','FontSize',12);
legend('Error','Observed','Permuted');legend('boxoff')
xlim([-5 length(normVar)+5])

%% calculate bg error
% rep2 = strfindJDB('single-ATAC-',filteredSampleHeaders);
% rep3 = strfindJDB('single-ATACRNA-',filteredSampleHeaders);
% rep1 = strfindJDB('single-',filteredSampleHeaders) & rep2==0 & rep3==0;
% repError = std([std(devMatrix(:,rep1)')' std(devMatrix(:,rep2)')' std(devMatrix(:,rep3)')']');
% %figure;ksdensity(repError)

% calculate error
% permVar = dataStruct.PermVariance(:,:,find(cellIdx==0));
% var = dataStruct.Variance(:,find(cellIdx==0));
% matPermObservedTFVariances = squeeze(sum((permVar.^2),3));
% observedTFVariance = sum((var.^2),2);
% deviationError1 = std(sqrt(bsxfun(@rdivide, observedTFVariance, matPermObservedTFVariances'))');
% permVar = dataStruct.PermVariance(:,:,cellIdx);
% var = dataStruct.Variance(:,cellIdx);
% matPermObservedTFVariances = squeeze(sum((permVar.^2),3));
% observedTFVariance = sum((var.^2),2);
% deviationError2 = std(sqrt(bsxfun(@rdivide, observedTFVariance, matPermObservedTFVariances'))');


%% scatter
figure;
h1=errorbar(normReads(sigIdx), normVar(sigIdx), normError(sigIdx),'Marker','.','LineStyle','none','Color',[0 0 0]);hold on
%h1=errorbar(normReads, normVar, dataStruct.deviationError,'Marker','.','LineStyle','none','Color',[0 0 0]);hold on
scatter(RANDnormReads,RANDnormVar,20,'filled','markerfacecolor',[.5 0 0]);hold on
scatter(normReads,normVar,20,[.5 .5 .5],'filled');
%scatter(normReads,normVar,20,distal,'filled');
errorbar_tick(h1,0);hold on;
text(normReads(sigIdx),normVar(sigIdx),normTFlabels(sigIdx));
%text(RANDnormReads(sigIdx),RANDnormVar(sigIdx),normTFlabels(sigIdx));

xlabel('Fraction of total reads','FontName','Helvetica','FontSize',12);
ylabel('Stdeviation of cell-cell variance','FontName','Helvetica','FontSize',12);
legend('Error','Random Model','Observed');legend('boxoff')

%% plot scatter
% figure;
% h1=errorbar(normReads, normVar, dataStruct.deviationError,'Marker','.','LineStyle','none','Color',[0 0 0]);hold on
% scatter(RANDnormReads,RANDnormVar,20,'filled','markerfacecolor',[.5 0 0]);
% scatter(normReads,normVar,20,'filled','markerfacecolor',[.5 .5 .5]);
% errorbar_tick(h1,0);hold on;
% text(normReads(sigIdx)+.01,normVar(sigIdx),normTFlabels(sigIdx));hold on;
% xlabel('Fraction of total reads','FontName','Helvetica','FontSize',12);
% ylabel('Stdeviation of cell-cell variance','FontName','Helvetica','FontSize',12);
% title('Unnormalized Scatter')

% plot PCA
% [coeff,score]  = pca(dataStruct.normalizedDeviationMatrix(d1,:));
% figure;scatter(score(:,1),score(:,2),20,'filled','markerfacecolor',[.5 .5 .5]);hold on
% scatter(score(sigIdx,1),score(sigIdx,2),20,'filled','markerfacecolor',[1 0 0]);
% text(score(sigIdx,1)+.1,score(sigIdx,2),normTFlabels(sigIdx))
% xlabel('PC1','FontName','Helvetica','FontSize',12);
% ylabel('PC2','FontName','Helvetica','FontSize',12);
% title('Unnormalized PCA')

%% go through artifacts

figure;
for i = 6:19
    [coeff,score,latent,tsquared,explained]  = pca(devMatrix');
    subplot(1,2,1)
    colormap('jet');cb=colorbar('EastOutside');hold on
    colorVals = cellfun(@str2num,sampleAnno(d2(3:end),i));
    scatter(score(:,1),score(:,2),20,colorVals,'filled');
    caxis([min(colorVals) max(colorVals)])
    title(sampleAnnoHeader(i))
    subplot(1,2,2)
    scatter(score(:,1),colorVals,'filled')
    evalResponse = input('Press enter to continue');
end

%%

% % color by distal
% color = abs(cellfun(@str2num,filteredBed(:,8)));
% for i = 1:length(filteredTFlabels)
%     %total = sum(filteredPeakAssoc(:,i));
%     %promoter = sum(strfindJDB('promoter',bed(filteredPeakAssoc(:,i),7)));
%     %color(i) = (total-promoter)./total;
%     color(i) = median(color(filteredPeakAssoc(:,i)));
% end

% color by corrVal to factor
%run m02_clusterTFassoc.m
%filt = strfindJDB('znf274U',TFlabels)==0 & sum(peakAssoc,1)'>1;
%corMat = corMat(filt,filt);
%idx = find(strfindJDB('Gata1Ucd',filteredTFlabels)==1);
%color = corMat(idx,:);

% PCA scatter
figure;
[coeff,score,latent,tsquared,explained]  = pca(devMatrix);
colormap('jet');cb=colorbar('EastOutside');hold on
scatter(score(:,1),score(:,2),20,normVar,'filled');;set(get(cb,'xlabel'),'string','Variance')
%scatter(score(:,1),score(:,2),20,color,'filled');set(get(cb,'xlabel'),'string','Distal')
%scatter(score(:,1),score(:,2),20,score(:,3),'filled');set(get(cb,'xlabel'),'string','PC3')
text(score(sigIdx,1)+.5,score(sigIdx,2),normTFlabels(sigIdx));
xlabel('PC1','FontName','Helvetica','FontSize',12);
ylabel('PC2','FontName','Helvetica','FontSize',12);
set(cb,'TickDir','out');x=get(cb,'Position');x(1)=x(1)*1.1;x(4)=.25;set(cb,'Position',x)

%% density est
figure;
[y,x]=ksdensity(RANDnormVar);plot(x,y./max(y),'r');hold on
[y,x]=ksdensity(normVar);plot(x,y./max(y),'b');
xlabel('Cell-Cell Variance');ylabel('Rekatuve frequency');
legend('Random Model','Observed');legend('boxoff')



%% bar plot distal
% % get all Associations
% try;states_st = sort_nat(states);stateArr = zeros(length(states_st),sum(sigIdx));
% catch;states_st = 
% end
% sigPeakAssoc = filteredPeakAssoc(:,sigIdx);
% 
% % loop through sig and find states
% for i = 1:size(sigPeakAssoc,2)
%     bedSig = bed(sigPeakAssoc(:,i),end);
%     for j = 1:length(states_st)        
%         hits = strfind(bedSig,states_st{j});
%         stateArr(j,i) = length(find(cellfun(@isempty,hits)==0));
%     end
% end
% 
% % bg state freq
% for j = 1:length(states_st)
%     hits = strfind(filteredBed(:,end),states_st{j});
%     bgstateArr(j) = length(find(cellfun(@isempty,hits)==0));
% end
% 
% % normalize to bin size
% freq = bsxfun(@rdivide,stateArr,sum(stateArr,1));
% bgFreq = bgstateArr'./sum(bgstateArr);
% figure;imagesc(freq)
% figure;imagesc([mean(freq,2) bgFreq])
% %x = mean(bsxfun(@rdivide,freq,bgFreq)),2);
% %y = bgstateArr'./sum(bgstateArr);
% clustergram(bsxfun(@rdivide,freq,bgFreq),'Cluster','all','Standardize', 'column',...
%     'Colormap','redbluecmap','RowLabels',states_st,'ColumnLabels',filteredTFlabels(sigIdx))
% 
% % barplot distance
% dist = abs(cellfun(@str2num,filteredBed(:,8)));
% w = mean(filteredPeakAssoc(:,sigIdx),2);
% x = sum((w.*dist)./sum(w));
% dist = abs(cellfun(@str2num,filteredBed(:,8)));
% w = mean(filteredPeakAssoc(:,sigIdx==0),2);
% y = sum((w.*dist)./sum(w));
% 
% % plot
% bar([x y],'linewidth',.01,'EdgeColor',[0 0 0],'FaceColor',[.5 .5 .5],'Barwidth',.75);
% xlabel('High-variance, Low-variance');
% ylabel('Mean distance to TSS');
% ylim([20000 40000])



