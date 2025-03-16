library(dplyr)
library(tidyr)
library(tibble)
library(lme4)
library(MASS)
library(DHARMa)
library(ggplot2)#cite
library(car)
library(vegan) #cite
library(lubridate)


### 1. Decomposition experiment: how does treatment affect mass loss of dung?####
#specifically we want to know if pyrantel-treated and ivermectin dung has a lower decomposition rate than the control

#load in data
deco<-read.csv("Decomposition experiment.csv", header=TRUE )

View(deco)
#first check data by looking at the histogram

hist(deco$MassDifference) #looks like gaussian

plot<-boxplot(MassDifference~Treatment, data=deco,
              xlab="Treatment", ylab="MassDifference (g)",las=1,
              col=(c("green","red","gray", "blue")))
plot

#for our first question we exclude the Meshbag control samples by creating a subset
deco1<-subset(deco, Treatment != "Mesh bag control")
#we use ANOVA (in function glm) to test for significant differences between treatments; our independent variable is Mass Difference
m1<-glm(MassDifference~Treatment, data=deco1)
anova(m1, test="Chisq")
summary(m1) #there is no significant difference between treatments

plot<-boxplot(MassDifference~Treatment, data=deco1,
              xlab="Treatment", ylab="MassDifference (g)",las=1,
              col=(c("green","red", "blue")))
plot
#the second question is if dung in winter is actually being decomposed by animals.
#we therefore check for differences between dung control and dung control in meshbag
#we again create a subset only containing control and mesh bag control
deco2<-subset(deco, Treatment == "Mesh bag control" |Treatment == "Control")
#we then use a unpaired t-test to check for differences (anova is only used when comparing 3 or more means)
t.test(MassDifference~Treatment, paired=FALSE, data=deco2) 
#there is no difference between controls in meshab and withourt mesh bag; 
#we can conclude that animals do not play a part in decomposition of horse dung in winter!

plot<-boxplot(MassDifference~Treatment, data=deco2,
              xlab="Treatment", ylab="MassDifference (g)",las=1,
              col=(c("green","gray")))
plot

# as the ivermectin sample placed on the filed later than pyrantel we exclude ivermection from analysis
deco3<-subset(deco, Treatment =="Control"|Treatment == "Pyrantel")
m2<-glm(MassDifference~Treatment, data=deco3)
anova(m2, test="Chisq")
summary(m2)

plot<-boxplot(MassDifference~Treatment, data=deco3,
              xlab="Treatment", ylab="MassDifference (g)",las=1,
              col=(c("green","gray", "blue")))
plot

