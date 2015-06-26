function normVar = calculateNormVar(deviationMatrix,expectedVarPerTFandCell)
% Author: Jason Buenrostro, Stanford University
% Calculates normalized variances

% calculate 
expVarSum = sum(expectedVarPerTFandCell, 2);

% calculate
normVarTemp = sum(((deviationMatrix.*(sqrt(expectedVarPerTFandCell))).^2)');
normVar = sqrt(normVarTemp./expVarSum');
end