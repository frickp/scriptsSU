% Author: Jason Buenrostro, Stanford University
% Plot enrichment

% plot enrichment
h1 = figure('name','h1');
scatter(log10(sampleStruct.('Field_Lib_Size')(expt)),sampleStruct.('Field_Pk_rate')(expt)*100,20,sampleStruct.('Field_Mean_iSize')(expt),'filled');%caxis([0, 2])
%text(log10(sampleStruct.('Field_Lib_Size')),sampleStruct.('Field_Pk_rate'),sampleStruct.('Field_Name'))
xlabel('log10 Library Size');ylabel('% reads in Peaks');

%%
h2 = figure('name','h2');
x = log10(sampleStruct.('Field_Lib_Size')(expt));
y = sampleStruct.('Field_Pk_rate')(expt)*100;
idx0 = find(sampleStruct.('Field_cellNum')(expt)==0);
idx1 = find(sampleStruct.('Field_cellNum')(expt)==1);
idx2 = find(sampleStruct.('Field_cellNum')(expt)>1);
idxDead = find(sampleStruct.('Field_dead')(expt)==1);
%idxNotes = strfindJDB('NaN',sampleStruct.('Field_Notes')(expt))==0;
scatter(x(idx1),y(idx1),20,[.5 .5 .5],'filled');hold on
scatter(x(idx0),y(idx0),20,[0 0 1],'filled');hold on
scatter(x(idx2),y(idx2),20,[0 .8 0],'filled');
scatter(x(idxDead),y(idxDead),20,[1 0 0],'filled');
% scatter(x(idxNotes),y(idxNotes),20,[0 1 1],'filled');
legend('Single cell','Empty well','Two cells','Dead cell');legend('boxoff')

% axis
set(gca,'xtick',0:10)
xlabel('log10(Library size, reads)');ylabel('% Filtered reads in peaks');

% set line
%ylim([0 60]);
%xlim([1 ceil(max(log10(sampleStruct.('Field_Lib_Size'))))])
%xlim(get(gca,'XLim'));ylim(get(gca,'YLim'))
line([log10(minLibSize),log10(minLibSize)],[max(get(gca,'YLim')),0],'color','k','LineStyle','--');
line([max(get(gca,'XLim')),0],[minPkRate*100,minPkRate*100],'color','k','LineStyle','--')
%xlim([2 ceil(max(log10(sampleStruct.('Field_Lib_Size'))))])
xlim([1.5 5])

%printFig('Pub',1)

%% Reads per element
% define parems
spVal = 0.025;
rVals = 0:spVal:2;
c1 = [0.75,0.75,0.75];c2 = [0.,0.,0.];
pfData = singlesPeaks(d2,:);
meanPfData = mean(pfData,1);

% hist in chrom values
h3 = figure('name','h3');
[f,x] = hist(meanPfData,rVals); x=x(f>0);f=f(f>0);
%h3 = bar(x,f/trapz(x,f)*spVal,'linewidth',.01,'EdgeColor',c2,'FaceColor',c1,'Barwidth',1);hold on
h3 = bar(x,f,'linewidth',.01,'EdgeColor',c2,'FaceColor',c1,'Barwidth',1);hold on
xlabel('Average reads per element for each cell');
ylabel('Count')
xlim([-.02 .75]);
%ylim([0 .32]);
%x = ksdensity(meanPfData);plot(y,x./(sum(x)))

% draw median line
yRange = get(gca,'ylim');
line([mean(pfData(:)) mean(pfData(:))], [yRange(1) yRange(2)],'LineWidth',.5,'Color','k','LineStyle','--');

% legend
readsPerElement = sprintf('%.2f',median(mean(pfData(:))));
legend(h3,[readsPerElement,' reads'],'Location','NorthEast');
legend boxoff

%printFig('Pub',1)

%% mito rate
h0 = figure('name','h0');
ksdensity(sampleStruct.('Field_MT_rate')(d2))
xlabel('MTrate');ylabel('Density');
