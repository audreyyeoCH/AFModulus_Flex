#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 00:50:01 2021

@author: selenm
"""


import numpy as np
import math  

alf=18  #Half-tip angle
v=0.3   #Poisson ratio
ind=3.7*(1e-9) #Indentation depth in m
F=149.9152*(1e-12) #Force in N
E=F*np.pi*(1-v**2)/(2*math.tan(np.pi/10)*(ind**2))*1e-6 #Modulus in MPa=1e+6 Pa