function corr = corrJDB(A,B)
% Author: Jason Buenrostro, Stanford University
% Calculate correlation of 2 vectors

% calculate
An=bsxfun(@minus,A,mean(A,1));
An=bsxfun(@times,An,1./sqrt(sum(An.^2,1)));
Bn=bsxfun(@minus,B,mean(B,1));
Bn=bsxfun(@times,Bn,1./sqrt(sum(Bn.^2,1)));
corr = sum(An.*Bn,1);

end
