#!/usr/bin/env python
#This script is designed to automatically generate the primer barcode combinations for scATAC experiments
#Usage: MakeMiseqSampleSheetINFLUX.py -sc -i miseq -r 5 -c 7 -b 'PC9test'

import pandas as pd
import numpy as np
import datetime
import argparse
import sys

table=pd.read_csv('MiSeqSampleTemplate.txt',delimiter='\t',skiprows=19)
Barcodes=pd.read_csv('NexteraBarcodeInfo2.txt',delimiter='\t',index_col=0)


parser = argparse.ArgumentParser(description="Description: This script automatically generates Nextera sequencing primer combinations. **Note, Ad1MX is indexed as '0'")

if len(sys.argv)<2:
	print "need to add arguments!"
	print "type [scriptName.py] -h for documentation"
	quit()

parser.add_argument('--singleCell','-sc',help='True/False flag for if data is single-cell or not. Still need to add bulk ATAC functionality',action='store_true',required=True)
parser.add_argument('--instrument','-i',help='Enter *exact* name of Illumina instrument: "miseq" or "nextseq" ',required=True)
parser.add_argument('--rowNum','-r',help='Row number for ad1 (i5)',required=True)
parser.add_argument('--colNum','-c',help='Col number for ad2 (i7)',required=True)
parser.add_argument('--baseName','-b',help='Basename for cell names',required=True)
parser.add_argument('--saveDir','-s',help='directory to save the primer sheet to',default='./')
parser.add_argument('--fileName','-f',help='Name of primer sheet',default='PrimerSheet.csv')

args=parser.parse_args()

args.instrument=args.instrument.lower()
if args.instrument not in ['miseq', 'nextseq']:
	print "Make sure the instrument name exactly reads: 'miseq' or 'nextseq'"
	quit()

# I should make a note that Ad1MX is indexed as '0'

#ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))]['Name','Sequence'])
if args.instrument=='nextseq':
	ad1_dict=dict(Barcodes[(Barcodes.Orientation=='i5_ad1') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))])
	ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))])
else:
	ad1_dict=dict(Barcodes[(Barcodes.Orientation=='i5_ad1') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('MiSeq'))])
	ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('MiSeq'))])


# This is correctly formatted for ad2_i7
#colNum = 5 #Make this a variable to be read in by argparse
x  = []    #change x to ad1
x2 = []
x3 = []
for i in [i*12+int(args.colNum) for i in range(8)]:
    x.append(i)
    x2.append(ad2_dict['Sequence'].loc[i])
    x3.append(ad2_dict['Name'].loc[i])
x=x*12
x2=x2*12
x3=x3*12

# This is correctly formatted for ad1_i5
#RowNum = 5 #Make this a variable to be read in by argparse
y  = []
y2 = []
y3 = []
for i in [x+1 for x in range(8)]:
    for j in [x+1 for x in range(12)]:
        y.append(j+12*(int(args.rowNum)-1)) 
        y2.append(ad1_dict['Sequence'].loc[j+12*(int(args.rowNum)-1)])
        y3.append(ad1_dict['Name'].loc[j+12*(int(args.rowNum)-1)])

cols = ['Sample_ID','Sample_Name','Sample_Well','I7_Index_ID','index','I5_Index_ID','index2','Sample_Project','Description']
idx = [i +1 for i in range(96)]
sampleNames = [args.baseName + str(i + 1) for i in range(96)]

PrimerSheet=pd.DataFrame(columns=cols,index=idx)

PrimerSheet['Sample_ID']=sampleNames
PrimerSheet['I5_Index_ID']=y2
PrimerSheet['index']=y3
PrimerSheet['I7_Index_ID']=x2
PrimerSheet['index2']=x3

currDay = datetime.datetime.now().strftime("%Y%b%d")
fileName = 'PrimerSheet.csv'
PrimerSheet.to_csv(args.saveDir + currDay + fileName,index=False)




