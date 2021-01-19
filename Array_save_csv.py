#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 23:59:05 2021

@author: selenm
"""

# save numpy array as csv file
from numpy import asarray
from numpy import savetxt
# define data
data = asarray([F_r])
# save to csv file
savetxt('Fmax_idxs.csv', data, delimiter=',')




# load numpy array from csv file
from numpy import loadtxt
# load array
data2 = loadtxt('Fmax_idxs.csv', delimiter=',')
# print the array
#print(data)