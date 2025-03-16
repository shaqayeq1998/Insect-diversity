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
#####################################################################################

#soil animal data analysis
div2<-read.csv("soil animals data.csv",  header=TRUE)
View(div2)

#first check data by looking at the histogram
hist(div2$overall.abandance)#looks like a neg binomial distribution 
hist(div2$species.richness)

#so ivermectin samples may not be comparable to pyrantel and the control as these have been applied earlier.
#lets create a subset of the data and exclude the ivermectin samples

div3<-subset(div2, Treatment != "Ivermectin")
#we then use a unpaired t-test to check for differences
t.test(overall.abandance~Treatment, paired=FALSE, data=div3) 
#there is no difference between control and pyrantel

#test for differences in species richnes
t.test(species.richness~Treatment, paired=FALSE, data=div3) 
#there is no difference between control and pyrantel

#to create a barplot graph we need a new file which needs to be created first


graphdata <- read.csv("soil animal abundance.csv", header=TRUE)

graph <- ggplot(graphdata, aes(x = Species, y = Mean.abundance, fill = Treatment)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual("Treatment", values = c("Control" = "green", "Pyrantel" = "blue", "Ivermectin" = "red")) +
  geom_errorbar(aes(ymin = pmax(0, Mean.abundance - SD), ymax = Mean.abundance + SD),  # Ensures ymin is not negative
                width = 0.1, 
                position = position_dodge(0.9)) +
  theme_classic() +
  labs(y = "Mean Number of Soil Arthropod Individuals") +
  expand_limits(y = c(0, 10)) +  # Ensures the y-axis starts at 0
  theme(legend.position = c(0.9, 0.8),
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.3),
        text = element_text(size = 13),
        axis.title.y = element_text(margin = margin(t = 0, r = 9, b = 0, l = 0)),
        axis.title.x.top = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)))

plot(graph)


############################
# treatment vs shannon diversity in soil animals


Shannondiversity <- read.csv("soil animals data.csv", header = TRUE)
view(Shannondiversity)
 

#differrnce in collembola number between treatments
'm0<-glm(Collembola~Treatment, data=Shannondiversity)
anova(m0, test="Chisq")
summary(m0)

# residual check for collembola number between treatments
sim<-simulateResiduals(m0, n=1000, refit=F, integerResponse=NULL)
plot(sim)' #we actually just want to compare pyrantel with contriol, so we di#o not care about potntial ptoblems here

Shannondiversity2<-subset(Shannondiversity, Treatment != "Ivermectin")
view(Shannondiversity2)

#t test between sahanon divestiy index and treatment of control and pyrantel
t.test(Shannon.Diversity.Index~Treatment, paired=FALSE, data=Shannondiversity2)

t.test(Collembola~Treatment, paired=FALSE, data=Shannondiversity2)
head(Shannondiversity2)

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

####################
#NMDS and permanova in soil animal
#select spices matrix

comdata <- Shannondiversity[,3:13] # community data matrix with spicies 
comdata
 

comdata_clean <- na.omit(comdata)  # Removes rows with NA values
comdata_clean <- comdata
comdata_clean[is.na(comdata_clean)] <- 0

view(comdata_clean)
# Step 1: Remove empty rows from comdata
comdata_filtered <- comdata_clean[, colSums(comdata_clean > 0) >= 5]
comdata_filtered <- comdata_filtered[rowSums(comdata_filtered) > 0, ]

# Step 2: Match Shannondiversity to filtered comdata
Shannondiversity_clean <- Shannondiversity[rowSums(comdata_clean) > 0, ]
view(Shannondiversity_clean)
# Step 3: Transform the data
comdata_transformed <- sqrt(comdata_filtered)

# Step 4: Run NMDS
set.seed(123)
nmds <- metaMDS(comdata_transformed, dist = "bray", k = 3, maxit = 999)
stressplot(nmds)

# Step 5: Add Treatment to data.scores
data.scores <- as.data.frame(scores(nmds)$sites)
data.scores$Treatment <- Shannondiversity_clean$Treatment

# Step 6: Plot NMDS
ggplot(data.scores, aes(x = NMDS1, y = NMDS2, color = Treatment)) +
  geom_point(size = 3) +
  stat_ellipse(aes(fill = Treatment), type = "t", alpha = 0.2, geom = "polygon") +
  theme_minimal()

nmds$stress

#######


# Remove Ivermectin treatment
Shannondiversity_clean <- Shannondiversity[Shannondiversity$Treatment != "Ivermectin", ]

# Filter corresponding rows from community data
comdata_filtered <- Shannondiversity_clean[, 3:13]  # Subset community matrix
comdata_filtered[is.na(comdata_filtered)] <- 0      # Replace NA with 0

# Calculate PERMANOVA using Bray-Curtis distance
library(vegan)
adon.results <- adonis2(comdata_filtered ~ Shannondiversity_clean$Treatment, 
                        method = "bray", perm = 999)
print(adon.results)




