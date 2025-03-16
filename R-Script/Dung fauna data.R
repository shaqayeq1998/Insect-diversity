rm(list = ls())
#setwd("C:/Users/eitzingen/Documents/Work/RPTU_Research/Dung and Antiparasitics/MSc Thesis Shaghayegh")
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
############################################################

### 2. Diversity experiment: how does treatment affect diversity, richness and abundance of animals in dung?####
#load in data
div<-read.csv("Diversity Experiment.csv",  header=TRUE)
View(div)

#first check data by looking at the histogram
hist(div$TotalAbundance)#looks like a neg binomial distribution 
hist(div$SpeciesRichness)



#we use ANOVA (in function glm) to test for significant differences between treatments; and total abundance
m1<-glm(TotalAbundance~Treatment, data=div)
anova(m1, test="Chisq")
summary(m1) #there is no significant difference between treatments

#so ivermectin samples may not be comparable to pyrantel and the control as these have been applied earlier.
#lets create a subset of the data and exclude the ivermectin samples

div1<-subset(div, Treatment != "Ivermectin")
#we then use a unpaired t-test to check for differences
t.test(TotalAbundance~Treatment, paired=FALSE, data=div1) 
#there is no difference between control and pyrantel

#test for differences in species richnes
t.test(SpeciesRichness~Treatment, paired=FALSE, data=div1) 
#there is no difference between control and pyrantel

#to create a barplot graph we need a new file which needs to be created first

graphdata <- read.csv("dung animal abundance.csv", header = TRUE)

graph <- ggplot(graphdata, aes(x=Species, y=Mean.abundance, fill=Treatment)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual("Treatment", values = c("Control" = "green", "Pyrantel" = "blue", "Ivermectin" = "red")) +
  geom_errorbar(aes(ymin = pmax(Mean.abundance - SD, 0), ymax = Mean.abundance + SD), 
                width = 0.1, position = position_dodge(0.9)) +
  theme_classic() +
  ggtitle("") + 
  ylab("Mean number dung arthropod individuals") +
  expand_limits(y = c(0, 10)) +
  theme(legend.position = c(0.9, 0.8)) +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.3)) +
  theme(text = element_text(size = 13)) +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 9, b = 0, l = 0))) +
  theme(axis.title.x.top = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)))

plot(graph)



############################
# treatment vs shannon diversity

Shannondiversity <- read.csv("Shannon diversity.csv", header = TRUE)
view(Shannondiversity)

Shannondiversity2<-subset(Shannondiversity, Treatment != "Ivermectin")
#t test between sahanon divestiy index and treatment of control and pyrantel
t.test(Shannon.Diversity.Index~Treatment, paired=FALSE, data=Shannondiversity2) 

#differrnce in collembola number between treatments
'm0<-glm(Collembola~Treatment, data=Shannondiversity)
anova(m0, test="Chisq")
summary(m0)

# residual check for collembola number between treatments
sim<-simulateResiduals(m0, n=1000, refit=F, integerResponse=NULL)
plot(sim)' #we actually just want to compare pyrantel with contriol, so we di#o not care about potntial ptoblems here


t.test(Collembola~Treatment, paired=FALSE, data=Shannondiversity2)
view(Shannondiversity2)

plot<-boxplot(Collembola~Treatment, data=Shannondiversity,
              xlab="Treatment", ylab="Mean Number of Collembola Individuals",las=1,
              col=(c("green", "red", "blue")))
plot
#difference in Dipterlarv number between treatments
'm1<-glm(DipteraLarv~Treatment, data=Shannondiversity)
anova(m1, test="Chisq")
summary(m1)'

t.test(DipteraLarv~Treatment, paired=FALSE, data=Shannondiversity2)

plot<-boxplot(DipteraLarv~Treatment, data=Shannondiversity,
            xlab="Treatment", ylab="Mean Number of Diptera larvae Individuals",las=1,
            col=(c("green", "red", "blue")))
plot

# difference in Gamsida number  between treatmets
'm2<-glm(Gamasida~Treatment, data=Shannondiversity)
anova(m2, test="Chisq")
summary(m2)'

t.test(Gamasida~Treatment, paired=FALSE, data=Shannondiversity2)

plot<-boxplot(Gamasida~Treatment, data=Shannondiversity,
              xlab="Treatment", ylab="Mean Number of Gamasida Individuals",las=1,
              col=(c("green", "red", "blue")))
plot
#################################################################################

#residual check for Dipter number between treatments
'sim<-simulateResiduals(m1, n=1000, refit=F, integerResponse=NULL)
plot(sim)

#residual check for Gamsida number between treatments
sim<-simulateResiduals(m2, n=1000, refit=F, integerResponse=NULL)
plot(sim)'


#############################
#simple linear regression of treatment shannon diversity
# this code was used before by excluding ivermectin
'm1<-glm(overall.abandance~Treatment, data=Shannondiversity)
anova(m1, test="Chisq")
summary(m1)


#checking the residuals of model m1
sim<-simulateResiduals(m1, n=1000, refit=F, integerResponse=NULL)
plot(sim)

m2<-glm(Shannon.Diversity.Index~Treatment, data=Shannondiversity)
anova(m2, test="Chisq")
summary(m2)

#checking the residuals of model m2
sim<-simulateResiduals(m2, n=1000, refit=F, integerResponse=NULL)
plot(sim)

#this code was used by excluding ivermectin
m3<-glm(species.richness~Treatment, data=Shannondiversity)
anova(m3, test="Chisq")
summary(m3)

#checking the residuals of model m2
sim<-simulateResiduals(m3, n=1000, refit=F, integerResponse=NULL)
plot(sim)'
##############################

#NMDS and permanova
#select spices matrix
comdata <- Shannondiversity[,3:11] # community data matrix with spicies 
comdata
set.seed(12345678)  
nmds <- metaMDS (comdata, dist="bray", k=3, maxit=999)
stressplot(nmds)
vegan:::scores.metaMDS(nmds)
data.scores= as.data.frame(scores(nmds)$sites)

#add column of treatment to dataframe
data.scores$Treatment=Shannondiversity$Treatment
head(data.scores)
str(data.scores)
nmds$stress


#now plot NMDS
p<- ggplot(data = data.scores, aes(x=NMDS1, y=NMDS2) )+ geom_point(size=3, aes(color=Treatment), position = position_jitter(.1))+ 
  scale_shape_manual(values=c(0,15, 1,16 , 2,17))+
  stat_ellipse(aes(fill=Treatment), alpha=.2, type = 't', linewidth=1, geom="polygon", show.legend = FALSE)+
  theme_minimal()+
  labs(color="Treatment") 
plot(p)



#######


#for a correct analysis we want to kick out data from ivermectin
comdata2 <- Shannondiversity2[,3:11]

#calculate permanova using function adonis
adon.results<- adonis2(comdata2~Shannondiversity2$Treatment, method="euclidean", perm=999)
print(adon.results)

###########################################################################################################



