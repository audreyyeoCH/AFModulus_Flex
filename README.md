# AFModulus_Flex
A Biophysics Flex : Calculating Modulus from AFM data (Atomic force microscopy). 

#Background

#Research questions

1. What is transformation of Z to t and vice versa (Selen)
output : table conversion 
2. What is the starting point (touching point) (Astrid and Audrey)
	- output : from t vs F table, use conversion factor from (1)
	- fitting (linear interpolation) 
3. What is the maximum point (what is the middle’s (x and y) 95% CI, is x always at 128 as time index ) (Selen)
	- output : from t vs F table, use conversion factor from (1), y val, x val = index (time stamp)
	- fitting and histogram

#Method :

1. Image is reflected in an array of dimension 256 x 256, each cell is a pixel which has also 256 values of Force and distance (indentation dept), two component of the Young's Modulus. Two parameters are interest are the Force (in pN), that is the peak Force and contact point, both in pN. 
2. The peak Force and contact point are two variables plotted on an x and y axis. Two linear curves are fitted on the "approach" phase and on the contact point phase. The intersection is the estimate of the contact point. The maximum point of the contact point phase is the estimate of the contact point.
3. (2) is performed for the 256x256 array in (1), whereby 256 estimates of Young's Modulus represents each pixel.
4. The Young's Modulus in (3) expressed in an intensity image on a surface of a vesicule with a fat bubble.


#Results

1. The result intended is an intensity image reflecting the Young's Modulus of an image of a surface of a vesicule with a fat bubble. 

#Conclusion
