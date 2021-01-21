######################################################
# title: "AFModulus_Flex"
# author: "Selen Manioglu, Astrid Stubbusch, Audrey Yeo"
# date: "1/11/2021"
# script: ompute for all curves of 1 AFM experiment
######################################################


# clear workspace
rm(list = ls())


# load packages
library(tidyverse)
library(tibble)
library(zoo)

## Import example curve
Curve_name <-"AFModulus_Flex/F_vs_t_curves/20200619_.005.pfc-4069_ForceCurveIndex_45647.spm - NanoScope Analysis_F_vs_t.txt"
F_vs_t_curve1 <- read.table(Curve_name, 
                            quote="\"", 
                            header = T,
                            comment.char="", 
                            stringsAsFactors=FALSE)
F_vs_t_curve1 <- as_tibble(F_vs_t_curve1)

# import distance curve
Curve_Z <- "AFModulus_Flex/F_vs_Z_curves/20200619_.005.pfc-4069_ForceCurveIndex_45647.spm - NanoScope Analysis.txt"
F_vs_Z_curve <- read.table(Curve_Z, 
                           quote="\"", 
                           header = T,
                           comment.char="", 
                           stringsAsFactors=FALSE)


## Import all data
Experiment_name <-"Data_wholeExp.csv"


# as_data_frame() [in tibble package]
Experiment <- read.table(Experiment_name,
                            sep = ",",
                            header = F,
                            stringsAsFactors=FALSE)

#Experiment <- Experiment[1:256, 1:50] ## maller test set
Experiment <- as_tibble(Experiment)

# empty vector for results
Modulus_list <- vector()
Fmax_list <- vector()
d_list <- vector()

for (curve in c(1:ncol(Experiment))) {
  # build curves as we had before
  F_vs_t_curve1 <- data.frame(ms = F_vs_t_curve1$ms, Experiment[1:256, curve])
  F_vs_t_curve1 <- as_tibble(F_vs_t_curve1)
  colnames(F_vs_t_curve1) <- c("ms", "pN")
  
  # calc Fmax
  Fmax       <- max(F_vs_t_curve1$pN)
  Fmax_t     <- F_vs_t_curve1$ms[F_vs_t_curve1$pN == Fmax]
  Fmax_index <- which(F_vs_t_curve1$pN == Fmax)[1] # alternative: which.max(F_vs_t_curve1$pN)
  
  ## baseline
  Index_t_0.5 <- nrow(F_vs_t_curve1)/4  #index after 1st quarter
  Index_t_1.2 <- floor(1.2/2 * nrow(F_vs_t_curve1)) #index after 60%
  Index_t_1.5 <- 3/4 * nrow(F_vs_t_curve1) #index after 3 quarters
  Index_t_2.0 <- nrow(F_vs_t_curve1) #last index
  
  Force_base_values <- c( F_vs_t_curve1$pN[1 : Index_t_0.5], F_vs_t_curve1$pN[Index_t_1.5 : Index_t_2.0])
  Force_baseline <- mean(Force_base_values)
  
  # plot baseline values and baseline (red)
  Dataframe <- as.data.frame(cbind(1:(length(Force_base_values)), Force_base_values))
  colnames(Dataframe) <- c("index", "force")
  
  ## gradient 
  # curve to consider
  F_vs_t_gradient <- F_vs_t_curve1[Index_t_0.5 : Index_t_1.2, ]
  
  # calc best fitting positive slope
  Zoo_data <- zoo(F_vs_t_gradient)
  
  output <- zoo::rollapply(
    data = Zoo_data, 
    width = 8, 
    FUN = function(z) {
      lmfit <- lm(formula = pN ~ ms, data = as.data.frame(z))
      c(
        intercept = unname(lmfit$coefficients[1]),
        gradient = unname(lmfit$coefficients[2]),
        rsquared = summary(lmfit)$r.squared,
        meanms = mean(lmfit$model$ms)
      )
    },
    by.column = FALSE
  )
  
  # Filter only positive slopes
  output <- as.data.frame(output)
  output <- output[output$gradient > 0,]
  bestfit <- as.data.frame(output)[which.max(output$rsquared),]
  
  ## intersect
  # bestfit$gradient * x + bestfit$intercept = Force_baseline
  # x = (Force_baseline - bestfit$intercept)/ bestfit$gradient
  Contacting_point_t <- (Force_baseline - bestfit$intercept)/ bestfit$gradient
  Contacting_point_F <- bestfit$gradient * Contacting_point_t + bestfit$intercept 
  Contacting_point   <- as.data.frame(Contacting_point_t, Contacting_point_F)
  
  
  # calculate time steps between all measurements in F_vs_t_curve1
  Time_difference <- Fmax_t - Contacting_point_t
  Time_step <-  F_vs_t_curve1[2,1]
  Time_steps_in_d <- Time_difference / Time_step
  
  
  # Contacting_point_index
  Contacting_point_index <- unlist( Fmax_index - floor(Time_steps_in_d) )
  
  
  ## from Z curve 
  Distance_axis <- as.vector(F_vs_Z_curve['nm'])
  # read out delta from the distance array, using the index of Fmax-time and the index of contact-point-time
  d <- Distance_axis[Fmax_index, ] - Distance_axis[Contacting_point_index - 1, ] ## -1 to round down the contact point
  
  
  ## from inverted distan ce curve (estimation for separation curve)
  Distance_axis2 <- Distance_axis %>% map_df(rev)
  #Indexes <- nrow(F_vs_Z_curve)
  if (Contacting_point_index < 0 | Fmax_index < 0) {
    d2 <- NA # IF CALCULATION FAILED (NEG INDEX), then set to NA
  }
  else {
    d2 <- Distance_axis2[unname(Contacting_point_index) - 1, ] - Distance_axis2[Fmax_index, ]
  }
  
  
  
  ## calculate Young's modulus
  
  # Fmax & indentation depth d were computed above
  
  # Poisson’s ratio (typically 0.2-0.5)=0.3
  v <- 0.3
  
  # half angle of the indenter=18^0
  alpha <- 18 * pi/180 # convert from degree to radians
  
  delta <- d2 * 10^(-9) # in m
  F <- Fmax * 10^(-12) # in N
  
  # compute Young’s modulus
  E <- (F * pi * (1 - v^2)) / (2 * tan(alpha) * delta^2) * 10^(-6)
  
  # save modulus
  Modulus_list[curve] <- E
  Fmax_list[curve]    <- Fmax
  d_list[curve]       <- delta
  
}

