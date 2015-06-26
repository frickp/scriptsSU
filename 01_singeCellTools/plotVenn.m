function plotVenn(TFvennAssoc,var,TF1label,TF2label)

% plot venn
vals = sum(TFvennAssoc);
label = {sprintf([TF1label '\nn=' commaint(vals(1)) '\n' num2str(var(1)) ]);...
    sprintf([TF2label '\nn=' commaint(vals(2)) '\n' num2str(var(2)) ]);...
    sprintf(['Overlap\nn=' commaint(vals(3)) '\n' num2str(var(3)) ])};

%Now label each zone
figure;
[H,S] = venn(vals,'Plot', 'off');

% plot venn
minColor = 1;maxColor = 4;
colorbar();caxis([minColor maxColor])
cmap = colormap(colorsJDB('color','solar_rojos'));hold on

% alt
% minColor = -.8;maxColor = +.8;
% colorbar();caxis([minColor maxColor])
% cmap = colormap(colorsJDB('color','solar_rojos'));hold on

% get 3 colors
[tmp c1] = min(abs(var(1)-linspace(minColor,maxColor,size(cmap,1))));
[tmp c2] = min(abs(var(2)-linspace(minColor,maxColor,size(cmap,1))));
[tmp c3] = min(abs(var(3)-linspace(minColor,maxColor,size(cmap,1))));

% assign variables
N=100;
center1 = S.Position(1,:);
center2 = S.Position(2,:);
r1 = S.Radius(1);
r2 = S.Radius(2);

% plot
THETA=linspace(0,2*pi,N);
RHO1=ones(1,N)*r1;
RHO2=ones(1,N)*r2;
[X1,Y1] = pol2cart(THETA,RHO1);
[X2,Y2] = pol2cart(THETA,RHO2);
X1=X1+center1(1);Y1=Y1+center1(2);
X2=X2+center2(1);Y2=Y2+center2(2);

% plot
h=fill(X1,Y1,cmap(c1,:));hold on
h=fill(X2,Y2,cmap(c2,:));hold on

% fill intersection
[x,y]=intersections(X1,Y1,X2,Y2,0);
idx1 = find(X1>x(1));
idx2 = find(X2<x(1));
[a,b1] = max(diff(idx1));
[a,b2] = max(diff(idx2));
if b1>1;idx1 = [idx1(b1+1:end) idx1(1:b1)];end
if b2>1;idx2 = [idx2(b2+1:end) idx2(1:b2)];end

test1 = [X1(idx1) X2(idx2)];
test2 = [Y1(idx1) Y2(idx2)];
fill(test1,test2,cmap(c3,:));hold off
axis tight;axis equal

% label
for i = 1:length(vals)
    text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), label(i))
end

% make pretty
axis off

end