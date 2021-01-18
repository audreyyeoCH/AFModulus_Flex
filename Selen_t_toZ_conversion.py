#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 13 16:51:46 2021

@author: selenm
"""

import glob
import os
import matplotlib.pyplot as plt
import numpy as np


#------------------------------------------------------------------------------
# Read data and generate the lists
#------------------------------------------------------------------------------

os.chdir(r'/Users/selenm/Documents/Computational Biology/AFModulus/AFModulus_Flex/F_vs_Z_curves')
myFiles2 = sorted(glob.glob('*.txt'))


f=open(myFiles2[0],"r")
lines=f.readlines() 
Z=[]
F=[]

for x in lines[1:]:
    Z.append(float(x.split('\t')[0]))  
    F.append(float(x.split('\t')[1]))
f.close()

Sep= Z[::-1]

#------------------------------------------------------------------------------
# Plot F vs Z and Sep. curves
#------------------------------------------------------------------------------

plt.plot(Z,F)      #Plotting F vs Z of approach curve
plt.xlabel('Z (nm)')
plt.ylabel('F (pN)')
plt.show()


plt.plot(Sep,F)      #Plotting F vs Separation of approach curve
plt.xlabel('Sep (nm)')
plt.ylabel('F (pN)')
plt.show()

#------------------------------------------------------------------------------
# Print lists of t, F, Z, and Sep
#------------------------------------------------------------------------------

table=list(zip(t[0:128],F,Sep,Z))  #Combine all the lists in one list

f = '{:<13}|{:<13}|{:<13}|{:<13}|'   # format

# Header for the corversion table
print('   t (ms)    |    F(pN)    |    Sep(nm)  |    Z(nm)    |') 
print() 

for count,i in enumerate(table):
    print(f.format(*i)+str(count+1))  #Printing t, F, Z, and Sep
    
    
#------------------------------------------------------------------------------
# Print step difference list of t, Z, and Sep
#------------------------------------------------------------------------------   
    
table2=list(zip(np.diff(t[0:128]),np.diff(Sep),np.diff(Z)))  #Combine all the lists in one list
f2 = '{:<22}|{:<22}|{:<22}|'   # format

# Header for the corversion table
print('        t (ms)        |       Sep(nm)        |          Z(nm)       |') 
print() 

for count,i in enumerate(table2):
#    print (i)
    print(f2.format(*i))  #Printing t, F, Z, and Sep
    
    