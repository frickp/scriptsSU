#!/usr/bin/env python


import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pylab as plt
import os
import re
#import magic
#%matplotlib inline

myPath='/raid/Tn5_chromatin/150624_Peter_Jason_Sarah_MiSeq/plf-libs/'
os.chdir(myPath)

f2 = [i for i in os.listdir(myPath) if os.path.isdir(i)]
f2 = filter(lambda x:re.search(r'PC9', x), f2) #Only keep dirs that contain "PC9"

print "single-cell directories found:"
print f2

print "total libraries are: " + str(len(f2))

print "testing a single single cell directory"
scBam = [i for i in os.listdir(f2[0]) if "flt.bam" in i and "bai" not in i]
scBam = ''.join(scBam)
print "single-cell bam is ... " + scBam

#print os.listdir(f2[0])

import pysam
import matplotlib.pyplot as plt

scPath = f2[0]
scFile = scPath + "/" + scBam

#samfile = pysam.AlignmentFile("/Users/frickpl/Desktop/Data/First_C1/PC9.sc.mergeAll.bam", "rb")

mergedBam = "PC9.sc.mergeAll.bam"
#samfile = pysam.AlignmentFile(scBam, "rb")
samfile = pysam.AlignmentFile(scFile, "rb")
print "\nProcessing " + scBam + " ..."

#First, define the genome region to match the scATAC-seq paper
chrLoc = {'ch': 'chr19', 'start': 36192000 , 'end': 36242000}
groupNum = 50
groupSize = (chrLoc['end']-chrLoc['start'])/groupNum
groups = range(chrLoc['start'],chrLoc['end'],groupSize)

df = pd.DataFrame()

for j in f2:
	scPath = j    
	scBam = [i for i in os.listdir(scPath) if "flt.bam" in i and "bai" not in i]
	scBam = ''.join(scBam)
#	print "single-cell bam is ... " + scBam
	scFile = scPath + "/" + scBam
#	print "single-cell file is ..." + scFile
	
	samfile = pysam.AlignmentFile(scFile, "rb")
	scReads = []
	for i in groups:
		readCount=0
	        for reads in samfile.fetch('chr19',i,i + groupSize):
	        	readCount = readCount + 1
	        scReads.append(readCount)                         
	df[scPath]=pd.Series(scReads)
#	print scReads


#This code works for a single-cell library
#scReads = []
#for i in groups:
#	readCount=0
#	for reads in samfile.fetch('chr19',i,i + groupSize):
#		readCount = readCount + 1
#	scReads.append(readCount)
#print scReads
 
#for i in groups:
    #print [i , i + groupSize]
    #readCount=0
    #for reads in samfile.fetch('chr19',i,i + groupSize):
    #    readCount = readCount + 1
    #print readCount
    
#df = pd.DataFrame()
#df[scPath]=pd.Series(scReads)
#print pd.Series(scReads)

#df[scPath]=pd.Series(scReads)

#df.append(pd.Series(scReads),ignore_index=True)
print "The data frame is..."
print df

plt.pcolor(df)
plt.show()
