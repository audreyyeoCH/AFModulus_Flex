## Research Question 2
# What is the starting point (touching point) (Astrid and Audrey)
# - output : from t vs F table, use conversion factor from (1)
# - fitting (linear interpolation)


## loading libraries
library(ggplot2)

## read file
df = read.delim("F_vs_t_curves/20200619_MG1655_OMV_Prot15_50uM_Colistin.005.pfc-4069_ForceCurveIndex_45647.spm - NanoScope Analysis_F_vs_t.txt")
names(df)

## first EDA
plot(df$ms, df$pN, pch = "0")

# whole graph raw data
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0,2))

# smooth loess trend
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0,2))

##  window interpolation

# starting point points
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0,0.8)) 

ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0.0,0.8)) 

# max
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_line(aes(x = ms, y = pN)) +
  scale_x_continuous(limits = c(0.8,1.08))
ggplot(df) +
  geom_jitter(aes(x = ms, y = pN)) +
  geom_smooth(aes(x = ms, y = pN), method = "loess", bin = 0.10) +
  scale_x_continuous(limits = c(0.8,1.08)) 

# intersection 
# first model 
class(df$ms)
dfmax = df[df$ms %in% 0.8:1.08,]
df$new = df$ms[df$ms ]
model1 = lm(pN ~ ms, data= dfmax)

model <- lm(y ~ x, data = mydf)