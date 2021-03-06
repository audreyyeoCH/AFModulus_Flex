######################################
###### Astrid and Audrey's loop ######
######################################
# this file is based on code from "From_Topology_to_Stiffness.Rmd"

# load packages
library(tidyverse)
library(cowplot)
library(gridExtra)

# load and list files
# soft code
# set working directory for both
PATH = paste(getwd())
Curve_name = list.files("F_vs_t_curves/")
Curve_name = paste0("F_vs_t_curves/",Curve_name, sep ="")
# Curve_name[1] #test, this works

## Creating seven data frames
for (i in 1:7) {assign(paste("F_vs_t_curve",i, sep = ""), 
       read.table(Curve_name[i], header = TRUE))}
##
df = list(F_vs_t_curve1, F_vs_t_curve2,F_vs_t_curve3, F_vs_t_curve4 ,F_vs_t_curve5, F_vs_t_curve6, F_vs_t_curve7 )

## Creating seven raw plots of data points
for (i in 1:7) {
  assign( paste0("raw", i, sep = ""), 
  ggplot(data = df[[i]], 
         aes(ms, y = pN)) +
  geom_point() +
  geom_line() +
  ggtitle("") +
  labs(
    x = "Time [ms]",
    y = "Force [pN]") )
}
# this is a check and this works
ggplot(data = df[[1]], 
       aes(ms, y = pN)) +
  geom_point() +
  geom_line() +
  ggtitle("") +
  labs(
    x = "Time [ms]",
    y = "Force [pN]")
ggplot(data = df[[1]], 
       aes(ms, y = pN)) +
  geom_point() +
  geom_line() +
  ggtitle("") +
  labs(
    x = "Time [ms]",
    y = "Force [pN]")

# these plots already saved on git
# plot_grid(raw1, raw2, raw3, raw4, raw5, raw6, raw7, align = "h") 

for (i in 1:7) {
## Extract **maximal force (F max)** from each graph
  Fmax       <- data.frame(max(df[[i]]$pN))
  Fmax_t     <- data.matrix(df[[i]]$ms[df[[i]]$pN == Fmax[i]]) # does not work
  Fmax_index <- data.frame(which.max(df[[i]]$pN)) # alternative: 
}


# for (i in 1:7) {
#   ## Extract **maximal force (F max)** from each graph
#   Fmax       <- as.vector(c(max(df[[i]]$pN)))
# }

## baseline
Index_t_0.5 <- nrow(df[[i]])/4  #index after 1st quarter
Index_t_1.2 <- floor(1.2/2 * nrow(df[[i]])) #index after 60%
Index_t_1.5 <- 3/4 * nrow(df[[i]]) #index after 3 quarters
Index_t_2.0 <- nrow(df[[i]]) #last index

Force_base_values <- c( df[[i]]$pN[1 : Index_t_0.5], df[[i]]$pN[Index_t_1.5 : Index_t_2.0])
Force_baseline <- mean(Force_base_values)

# plot baseline values and baseline (red)
Dataframe <- as.data.frame(cbind(1:(length(Force_base_values)), Force_base_values))
colnames(Dataframe) <- c("index", "force")
ggplot(data = Dataframe, mapping = aes(x = index, y = force )) +
  geom_point() +
  geom_line() +
  geom_abline(slope = 0, intercept = Force_baseline, colour = "red", lwd = 1.5) +
  ggtitle(Curve_name) +
  labs(
    x = "Time [ms]",
    y = "Force [pN]"
  )



## gradient 
# curve to consider
F_vs_t_gradient <- df[[i]][Index_t_0.5 : Index_t_1.2, ]

# calc best fitting positive slope
library(zoo)
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

# plot
ggplot(data = df[[i]], mapping = aes(x = ms, y = pN)) +
  geom_point() +
  geom_line() +
  geom_abline(intercept = bestfit$intercept, slope = bestfit$gradient, colour = "blue", lwd = 1.5) +
  ggtitle(Curve_name) +
  labs(
    x = "Time [ms]",
    y = "Force [pN]"
  )


