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
class(df$ms)
dfmax = df[100:150,]
model1 = lm(pN ~ ms, data= dfmax)
summary(model1)
c = coef(model1)[1]
m = coef(model1)[2]
x = seq(0.80, 1.14, 0.02)
y = m*x+c
plot(x,y)
# second model with the max
lm(pN ~ poly(ms, 2, raw = TRUE), data = dfmax)

f1 <- approxfun(dfmax$ms, dfmax$pN)

# first model with the starting point
dfmin = df[0:99,]
model2 = lm(pN ~ ms, data= dfmin)
summary(model2)
c = coef(model1)[1]
m = coef(model1)[2]
x = seq(0, 0.08, 0.01)
y = m*x+c
plot(x,y)
model2 %>% predict(dfmin) -> y
dfstart = data.frame()

#> max(df$pN)
# [1] 149.9152
# which.max(df$pN == max(149.9152))
# df$ms[127]
# [1] 0.9843756

min(df$ms[120:127])
min(df$pN[110:127])

y = ax^2 + bx + c



