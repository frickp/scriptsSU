#!/usr/bin/env python
# Code to find summary stats files within a defined list of subfolders

import sys
import os
import fnmatch
import pandas as pd

InFile = open(sys.argv[1],'r')

print InFile



for line in InFile:
	l = line.strip('\n')
#	if os.path.isdir(l):
#		print l + ' is a directory'
#	else:
#		print l + ' is not a directory'
	for x in os.listdir(l):
		if fnmatch.fnmatch(x,'*stats*'):
			print l + x	
		
#This is to try to 		
#a=pd.DataFrame.from_csv('4-30-GM-ATAC1-1_S19_L001_001.stats.log',sep='\t')
#a['ProperPairs'] = a['ProperPairs'].convert_objects(convert_numeric=True)


def getStats(f):
	a = pd.DataFrame.from_csv(f,sep='\t')
	a['ProperPairs'] = a['ProperPairs'].convert_objects(convert_numeric=True) #Make numeric
	chrs = ['chr'+str(i) for i in range(0,23)]
	#print 'chrs: ' + str(chrs)
	totReads = a.loc[chrs]['ProperPairs'].sum()
	#print 'TotReads = ' + str(totReads)
	mtReads	= a.loc['chrM']['ProperPairs'][:1]
	#print 'mtReads = ' + str(mtReads)
	mtPc	= mtReads/totReads
	return mtPc

print getStats('4-30-GM-ATAC1-1_S19_L001_001.stats.log')
	
#pd.DataFrame.to_csv(a,'testCSV')
#a.loc['chrM'][:1]['BadPairs:Raw']
#int(a.loc['chrM'][:1]['BadPairs:Raw'])
#b=['chr'+str(i) for i in range(1,23)]
#c=a.loc[b]['ProperPairs']
	
InFile.close() 