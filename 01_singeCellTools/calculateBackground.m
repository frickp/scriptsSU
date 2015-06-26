function [model] = calculateBackground(filteredData,filteredPeakAssoc,bgParem,readSort)
% Authors: Jason Buenrostro & Will Greenleaf, Stanford University

% A script that generates permuted peak associations from sorted peak
% attributes, and calculated observed and expected variance.

% Set the number of times to permute the peak associations
disp('Calculating peak intensity backgroud...')
totalIterations = 20;

% initialize local variables
peakRange = 1:size(filteredData, 2);
totAssoc = sum(filteredPeakAssoc);
kernelSize = 2500;

% get sort indicies based on reads per peak
TFSortMat(1,:) = peakRange;
TFSortMat(2,:) = readSort;
TFSortMat(3,:) = bgParem;
[Bpeak,Ipeak] = sortrows(TFSortMat',2);
[Bbias,Ibias] = sortrows(TFSortMat',3);
[~,revIpeak] = sortrows(Bpeak,1);
[~,revIbias] = sortrows(Bbias,1);

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

% initialize outputs
permFilteredPeakAssocPeak = zeros(totalIterations+1,size(filteredPeakAssoc,1),size(filteredPeakAssoc,2));
permObservedPerCellBias = zeros(size(filteredPeakAssoc,2),size(filteredData,1));
permObservedPerCellPeakBias = permObservedPerCellBias;

%% loop through and build background model
for iteration = 1:totalIterations+1
    disp(['Permute: ' num2str(iteration)])
    % create permute index by random sampling
    for index = 1:size(filteredPeakAssoc, 2)
        % peak sampling
        %idxperm = datasample(peakRange,totAssoc(index),'Weights',wPeak(index,:),'Replace',false);
        idxperm = datasample(peakRange,totAssoc(index),'Weights',wPeak(index,:),'Replace',true);
        [a,b] = hist(idxperm,1:peakRange(end)); Bpeak(:,3) = a;
        permFilteredPeakAssocPeak(iteration,:, index) = Bpeak(revIpeak,3);
    end
end

% build Tn5 bias model
disp('Calculating Tn5 bias backgroud...')
for i = 1:size(filteredPeakAssoc, 2)
    % read counts for TF(i) & store
    bIdx = wBias(i,revIbias); pbIdx = wPeakBias(i,revIpeak);
    permObservedPerCellBias(i,:) = accumarray(idxCell,dataVector.*bIdx(idxPeak)');
    permObservedPerCellPeakBias(i,:) = accumarray(idxCell,dataVector.*pbIdx(idxPeak)');
end

% save model
model.filteredData = filteredData;
model.filteredPeakAssoc = filteredPeakAssoc;
model.bgParem = bgParem;
model.permFilteredPeakAssocPeak = permFilteredPeakAssocPeak;
model.permObservedPerCellBias = permObservedPerCellBias;
model.permObservedPerCellPeakBias = permObservedPerCellPeakBias;

end
