#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 19 14:21:11 2021

@author: selenm
"""


import numpy as np
import matplotlib.pyplot as plt
from PIL import Image


# load numpy array from csv file
from numpy import loadtxt
# load array
img_arr = loadtxt('Img_scaled.csv', delimiter=',')
# print the array
#print(data)


#------------------------------------------------------------------------------
# Show the image array in grayscale color
#------------------------------------------------------------------------------

#img = Image.fromarray(np.uint8(img_arr * 255) , 'L')
#img.show()

#img = Image.fromarray(np.uint8(img_arr) , 'L')
#img.show()


#------------------------------------------------------------------------------
# Show the image array as an intensity map
#------------------------------------------------------------------------------


fig, ax = plt.subplots()

im = ax.imshow(img_arr)
plt.colorbar(im, ax=ax)

plt.show()
