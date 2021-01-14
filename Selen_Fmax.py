#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 12 20:37:56 2021

@author: selenm
"""

import glob
import os
#import numpy as np


os.chdir(r'/Users/selenm/Documents/Python_test/Selen_Manioglu_CodeClinic_File/F_vs_t_curves')
myFiles = glob.glob('*.txt')
#print(myFiles)

f=open(myFiles[1],"r")
lines=f.readlines() 
F=[]       
t=[]
for x in lines[1:]:
    t.append(float(x.split('\t')[0]))
    F.append(float(x.split('\t')[1]))
f.close()

max_value = max(F)
max_index = F.index(max_value)+1

print ('The maximum F value is '+str(max_value)+' pN and its index is '+str(max_index)+'.')
print ('The time value at maximum F value is '+str(t[max_index])+' ms.')

#The maximum F value is 149.9152 pN and its index is 127.
#The time value at maximum F value is 0.9921881 ms.