function corrMat = corrJDBv2(data,corrMat)
% Author: Jason Buenrostro, Stanford University
% Calculate correlation matrix of data

%corrMat = zeros(size(fltCounts,1),size(fltCounts,1));
matSize = size(data,2);
temp1 = repmat(1,1,matSize);
temp2 = 1:matSize;

% get self-correlation
for i = 1:matSize
    corrMat(i,:) = corrJDB(data(:,temp1*i),data(:,temp2));
end
end