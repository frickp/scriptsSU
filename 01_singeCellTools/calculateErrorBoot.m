function normVar = calculateErrorBoot(observedTFVariance,output)%(deviationMatrix,expectedVarPerTFandCell)%,subSample)
% Author: Jason Buenrostro, Stanford University
% Calculates normalized variances

%% sample 1
% sample1
cellNum1 = size(output.(output.cond1).normalizedDeviationMatrix,2);
idxperm1 = datasample(1:cellNum1,cellNum1-20,'Replace',true);
deviationMatrixSub1 = output.(output.cond1).normalizedDeviationMatrix(:,idxperm1);
expectedVarPerTFandCellSub1 = output.(output.cond1).expectedVarPerTFandCell(:,idxperm1);

% calculate 
expVarSum = sum(expectedVarPerTFandCellSub1, 2);

% calculate
normVarTemp = sum(((deviationMatrixSub1.*(sqrt(expectedVarPerTFandCellSub1))).^2)');
normVar1 = sqrt(normVarTemp./expVarSum');

% output.deviationError = std(sqrt(bsxfun(@rdivide, output.observedTFVariance, output.matPermObservedTFVariances)));

end