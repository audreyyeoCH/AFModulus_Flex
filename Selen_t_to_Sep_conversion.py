#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 00:46:00 2021

@author: selenm
"""

import glob
import os
import matplotlib.pyplot as plt


#------------------------------------------------------------------------------
# Read data and generate the lists
#------------------------------------------------------------------------------

os.chdir(r'/Users/selenm/Documents/Computational Biology/AFModulus/AFModulus_Flex/F_vs_Sep_curves')
myFiles3 = sorted(glob.glob('*.txt'))


f=open(myFiles3[0],"r")
lines=f.readlines() 
Seperation=[]
Force=[]

for x in lines[1:]:
    Seperation.append(float(x.split('\t')[0]))  
    Force.append(float(x.split('\t')[1]))

f.close()

plt.plot(Seperation,Force)      #Plotting F vs Separation of approach curve
plt.xlabel('Sep (nm)')
plt.ylabel('F (pN)')
plt.show()

table=list(zip(t[0:128],Force,Seperation))  #Combine all the lists in one list

f = '{:<12}|{:<12}|{:<12}|'   # format

# Header for the corversion table
print('   t (ms)   |    F(pN)   |    Sep(nm)   ') 
print() 

for count,i in enumerate(table):
    print(f.format(*i)+str(count+1))  #Printing t, F, Z, and Sep
    

plt.plot(Seperation,Force)      #Plotting F vs Separation of approach curve
plt.xlabel('Sep (nm)')
plt.ylabel('F (pN)')
plt.show()