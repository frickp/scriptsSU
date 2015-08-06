
# coding: utf-8

# In[76]:

#This script is designed to automatically generate the primer barcode combinations for scATAC experiments

import pandas as pd
import numpy as np
import datetime
table=pd.read_csv('MiSeqSampleTemplate.txt',delimiter='\t',skiprows=19)
Barcodes=pd.read_csv('NexteraBarcodeInfo2.txt',delimiter='\t',index_col=0)


# In[77]:

#Barcodes.head()


# In[78]:

#Barcodes[(Barcodes.Name=='N502') & (Barcodes.Instrument=='MiSeq')]


# In[79]:

# I need to pull in variables from the user using argparse. What I need are the following
# version (v1 or v2)
# instrument (Miseq or NextSeq)
# Ad1Number (Row#)
# Ad2Number (Col#)
# I should make a note that Ad1MX is indexed as '0'


# In[80]:

#If single-cell (generate dictionaries of primers):
#ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))]['Sequence'])
#ad1_dict=dict(Barcodes[(Barcodes.Orientation=='i5_ad1') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))]['Sequence'])
#The top two work...

#ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))]['Name','Sequence'])
ad1_dict=dict(Barcodes[(Barcodes.Orientation=='i5_ad1') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))])
ad2_dict=dict(Barcodes[(Barcodes.Orientation=='i7_ad2') & (Barcodes.Version=='v2') & (Barcodes['Instrument'].str.contains('NextSeq'))])


# In[81]:

#ad1_dict['Sequence'].loc[5]


# In[82]:

#Index by string finding
#Barcodes[Barcodes['Instrument'].str.contains('NextSeq')]


# In[83]:

#Preliminary code combined into working code segment below
#b=[i*12+1 for i in range(8)]
#x=[]
#for i in b:
#    x.append(a[i])
#print x


# In[84]:

# This is correctly formatted for ad2_i7
colNum = 5 #Make this a variable to be read in by argparse
x  = []    #change x to ad1
x2 = []
x3 = []
for i in [i*12+colNum for i in range(8)]:
    x.append(i)
    x2.append(ad2_dict['Sequence'].loc[i])
    x3.append(ad2_dict['Name'].loc[i])
x=x*12
x2=x2*12
x3=x3*12
#print x
#print type(x)
#print len (x)
#print x2
#print x3

#ad1_dict['Sequence'].loc[5]


# In[85]:

# This is correctly formatted for ad1_i5
RowNum = 5 #Make this a variable to be read in by argparse
y  = []
y2 = []
y3 = []
for i in [x+1 for x in range(8)]:
    for j in [x+1 for x in range(12)]:
        y.append(j+12*(RowNum-1)) 
        y2.append(ad1_dict['Sequence'].loc[j+12*(RowNum-1)])
        y3.append(ad1_dict['Name'].loc[j+12*(RowNum-1)])
#print y
#print type(y)
#print len(y)
#print y2
#print y3

#ad1_dict['Sequence'].loc[5]


# In[86]:

# Now I need to figure out how to take x2 and y2 and put them in a new dataframe
# Make the indexing column the same as the one from 
#d = pd.DataFrame(data='index')


# In[87]:

#Barcodes.index.values


# In[88]:

CommonName = 'CellID-'
cols = ['Sample_ID','Sample_Name','Sample_Well','I7_Index_ID','index','I5_Index_ID','index2','Sample_Project','Description']
idx = [i +1 for i in range(96)]
sampleNames = [CommonName+str(i + 1) for i in range(96)]


# In[89]:

PrimerSheet=pd.DataFrame(columns=cols,index=idx)

#PrimerSheet.head()


# In[90]:

PrimerSheet['Sample_ID']=sampleNames
PrimerSheet['I5_Index_ID']=y2
PrimerSheet['index']=y3
PrimerSheet['I7_Index_ID']=x2
PrimerSheet['index2']=x3
#PrimerSheet.head()


# In[91]:

#I think that all that's left is to interface the script with argparse!!


# In[92]:

currDay = datetime.datetime.now().strftime("%Y%b%d")
saveDir='./'
fileName='PrimerSheet.csv'
#print saveDir + fileName
PrimerSheet.to_csv(saveDir + currDay + fileName,index=False)


# In[ ]:



