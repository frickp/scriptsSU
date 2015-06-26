% Author: Jason Buenrostro, Stanford University
% Add replication timing data

% load repliSeq
repli = readtext(inRepli);
cellCycMat = repli(:,4:end);
nanIdx = cell2mat(cellfun(@isstr,cellCycMat,'UniformOutput',0));
cellCycMat(nanIdx) = {0};
cellCycMat = cell2mat(cellCycMat);

% convert to common scale
clear cycle
for i = 1:length(cellCycMat)
    %disp(['Processing: ' i]);
    % assign vars
    y = cellCycMat(i,:);
    x = 0:.2:1.1;
    xfit = 0:.01:1;
    
    % do interpolation
    yfit = interp1(x,y,xfit,'spline');
    [tmp idx] = min(abs(yfit-max(yfit)));
    cycle(i,1) = xfit(idx);
    
    % plot product
    %plot(x,y,'x');hold on;plot(xfit,yfit,'r');plot(xfit(idx),yfit(idx),'k+');hold off
    %evalResponse = input('Press Enter');
end

% partition
cCycMat = zeros(length(cycle),6);
cCycMat(:,1) = cycle==0;
cCycMat(:,2) = cycle>0 & cycle<=.3;
cCycMat(:,3) = cycle>.3 & cycle<=.5;
cCycMat(:,4) = cycle>.5 & cycle<=.7;
cCycMat(:,5) = cycle>.7 & cycle<1;
cCycMat(:,6) = cycle==1;

% add to peakAssoc & TF labels
peakAssoc = [peakAssoc cCycMat];
TFlabels = [TFlabels' 'G1:RepliSeq' 'S1:RepliSeq' 'S2:RepliSeq' 'S3:RepliSeq' 'S4:RepliSeq' 'G2/M:RepliSeq']';
