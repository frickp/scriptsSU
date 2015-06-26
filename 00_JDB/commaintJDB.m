function s = commaintJD(x)
% runs commaint on an array
for i = 1:length(x)
    s{i} = commaint(x(i));;
end
end