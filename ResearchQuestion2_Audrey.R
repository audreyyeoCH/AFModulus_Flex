## Research Question 2
# What is the starting point (touching point) (Astrid and Audrey)
# - output : from t vs F table, use conversion factor from (1)
# - fitting (linear interpolation)


## loading libraries
library(ggplot2)
library(tidyverse)

## read file
df = read.delim("F_vs_t_curves/20200619_MG1655_OMV_Prot15_50uM_Colistin.005.pfc-4069_ForceCurveIndex_45647.spm - NanoScope Analysis_F_vs_t.txt")
names(df)

## first EDA
# whole graph raw data
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0,2), breaks= seq(0,2,0.2)) +
  scale_y_continuous(limits = c(-28, 150), breaks = seq(-25, 160,10)) +
  geom_vline(xintercept = df$ms[127], colour = "pink") +
  geom_hline(yintercept = df$pN[127], colour = "lightblue") +
  labs(title = "Plot of raw data including maximum point noted")

# smooth loess trend
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0,2)) +
  geom_vline(xintercept = df$ms[127], colour = "pink") +
  geom_hline(yintercept = df$pN[127], colour = "lightblue") +
labs(title = "Plot of raw data and general loess trend with standard error")


##  window interpolation
# starting point points
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0,0.8), breaks= seq(0,0.8,0.05)) +
  scale_y_continuous(limits = c(-28, 150), breaks = seq(-28, 150,10))

ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0.0,0.8), breaks= seq(0,0.8,0.05)) 

# max
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0.8,1.14), breaks= seq(0.8,1.15,0.02)) +
  geom_vline(xintercept = 0.9843756, colour = "pink") +
  geom_hline(yintercept = 149, colour = "pink")

ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0.8,1.14), breaks= seq(0.8,1.15,0.02)) +
  geom_vline(xintercept = 0.9843756, colour = "pink") +
  geom_hline(yintercept = 149, colour = "pink") 

ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0.8,1.14), breaks= seq(0.8,1.15,0.02)) +
  geom_vline(xintercept = 0.9843756, colour = "pink") 
locator()
# Find coefficients for intersection 
# source also http://www.sthda.com/english/articles/40-regression-analysis/162-nonlinear-regression-essentials-in-r-polynomial-and-spline-regression-models/
# intersection https://stackoverflow.com/questions/34248347/r-locate-intersection-of-two-curves
# first model the max
dfmax = df[100:150,]
dfstart = df[0:99,]
plot(dfmax)
plot(dfstart)

f1 <- approxfun(dfmax$ms, dfmax$pN)
f2 <- approxfun(dfstart$ms, dfstart$pN)
plot(f1)
plot(f2)


modelmax = lm(pN ~ ms+ms^2, data= dfmax)
modelstart = lm(pN ~ ms, data= dfstart)

# max
coef(modelmax)
HARRIS = data.frame(ms = seq(0.80, 1.14, 0.02),
pN = predict(modelmax, list(Time=ms, Time2=ms^2)))

pNp = predict(modelmax, list(Time=ms, Time2=ms^2))
#predictedcounts <- predict(quadratic.model,)
plot(ms, pNp, pch=16, xlab = "Time (s)", ylab = "Counts", cex.lab = 1.3, col = "blue")

lines(ms, pNp, col = "darkgreen", lwd = 3)
plot(HARRIS$ms, HARRIS$pN)

v_max = mean(HARRIS$pN)

KAMALA = data.frame(ms = seq(0, 0.8, 0.01),
pN = coef(modelstart)[1] + coef(modelstart)[2]*ms)
v_start = mean(y)
predict(modelstart, newdata = KAMALA)

ggplot(KAMALA) +
  geom_line(aes(ms, pN))

ggplot(HARRIS) +
  geom_line(aes(ms, pN))


# This is the intersection
intersect = optimize(function(t0) abs(f1(t0) - v_start), interval = range(dfmax$ms))

time = intersect[1]
Force = intersect[2]

#> max(df$pN)
# [1] 149.9152
# which.max(df$pN == max(149.9152))
# df$ms[127]
# [1] 0.9843756

# min(df$ms[120:127])
# min(df$pN[110:127])

ggplot(df[0:150,]) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0,2), breaks= seq(0,1.2,0.2)) +
  scale_y_continuous(limits = c(-28, 150), breaks = seq(-25, 160,10)) +
  geom_vline(xintercept = df$ms[127], colour = "pink") +
  geom_hline(yintercept = df$pN[127], colour = "lightblue") +
  labs(title = "Plot of raw data including maximum point noted") +
  geom_hline(yintercept = v_start, colour = "blue") +
  geom_line(aes(x,y))

ggplot(df) +
  geom_line(aes(x,y))