## intersect
# bestfit$gradient * x + bestfit$intercept = Force_baseline
# x = (Force_baseline - bestfit$intercept)/ bestfit$gradient
Contacting_point_t <- (Force_baseline - bestfit$intercept)/ bestfit$gradient
Contacting_point_F <- bestfit$gradient * Contacting_point_t + bestfit$intercept 
Contacting_point   <- as.data.frame(Contacting_point_t, Contacting_point_F)

# plot
ggplot(data = df[[i]], mapping = aes(x = ms, y = pN)) +
  geom_point() +
  geom_line() +
  geom_abline(slope = 0, intercept = Force_baseline, colour = "red", lwd = 1.5) +
  geom_abline(intercept = bestfit$intercept, slope = bestfit$gradient, colour = "blue", lwd = 1.5) +
  geom_point(data = Contacting_point, mapping = (aes(x = Contacting_point_t, y = Contacting_point_F, colour = "orange"))) +
  ggtitle(Curve_name) +
  labs(
    x = "Time [ms]",
    y = "Force [pN]"
  )


df = df[[i]]
p1 <- ggplot(df[1:150,]) +
  geom_line(aes(x = ms, y = pN)) +
  labs(x = "Time [ms]",
       y = "Force [pN]") + 
  coord_cartesian(xlim=c(0.0, 1.2), ylim = c(-30,150)) +
  scale_x_continuous(limits = c(0,2), breaks= seq(0,1.2,0.2)) +
  scale_y_continuous(limits = c(-30, 150), breaks = seq(-30, 150,50)) + theme_gray()

load("dflong.RData")
p2 <- ggplot(dflong) +
  geom_line(aes(ms, pN, colour = type)) +
  coord_cartesian(xlim=c(0.0, 1.2), ylim = c(-30,150)) +
  scale_x_continuous(limits = c(0,2), breaks= seq(0,1.2,0.2)) +
  scale_y_continuous(limits = c(-30, 150), breaks = seq(-30, 150,50)) +
  labs(x = "Time [ms]",
       y = "Force [pN]") + theme_gray() +
  theme(legend.position = "none")

plot_grid(p1, p2, labels = "auto", ncol = 1) 


#The intersection with a linear and parabola fit is 0.835 ms and 0 pN
ggplot(dflong) +
  geom_line(aes(ms, pN, colour = type)) +
  coord_cartesian(xlim=c(0.8, 1.2), ylim = c(-30,150)) +
  scale_x_continuous(limits = c(0.8,2), breaks= seq(0.8,1.2,0.03)) +
  scale_y_continuous(limits = c(-30, 150), breaks = seq(-30, 150,10)) +
  geom_vline(xintercept = 0.835, colour = "pink", linetype = "dotted")+
  labs(x = "Time [ms]",
       y = "Force [pN]")



# calculate time steps between all measurements in df[[i]]
Time_difference <- Fmax_t - Contacting_point_t
Time_step <-  df[[i]][2,1]
Time_steps_in_d <- Time_difference / Time_step

# Fmax_index  already known

# calculate time steps between all measurements in F_vs_t_curve1
Time_difference <- Fmax_t - Contacting_point_t
Time_step <-  F_vs_t_curve1[2,1]
Time_steps_in_d <- Time_difference / Time_step

# Fmax_index  already known

# Contacting_point_index
Contacting_point_index <- unlist( Fmax_index - floor(Time_steps_in_d) )

# import distance array
Curve_Z <- "AFModulus_Flex/F_vs_Z_curves/20200619_.005.pfc-4069_ForceCurveIndex_45647.spm - NanoScope Analysis.txt"
F_vs_Z_curve <- read.table(Curve_Z, 
                           quote="\"", 
                           header = T,
                           comment.char="", 
                           stringsAsFactors=FALSE)
Distance_axis <- as.vector(F_vs_Z_curve['nm'])

# read out delta from the distance array, using the index of Fmax-time and the index of contact-point-time
d <- Distance_axis[Fmax_index, ] - Distance_axis[Contacting_point_index, ]

## Compute **modulus (= stiffness, E)** for each pixel from F-max and d


# Fmax & indentation depth d were computed above

# Poisson’s ratio (typically 0.2-0.5)=0.3
v <- 0.3

# half angle of the indenter=18^0
alpha <- 180

# compute Young’s modulus
E <- (Fmax * pi * (1 - v^2)) / (2 * tan(alpha) * d^2)