# put together as dataframe
Experiment_results <- data.frame(E = unlist(Modulus_list), 
                                 Fmax = unlist(Fmax_list),
                                 d = unlist(Fmax_list)
                                 )


# save as R object
saveRDS(Experiment_results, "Data_wholeExp_E_Fmax_d.rds")

# save dataframe as .csv
write.csv(Experiment_results, "Data_wholeExp_E_Fmax_d.csv", row.names=FALSE)






### print as picture

### TOPOLOGY PICTURE
# import topology image as .csv file
Img_scaled <- read.csv("~/Documents/Zurich_PhD/courses/2021_01_11_Compulsory_LSZGS SysBio_Computational Biology/git_folder/AFModulus_Flex/Img_scaled.csv", 
                       header=FALSE)

Img_scaled_dims <- dim(Img_scaled)
min(Img_scaled)
max(Img_scaled)

df <- t(Img_scaled) # to flip image 

rows <- matrix(seq_len(nrow(df)), byrow = F, ncol = ncol(df), nrow = nrow(df))
cols <- matrix(seq_len(ncol(df)), byrow = T, ncol = ncol(df), nrow = nrow(df)) 

image_df <- as.data.frame(cbind( arrayInd(seq_along(as.matrix(df)), .dim = dim(df)), as.vector(as.matrix(df))))
#colnames(image_df) <- c("rows", "cols", "values")
colnames(image_df) <- c("x", "y", "value")

A <-  imager::as.cimg(obj = image_df,
                      v.name = "value", 
                      dims = c(Img_scaled_dims[1], Img_scaled_dims[2], 1, 1)) %>% 
                      #threshold(40) %>%
                      imager::renorm(min = 0, max = 255)# %>% # had to renormalize to see shapes better https://www.rdocumentation.org/packages/imager/versions/0.42.3/topics/renorm 
                      #plot
  
Topology_image <- ggplot(as.data.frame(A), aes(x,y)) + 
                  geom_raster(aes(fill=value)) +
                  scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0),trans=scales::reverse_trans()) +
                  scale_fill_gradient(low="black",high="white")
Topology_image

# save image
imager::save.image(im = A, file = "Topology_image.png", quality = 0.7)
write.csv(image_df, "Topology_image_asIndexedCol.csv", row.names=FALSE)

# histogram of intensities
hist(unlist(Img_scaled) )




### MODULUS PICTURE
#load(file = "Data_wholeExp_E_Fmax_d.rds")
Experiment_results <- read.csv("Data_wholeExp_E_Fmax_d.csv", 
                       header=T)

rows2 <- rep(seq_len(256), times = 256) #, byrow = F, ncol = 256, nrow = 256))
cols2 <- rep(seq_len(256), each = 256)

min(Experiment_results$E, na.rm = T)
max(Experiment_results$E, na.rm = T)


#image_df2 <- as.data.frame(cbind( arrayInd(seq_along(as.matrix(df)), .dim = dim(df)), as.vector(as.matrix(df))))
image_df2 <-  as.data.frame(cbind(x = cols2, y = rows2, value = Experiment_results$E))
colnames(image_df2) <- c("x", "y", "value")


# set Modulus values above 100 to 100
lower_threshold <- 15
upper_threshold <- 40
image_df2$value[image_df2$value < lower_threshold] <- 0
image_df2$value[image_df2$value > upper_threshold] <- upper_threshold


graphics.off()
B <- imager::as.cimg(obj = image_df2,
                     v.name = "value", 
                     dims = c(256, 256, 1, 1)) %>% 
                     imager::mirror("y") # %>%
                     #imager::threshold(30) %>% # setting all values below a threshold to 0, all above to 1. 
                     #imager::renorm(min = 0, max = 255) %>% # had to renormalize to see shapes better https://www.rdocumentation.org/packages/imager/versions/0.42.3/topics/renorm 
                     #plot
  
Modulus_image <- ggplot(as.data.frame(B), aes(x,y)) + 
                 geom_raster(aes(fill=value)) +
                 scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0),trans=scales::reverse_trans()) +
                 scale_fill_gradient(low="black",high="white")
Modulus_image 

# save image
imager::save.image(im = B, file = "Modulus_image.png", quality = 0.7)
write.csv(image_df2, "Modulus_image_asIndexedCol.csv", row.names=FALSE)

# histogram of intensities
#hist(unlist(Modulus_image[Modulus_image<80 & Modulus_image>50]) )
hist(unlist(B))


