function normVar = calculateNormVarBoot(temp,output)%(deviationMatrix,expectedVarPerTFandCell)%,subSample)
% Author: Jason Buenrostro, Stanford University
% Calculates error

% sample
cellNum1 = size(output.normalizedDeviationMatrix,2);
idxperm1 = datasample(1:cellNum1,cellNum1-20,'Replace',true);
deviationMatrixSub1 = output.normalizedDeviationMatrix(:,idxperm1);
expectedVarPerTFandCellSub1 = output.expectedVarPerTFandCell(:,idxperm1);

% calculate 
expVarSum = sum(expectedVarPerTFandCellSub1, 2);

% calculate
normVarTemp = sum(((deviationMatrixSub1.*(sqrt(expectedVarPerTFandCellSub1))).^2)');
normVar = sqrt(normVarTemp./expVarSum');

end