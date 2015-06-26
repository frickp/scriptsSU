% Author: Jason Buenrostro, Stanford University
% Cluster single-cells
clear; clc; close all
addpath(genpath('/Users/jbuenros/Documents/MATLAB/bin'));
addpath(genpath('/Volumes/jbuenros/Documents/MATLAB/bin'));

try;load('CollectedData.mat');output;catch;end

% K562
% cellType='K562';in1='K562_singlesData_20141216.mat'; % first 3 reps
% inMotifs='K562_motif_20141016.mat';
% inBias='K562_seq_bias.mat';
% inChIP = 'K562_chip_20141016.mat';

% inHistone = 'K562_histone_20141215.mat';
% inRepli='K562_RepliSeq.bed';
% cellType='K562_full';in1='K562_singlesData_20141130.mat'; % all 6 reps
% cellType='K562_full';in1='K562_singlesData_ALL_20141201.mat'; % all data
% inSuper = 'K562_super_20141215.mat';
% inDenovo='K562_denovo_20141208.mat';
% inGC='GC_bias_K562.bed';
% inRepeats='K562_repeats_20141215.bed';
% inPC = 'K562_singlesData_20150210.PCassoc.mat';

%K562 w CNV
% cellType='K562wCNV';
% in1='K562_singlesData_20150406.wCNV.mat'; % first 3 reps
% inMotifs='K562_motif_20150406.wCNV.mat';
% inBias='K562_seq_bias.wCNV.mat';
% inChIP = 'K562_chip_20150406.wCNV.mat';

% K562 all peaks for looping
% cellType='K562_all';
% in1='K562_singlesData_20150323.allFull.mat';
% inMotifs='K562_motif_20150323.allFull.mat';
% inRepli='K562_RepliSeq.allFull.bed';
% inBias='K562_seq_bias.allFull.mat';

% GM12878
% cellType='GM';in1='GM_singlesData_20141022.mat';
% inMotifs='GM_motif_20141018.mat';
% inHistone= 'GM_histone_20141215.mat';
% inRepli='GM_RepliSeq.bed';
% inBias='GM_seq_bias.mat';
% inDenovo='GM_denovo_20141208.mat';
% inChIP='GM_chip_20141015.mat';
% inSuper = 'GM_super_20141215.mat';
% inRepeats='GM_repeats_20141215.bed';
%cellType='GM_nucs'; inNucBins='GM_NFKB.nucOverlap.bed';

% GM12878 all peaks for looping
% cellType='GM_all';
% in1='GM_singlesData_20141211.all.mat';
% inMotifs='GM_chip_20141211.all.mat';
% inRepli='GM_RepliSeq.all.bed';
% inBias='GM_seq_bias.all.mat';

% H1ESCs
% cellType = 'H1ESC';
% in1='H1ESC_singlesData_20141016.mat';
% inMotifs='H1ESC_motif_20141016.mat';
% inChIP='H1ESC_chip_20141016.mat';
% inHistone = 'H1ESC_histone_20141215.mat';
% inBias='H1ESC_seq_bias.mat';
% inSuper = 'H1ESC_super_20141215.mat';
% inDenovo='H1ESC_denovo_20141208.mat';
% inRepeats = 'H1ESC_repeats_20141215.bed';

% Tier1 mix
% cellType = 'Tier1Mix';
% in1 = 'Tier1Mix_singlesData_20141201.mat';
% inMotifs = 'Tier1Mix_motif_20141201.mat';
% inBias = 'Tier1Mix_seq_bias.mat';

% mESCs narrow
% cellType = 'mESC';
% %in1='mESC_singlesData_20141202.mat'; % all data
% in1='mESC_singlesData_20150111.mat'; % just 2i
% %in1='mESC_singlesData_20150111.ser.mat'; % just 2nd serum, publication
% inMotifs='mESC_motif_20141016.mat';
% inBias='mESC_seq_bias.mat';
% inDenovo='mESC_denovo_20141208.mat';
% inRepeats = 'repeats.bed';
% inMethyl = 'mESC_methyl_20150224.mat'

% TF1
% cellType='TF1';
% in1 = 'TF1_singlesData_20141205.mat';
% inMotifs='TF1_motif_20141016.mat';
% inBias='TF1_seq_bias.mat';
% inDenovo='TF1_denovo_20141208.mat';

% HL60
% cellType='HL60';
% in1='HL60_singlesData_20141016.mat';
% inMotifs='HL60_motif_20141018.mat';
% inBias='HL60_seq_bias.mat';
% inDenovo='HL60_denovo_20141208.mat';

