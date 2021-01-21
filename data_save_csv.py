#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 20 15:01:22 2021

@author: selenm
"""
import csv
import numpy as np


test = np.array([[1,1,1,1,1],[1,2,3,4,5],[6,10,8,0,9]])

predictions=np.zeros((256,65536), dtype=float)
t=[]
#for count in range (65536+1):
for i in range(0,256):  #Moves in x-axis direction
    for j in range(0,256): #Moves in y-axis direction
        predictions[:,i*256+j]=x[:,i,j].astype(np.float)



#print(*test.flatten(), sep=', ')

#', '.join([str(lst[0]) for lst in predictions])


fil_name = 'Test'
with open(fil_name+'.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerows(predictions)
