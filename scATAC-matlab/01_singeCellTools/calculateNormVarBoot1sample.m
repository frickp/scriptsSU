function normVar = calculateNormVarBoot1sample(temp,output)
% Author: Jason Buenrostro, Stanford University
% Calculates normalized variances

deviationMatrix = output.normalizedDeviationMatrix;
expectedVarPerTFandCell = output.expectedVarPerTFandCell;

% sample1
cellNum = size(deviationMatrix,2);
idxperm = datasample(1:cellNum,cellNum,'Replace',true);

% calculate
expVarSum = sum(expectedVarPerTFandCell(:,idxperm), 2);
normVarTemp = sum(((deviationMatrix(:,idxperm).*(sqrt(expectedVarPerTFandCell(:,idxperm)))).^2)');
normVar = sqrt(normVarTemp./expVarSum');

end