% BJ
% cellType='BJ';
% in1='BJ_singlesData_20141016.mat';
% inMotifs='BJ_motif_20141016.mat';
% inBias='BJ_seq_bias.mat';
%inRepli='BJ_RepliSeq.bed';
% inDenovo='BJ_denovo_20141208.mat';

% EML
% cellType='EML';
% in1='EML_singlesData_20141126.mat';
% inMotifs='EML_motif_20141126.mat';
% inBias='EML_seq_bias.mat';
% inDenovo = 'EML_denovo_20141208.mat';

% SU070 Leuk
% cellType='SU070'
% %in1='SU070_singlesData_20141128.mat'
% in1='SU070_singlesData_20141211.mat'
% inMotifs='SU070_motif_20141128.mat'
% inDenovo = 'SU070_denovo_20141208.mat';
% inBias='SU070_seq_bias.mat'
% inPC = 'SU070_singlesData_20150210.PCassoc.mat';

% SU048 Leuk
% cellType='SU048'
% in1='SU048_singlesData_20141128.mat'
% inMotifs='SU048_motif_20141128.mat'
% inDenovo = 'SU048_denovo_20141208.mat';
% inBias='SU048_seq_bias.mat'

% MEP
% cellType = 'MEP'
% in1 = 'MEP_singlesData_20141205.mat';
% inMotifs = 'MEP_motif_20141205.mat';
% inDenovo = 'MEP_denovo_20141208.mat';
% inBias = 'MEP_seq_bias.mat';
% inPC = 'MEP_singlesData_20150210.PCassoc.mat';

% mDC
cellType = 'mDC'
%in1 = 'mDC_singlesData_20150425.mat';
in1 = 'mDC_singlesData_20150507.mat';
inMotifs = 'mDC_motif_20150425.mat';
inDenovo = 'mDC_denovo_20150425.mat';
inBias = 'mDC_seq_bias.mat';

% load data
load(in1)
load(inMotifs)

% make PeakAssoc into logic array
peakAssoc = sparse(logical(peakAssoc));

% get data labels
TFlabels = strcat(dataHeaders(:,1),':motif');
sampleAnnoHeader = sampleAnno(1,1:end);
%sampleAnno = sampleAnno(2:end,:);

% resort cells
clear idx idxE; j = 1; k = 1;
for i = 1:size(sampleAnno,1)
    try;
        idx(j) = find(strcmp(sampleHeaders(:),sampleAnno(i,1))==1);j=j+1;
        idxE(i) = 1;
    catch;
        idxE(i) = 0;
        disp(['Error finding: ' sampleAnno(i,1)])
    end
end

% reassign
singlesPeaks = singlesPeaks(idx,:);
sampleHeaders = sampleHeaders(idx);
sampleAnno = sampleAnno(logical(idxE),:);

% get rid of NA's
sampleAnno(strcmp('NA',sampleAnno))=cellstr(num2str(NaN));

% load sample annotations
sampleStruct = {};
for i = 1:length(sampleAnnoHeader)  %%%%%%%%% double counting TSSs
    try;
        %sampleStruct.(['Field_' sampleAnnoHeader{i}]) = cellfun(@str2num,sampleAnno(:,i));
        sampleStruct.(['Field_' strrep(sampleAnnoHeader{i},'-','_')]) = cellfun(@str2num,sampleAnno(:,i));
    catch;
        %sampleStruct.(['Field_' sampleAnnoHeader{i}]) = sampleAnno(:,i);
        sampleStruct.(['Field_' strrep(sampleAnnoHeader{i},'-','_')]) = sampleAnno(:,i);
    end
end
Rds_Pks = sum(singlesPeaks,2);
sampleStruct.('Field_Pk_rate') = Rds_Pks./(sampleStruct.Field_Final_frags+1);

%%%% Add bias scores %%%%
if exist('inBias');
    disp('Adding Tn5 Bias')
    run ./m12_addBias.m;
end

%% add additional associations
%%%% Add denovo %%%%
if exist('inDenovo');
    disp('Adding denovo motifs')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inDenovo,'Denovo');
end

%%%% Add ChIP %%%%
if exist('inChIP');
    disp('Adding ChIP')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inChIP,'ChIP');
end

%%%% Add Histone %%%%
if exist('inHistone');
    disp('Adding histone ChIP')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inHistone,'Histone');
end

