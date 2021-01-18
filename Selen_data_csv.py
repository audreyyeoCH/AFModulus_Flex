#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 00:46:15 2021

@author: selenm
"""


import csv
import numpy as np

fil_name = 'Data_exp1'
#example = np.zeros((2,3,4))
x = x.tolist()
with open(fil_name+'.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerows(x)

with open(fil_name+'.csv', 'r') as f:
  reader = csv.reader(f)
  examples = list(reader)


#print(examples)
nwexamples = []
for row in examples:
    nwrow = []
    for r in row:
        nwrow.append(eval(r))
    nwexamples.append(nwrow)