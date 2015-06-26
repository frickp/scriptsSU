function printFig(varargin)
% Author: Jason Buenrostro, Stanford University
% Creates publication quality figures

% Example: printFig('Pub',1)

% defaults
time=clock;
outName = [num2str(time(1,1)) num2str(time(1,2)) num2str(time(1,3)) '_' num2str(time(1,4)) num2str(time(1,5)) '_' num2str(ceil(time(6)))];

% get options
p = inputParser;
p.addOptional('pub',0,@isscalar);
p.addOptional('dim',[4.25;3.5],@ismatrix);
p.addOptional('outName',outName,@isstr);
p.addOptional('box','off',@isstr);
p.addOptional('pdf',1,@isscalar);
p.parse(varargin{:})

% get parems
pub = p.Results.pub;
outName = p.Results.outName;
boxOnOff = p.Results.box;
dim = p.Results.dim;
pdf = p.Results.pdf;

% beautify figure
scale = 3;
set(gca,'XTickMode','manual','XLimMode','manual');
set(gca,'YTickMode','manual','YLimMode','manual');
set(gcf,'paperunits', 'centimeters', 'paperposition', [0 0 dim(1)*scale dim(2)*scale])

temp=findall(gcf);
for i = 1:length(temp);
    try;set(temp(i),'FontName','Helvetica','TickDir','out','color','none','Box',boxOnOff,...
            'FontSize',12,'LineWidth',1,'xcolor',[0 0 0],'ycolor',[0 0 0]);
    catch;end
end

% rescale if fore publication
if pub == 1
    scale = 1;
    set(gca, 'FontSize',5);
    set(gca, 'LineWidth',0.5);
    temp=findall(gcf);for i = 1:length(temp);try;set(temp(i),'FontSize',5);catch;end;end
    %temp=findall(gcf);for i = 1:length(temp);try;set(temp(i),'MarkerSize',1.25);catch;end;end
    temp=findall(gcf);for i = 1:length(temp);try;set(temp(i),'LineWidth',0.5);catch;end;end
    set(get(gca,'xlabel'),'fontsize',5,'LineWidth',.5)
    set(get(gca,'ylabel'),'fontsize',5,'LineWidth',.5)
    set(gcf, 'paperunits', 'centimeters', 'paperposition', [0 0 dim(1)*scale dim(2)*scale])
end

% print
if pdf == 1
    %set(gcf, 'PaperPositionMode', 'auto');
    final = [outName '.pdf'];
    print('-dpdf', final)
else
    final = [outName '.eps'];
    print('-depsc2', final)    
end
disp(['Figure printed to: ' final])

end

