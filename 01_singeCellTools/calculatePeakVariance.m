function [output, shuffled] = calculatePeakVariance(filteredData,filteredPeakAssoc,bgParem,readSort)
% Authors: Jason Buenrostro & Will Greenleaf, Stanford University

% A script that generates permuted peak associations from sorted peak
% attributes, and calculated observed and expected variance.

% Set the number of times to permute the peak associations
totalIterations = 1000;

% initialize local variables
peakRange = 1:size(filteredData, 2);
totAssoc = sum(filteredPeakAssoc);
kernelSize = 2500;
readsPerCell = sum(filteredData,2);
readsPerRegion = sum(filteredData,1);
totalReads = sum(readsPerCell);

% get sort indicies based on reads per peak
TFSortMat(1,:) = peakRange;
TFSortMat(2,:) = readSort;
TFSortMat(3,:) = bgParem;
[Bpeak,Ipeak] = sortrows(TFSortMat',2);
[Bbias,Ibias] = sortrows(TFSortMat',3);
[~,revIpeak] = sortrows(Bpeak,1);
[~,revIbias] = sortrows(Bbias,1);

% initialize bias variables
permFilteredPeakAssocPeak = zeros(totalIterations+1,size(filteredPeakAssoc,1),size(filteredPeakAssoc,2));
permObservedPerCellBias = zeros(size(filteredPeakAssoc,2),size(filteredData,1));
permObservedPerCellPeakBias = permObservedPerCellBias;

% initialize output variables
output = struct; shuffled = struct;
permMatrix = zeros(totalIterations+1,size(filteredPeakAssoc,2),size(filteredData,1));
permVarMatrix = zeros(size(permMatrix));
observedMatrix = zeros(size(filteredPeakAssoc,2),size(filteredData,1));
deviationFromExpected = zeros(size(observedMatrix));
RANDobservedMatrix = zeros(size(observedMatrix));

%% create weight vectors
% initialize datasample weights Peaks
filteredPeakAssocSort = filteredPeakAssoc(Ipeak, :);
paddedPAS = padarray(double(full(filteredPeakAssocSort)),kernelSize./2,'symmetric');
paddedPAS = paddedPAS(1:end-1,:);
wPeak = conv2(paddedPAS,ones(kernelSize,1),'valid')'./kernelSize;

% initialize datasample weights Bias
filteredPeakAssocSort = filteredPeakAssoc(Ibias, :);
paddedPAS = padarray(double(full(filteredPeakAssocSort)),kernelSize./2,'symmetric');
paddedPAS = paddedPAS(1:end-1,:);
wBias = conv2(paddedPAS,ones(kernelSize,1),'valid')'./kernelSize;

% initialize datasample weights peak given bias
filteredPeakAssocSort = wBias(:,revIbias)';
filteredPeakAssocSort = filteredPeakAssocSort(Ipeak,:);
paddedPAS = padarray(filteredPeakAssocSort,kernelSize./2,'symmetric');
paddedPAS = paddedPAS(1:end-1,:);
wPeakBias = conv2(paddedPAS,ones(kernelSize,1),'valid')'./kernelSize;

% initialize for fast matrix math
idxSparse = find(filteredData>0);
[idxCell, idxPeak] = ind2sub(size(filteredData),idxSparse);
dataVector = filteredData(idxSparse);

%% loop through and build background model
% build peak bias model
disp('Building peak bias backgroud...')
for iteration = 1:totalIterations+1
    disp(['Permute: ' num2str(iteration)])
    % create permute index by sampling peaks
    for index = 1:size(filteredPeakAssoc, 2)
        idxperm = datasample(peakRange,totAssoc(index),'Weights',wPeak(index,:),'Replace',true);
        [a,~] = hist(idxperm,1:peakRange(end)); Bpeak(:,3) = a;
        permFilteredPeakAssocPeak(iteration,:, index) = Bpeak(revIpeak,3);
    end
end

% build Tn5 bias model
disp('Building Tn5 bias backgroud...')
for i = 1:size(filteredPeakAssoc, 2)
    % read counts for TF(i) & store
    bIdx = wBias(i,revIbias); pbIdx = wPeakBias(i,revIpeak);
    permObservedPerCellBias(i,:) = accumarray(idxCell,dataVector.*bIdx(idxPeak)');
    permObservedPerCellPeakBias(i,:) = accumarray(idxCell,dataVector.*pbIdx(idxPeak)');
end

%% calculate variance

disp('Calculating variance...')
% loop through and calculate variance
for iteration = 1:totalIterations+1
    disp(['Permute: ' num2str(iteration)])
    % calc expected variance for permuted associations
    for i = 1:size(filteredPeakAssoc, 2)
        % read counts for TF(i) & store
        x = rldecode(permFilteredPeakAssocPeak(iteration,:, i),peakRange);
        permObservedPerCellPeak = sum(filteredData(:,x),2);
        temp = sum(filteredData(:,filteredPeakAssoc(:, i)'),2);
        normX = sum(temp)./sum(permObservedPerCellBias(i,:));
        permObservedPerCell = permObservedPerCellPeak+normX*(permObservedPerCellBias(i,:)-permObservedPerCellPeakBias(i,:))';
        
        % expectation of reads per cell for this TF given the permutation matrix
        permMatrix(iteration, i, :) = permObservedPerCell;
        expectedPerCell = sum(permObservedPerCell).*readsPerCell/totalReads;
        
        % Calculate the variance for this factor for this iteration & store
        output.matPermObservedTFVariances(iteration, i) = sum((permObservedPerCell-expectedPerCell).^2);
        permVarMatrix(iteration, i, :) = (permObservedPerCell-expectedPerCell).^2;
    end
end

%% Calculate observed
% Calculate the mean expected variance for each cell and TF
%output.expectedVarPerTFandCell = squeeze(mean(permVarMatrix(1:totalIterations,:,:), 1))';
output.expectedVarPerTFandCell = squeeze(mean(permVarMatrix(1:totalIterations,:,:), 1));

% loop and calculate observed deviations
for i = 1:size(filteredPeakAssoc, 2)
    % read counts for each TF(i)
    observedPerCell = sum(filteredData(:,filteredPeakAssoc(:, i)'),2);
    observedMatrix(i, :) = observedPerCell;
    
    % total observed counts
    output.observedTotal(i) = sum(observedMatrix(i, :));
    output.bias(i) = mean(bgParem(filteredPeakAssoc(:, i)));
    
    % expectation of reads per cell for this TF given the permutation matrix
    expectedPerCell = sum(filteredPeakAssoc(:,i)'.*readsPerRegion).*readsPerCell/totalReads;
    
    % Calculate the observed variance for this factor
    output.observedTFVariance(i) = sum((observedPerCell-expectedPerCell).^2);
    
    % calculate the deviation from expected (unsquared variance, used in the cluster plot)
    deviationFromExpected(i, :) = (observedPerCell-expectedPerCell);
    
    %%%%%%% shuffled background %%%%%%
    temp = find(permFilteredPeakAssocPeak(:, i)'>0);
    RANDobservedPerCell = sum(filteredData(:,permFilteredPeakAssocPeak(temp, i)'),2);
    RANDobservedMatrix(i, :) = RANDobservedPerCell;
    shuffled.observedTotal(i) = sum(RANDobservedMatrix(i, :));
    shuffled.bias(i) = mean(bgParem(permFilteredPeakAssocPeak(temp, i)));
    %%%%%%% shuffled background %%%%%%
end

%% normalize deviations: for all cells and TFs the deviation from expected
% divided by the sqrt of the average expected variance from the simulation for that cell and TF
output.normalizedDeviationMatrix = deviationFromExpected./sqrt(output.expectedVarPerTFandCell);

% calculate the deviation error for errorbars
output.deviationError = std(sqrt(bsxfun(@rdivide, output.observedTFVariance, output.matPermObservedTFVariances)));

% calculate the normalized variances for each TF (summing over cells)
output.expDevSum = sum(deviationFromExpected.^2, 2);
output.expVarSum = sum(output.expectedVarPerTFandCell, 2);
output.normalizedVariances = output.expDevSum./output.expVarSum;

% calculate data variance
output.reads = output.observedTotal/totalReads;
output.var = calculateNormVar(output.normalizedDeviationMatrix,output.expectedVarPerTFandCell);

%%%%%%% shuffled background %%%%%%
%RANDdeviationFromExpected = squeeze(permVarMatrix(end,:,:))';
RANDdeviationFromExpected = squeeze(permVarMatrix(end,:,:));
shuffled.normalizedDeviationMatrix = sqrt(RANDdeviationFromExpected)./sqrt(output.expectedVarPerTFandCell);
shuffled.var = calculateNormVar(shuffled.normalizedDeviationMatrix,output.expectedVarPerTFandCell);
shuffled.observedTotal = squeeze(mean(mean(permMatrix),3));
shuffled.reads = shuffled.observedTotal/totalReads;
temp = permFilteredPeakAssocPeak(:, i)>0;
shuffled.bias(i) = mean(bgParem(permFilteredPeakAssocPeak(temp, i)));
%%%%%%% shuffled background %%%%%%

% plot
% [x1,y1] = ksdensity(output.var);[x2,y2]=ksdensity(shuffled.var);
% figure;subplot(1,2,1);plot(y1,x1./max(x1));hold on;plot(y2,x2./max(x2),'r');
% subplot(1,2,2);plot(sort(output.var));hold on;plot(sort(shuffled.var),'r')

end