%%%% Add Super Enhancers %%%%
if exist('inSuper');
    disp('Adding super enhancers')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inSuper,'Super');
end

%%%% Add PC info %%%%
if exist('inPC');
    disp('Adding PCs')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inPC,'PC');
end

%%%% Add methyl info %%%%
if exist('inMethyl');
    disp('Adding methyl')
    [peakAssoc,TFlabels] = addAssociations(peakAssoc,bed,TFlabels,inMethyl,'methyl');
end

%%%% Add annotations %%%%
run ./m07_addAnnotations.m;

%%%% Add Repli-Seq %%%%
if exist('inRepli');
    disp('Adding repliseq')
    run ./m01_addRepliSeq.m;
end

%%%% Add bias scores %%%%
if exist('inGC');
    disp('Adding GC Bias')
    run ./m13_addGCBias.m;
end

% remove extra info from TF labels
TFlabels = strrep(TFlabels,'wgEncodeAwgTfbsSydh','');TFlabels = strrep(TFlabels,'Pk','');
TFlabels = strrep(TFlabels,'wgEncodeSydhTfbs','');
TFlabels = strrep(TFlabels,'wgEncodeBroadHistone','');TFlabels = strrep(TFlabels,'.broadPeak.gz','');
TFlabels = strrep(TFlabels,'K562','');
TFlabels = strrep(TFlabels,'GM12878','');TFlabels
disp('Done...')

%% filter cells
% cell filter parems: read num, cell count, TSS enrichment
%minLibSize = 10000;
minLibSize = 500  %%%%%%%%%%% way less stringent  
minPkRate = .15;
d2 =sampleStruct.('Field_Lib_Size')>minLibSize & sampleStruct.('Field_Pk_rate') > minPkRate & sampleStruct.('Field_cellNum') == 1;
%d2 = d2 & expt;
disp(['Number of cells: ' num2str(sum(d2))])

% find problem regions
subplot(1,2,1);hist(sum(singlesPeaks));set(gca,'yscale','log')
ab0 = find(sum(singlesPeaks(d2,:),1)>0);
d3 = sum(singlesPeaks(d2,:),1) < exp(mean(log(sum(singlesPeaks(d2,ab0),1)))+mad(log(sum(singlesPeaks(d2,ab0),1)))*5);
subplot(1,2,2);hist(sum(singlesPeaks(:,d3)));set(gca,'yscale','log')

% filters to set
d1 = full(sum(peakAssoc,1)'>10);
%d1 = full(sum(peakAssoc,1)'>0);
%d1 = strfindJDB('GCbias',TFlabels)
filteredTFlabels = TFlabels(d1);
filteredBed = bed(d3,:);
filteredData = singlesPeaks(d2,d3);
filteredPeakAssoc = logical(peakAssoc(d3,d1));
filteredSampleHeaders = sampleHeaders(d2);
filteredBias = exp(bias.signal(d3));
disp('Done...')

%%%% Plot enrichments %%%%
%expt = 1:length(filteredSampleHeaders);
expt = strfindJDB('150428',sampleHeaders);
%run m03_plotEnrichment.m

%%
% rewrite celltype var
%cellType = 'mESC_2i'
%cellType = 'K562_nobiasmodel';filteredBias = ones(size(filteredBias));
%cellType = DC_;

%%%% TF variance %%%%
[output.(cellType) shuffled.(cellType)] = calculateTFVariance(filteredData,filteredPeakAssoc,filteredBias,sum(singlesPeaks(:,d3),1));

% save results
output.(cellType).filteredTFlabels = filteredTFlabels;
output.(cellType).filteredSampleHeaders = filteredSampleHeaders;
output.(cellType).filteredData = filteredData;
output.(cellType).filteredPeakAssoc = filteredPeakAssoc;
output.(cellType).filteredBias = filteredBias;
output.(cellType).filteredBed = filteredBed;

try;save('CollectedData.mat','output','-append');save('CollectedData.mat','shuffled','-append')
catch;save('CollectedData.mat','output','-v7');save('CollectedData.mat','shuffled','-v7');end
disp('Done...')

% saveOutput = output.(cellType);saveShuffled=shuffled.(cellType);
% save([cellType '.mat'],'saveOutput','-v7');save([cellType '.mat'],'saveShuffled','-append');disp([cellType '.mat'])

%% build background model for calculating drug variance
%%%% Build bg model %%%%
[model] = calculateBackground(filteredData,filteredPeakAssoc,filteredBias,sum(singlesPeaks(:,d3),1));

