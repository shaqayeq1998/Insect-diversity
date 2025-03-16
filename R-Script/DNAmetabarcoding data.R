#### analysis of genetic data of dung samples#####

rm(list = ls())

library(ggplot2)
library(vegan)
##################################


#load in data

genanal<-read.csv("DNAanalysis.csv", header=TRUE )
View(genanal)

#1. NMDS and permanova####
comdatagen <- genanal[,5:15] # community data matrix with order names only; we do not have balanced design (replicate number of control, P and I differ massively)

set.seed(12345678)  
nmds <- metaMDS (comdatagen, dist="jaccard", k=3, maxit=999)  #first warning probably insufficient data
stressplot(nmds) #looks bad
vegan:::scores.metaMDS(nmds)
data.scores= as.data.frame(scores(nmds)$sites) # :(

#add column of treatment to dataframe
data.scores$treatment=genanal$treatment

#now plot NMDS
p<- ggplot(data = data.scores, aes(x=NMDS1, y=NMDS2) )+ geom_point(size=3, aes(color=treatment), position = position_jitter(.1))+ 
  scale_shape_manual(values=c(0,15, 1,16 , 2,17))+
  stat_ellipse(aes(fill=treatment), alpha=.2, type = 't', linewidth=1, geom="polygon", show.legend = FALSE)+
  theme_minimal()+
  labs(color="treatment") 
plot(p)  #doesnt look good, data insufficient for proper NMDS analysis


#calculate permanova using function adonis2
adon.results<- adonis2(comdatagen~genanal$treatment, by="margin", method="euclidean", perm=999)
print(adon.results) # no warning but apparently no effect of treatment on community composition

#2. Linear model of species/order richness ####

#do we find a effect of treatment and week on species richness?
m1<-glm(Speciesrichness~treatment*week, data=genanal)
anova(m1, test="Chisq") #there is both a effect of treatment and time (week) and the interaction (*) of both variables!

library(ggplot2)
p<-ggplot(data = genanal, aes(x = factor(week), y = Speciesrichness, fill = treatment)) +
  geom_boxplot() +
  labs(x = "Week", y = "Species Richness", title = "Species Richness by Week and Treatment") +
  theme_minimal()
plot(p)
