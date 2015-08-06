function normVar = calculateNormVarBoot1sample(temp,output)%(deviationMatrix,expectedVarPerTFandCell)%,subSample)
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

%% sample 2
% sample2
cellNum2 = size(output.(output.ctrlCond).normalizedDeviationMatrix,2);
idxperm2 = datasample(1:cellNum2,cellNum2-20,'Replace',true);
deviationMatrixSub2 = output.(output.ctrlCond).normalizedDeviationMatrix(:,idxperm2);
expectedVarPerTFandCellSub2 = output.(output.ctrlCond).expectedVarPerTFandCell(:,idxperm2);

% calculate 
expVarSum = sum(expectedVarPerTFandCellSub2, 2);

% calculate
normVarTemp = sum(((deviationMatrixSub2.*(sqrt(expectedVarPerTFandCellSub2))).^2)');
normVar2 = sqrt(normVarTemp./expVarSum');

%% difference
normVar = normVar2-normVar1;

end