#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 00:46:02 2021

@author: selenm
"""

import numpy as np
import matplotlib.pyplot as plt


x = np.reshape(Force_arguments['Curves'], (Force_arguments['Line'],Force_arguments['Line'],Force_arguments['Pixels'])).T

F=np.zeros((256, 256))
F_val=np.zeros((256, 256))
for i in range(0,256):  #Moves in x-axis direction
    for j in range(0,256): #Moves in y-axis direction
        F_val[i,j]=np.max(x[:,i,j])+1
        F[i,j]=np.argmax(x[:,i,j])+1
        
F_r=b = F.ravel()


num_bins = 150
n, bins, patches = plt.hist(F_r, num_bins, facecolor='blue', alpha=0.5)
plt.xlim((110,140))
plt.xlabel('Index number')
plt.ylabel('Counts')
plt.show()