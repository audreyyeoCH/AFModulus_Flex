#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 00:46:02 2021

@author: selenm
"""

from scipy.stats import norm
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import numpy as np



x = np.reshape(Force_arguments['Curves'], (Force_arguments['Line'],Force_arguments['Line'],Force_arguments['Pixels'])).T

F=np.zeros((256, 256))
F_val=np.zeros((256, 256))
for i in range(0,256):  #Moves in x-axis direction
    for j in range(0,256): #Moves in y-axis direction
        F_val[i,j]=np.max(x[:,i,j])+1
        F[i,j]=np.argmax(x[:,i,j])+1
        
F_r=b = F.ravel()


(mu, sigma) = norm.fit(F_r)
n, bins, patches = plt.hist(F_r, 150, normed=1, facecolor='green', alpha=0.75)
# add a 'best fit' line
y = mlab.normpdf( bins, mu, sigma)
l = plt.plot(bins, y, 'r--', linewidth=2)

#plot
plt.xlabel('Index number')
plt.ylabel('Counts')
plt.xlim((110,140))
plt.title(r'$\mathrm{Histogram\ of\ F_{max}\ indexes:}\ \mu=%.3f,\ \sigma=%.3f$' %(mu, sigma))
plt.grid(True)

plt.show()