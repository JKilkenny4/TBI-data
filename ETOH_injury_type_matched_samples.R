library(MatchIt)
library(tidyverse)
View(TBI_data)

#Dropping missing rows
df <- as.data.frame(TBI_data[!is.na(TBI_data$ETOH_Level), ])
#Dropping columns of missing data
df <- df[1:11]

View(df)

###Setting up data for the matchit function
##Creating binary ETOH variable
#0 = Sober; 1 = Intox
df$ETOH_Bin <- ifelse(df$ETOH_Level < 80, 0, 1)
table(df$ETOH_Bin)

#This line is critical for inputting into matchit
df$ETOH_Bin <- as.numeric(df$ETOH_Bin)
class(df$ETOH_Bin)

##Creating binary injury type variable
#1 = Penetrating; 0 = Blunt
table(df$Injury_Type)
#This line is actually critical because matchit won't accept Injury_Type unless it's binary numeric#
df$Injury_Type <- as.numeric(df$Injury_Type)

##Creating binary gender variable
#1 = Female; 0 = Male
df$gender <- ifelse(df$Gender == 'Male', 0, 1)
table(df$gender)

##Creating binary race variable
#1 = White; 0 = Non-white
df$race <- ifelse(df$Race == 'White', 1, 0)
table(df$race)

#Running matchit
matchit_df <- matchit(Injury_Type ~ Age + gender + race + ETOH_Bin, 
                    data=df, method="nearest", ratio=1)
summary(matchit_df)

##Outputting matched data into new dataframe##
df.match <- match.data(matchit_df)
table(df.match$ETOH_Level, df.match$Injury_Type)

###Testing hypotheses using matched data -- do GCS scores differ by injury type and alcohol content
###Lower GCS scores = worse injury
res.aov <- aov(GCS ~ ETOH_Bin * Injury_Type, data = df.match)
summary(res.aov)

###Graphing the results
library(ggpubr)
interaction.plot(x.factor = df.match$Injury_Type, 
                 trace.factor = df.match$ETOH_Bin, 
                 response = df.match$GCS, 
                 fun = mean, type = "b", legend = TRUE,
                 xlab = "Injury", ylab="GCS", pch=c(1,19), 
                 col = c("#00AFBB", "#E7B800"))

#Simple Main-effects
sober_only <- subset(df.match, ETOH_Bin == 0, select=Trauma_Number:race)
t.test(GCS ~ Injury_Type, data = sober_only, var.equal = TRUE)
t.test(GCS ~ Injury_Type, data = sober_only, var.equal = FALSE)
for (i in c(0, 1)) {
  print(c(i, 
          mean(sober_only$GCS[sober_only$Injury_Type == i]), 
          sd(sober_only$GCS[sober_only$Injury_Type == i])))
}



intox_only <- subset(df.match, ETOH_Bin== 1, select=Trauma_Number:race)
t.test(GCS ~ Injury_Type, data = intox_only, var.equal = TRUE)
t.test(GCS ~ Injury_Type, data = intox_only, var.equal = FALSE)
for (i in c(0, 1)) {
  print(c(i, 
        mean(intox_only$GCS[intox_only$Injury_Type == i]), 
        sd(intox_only$GCS[intox_only$Injury_Type == i])))
}



blunt_only <- subset(df.match, Injury_Type == 0, select=Trauma_Number:race)
t.test(GCS ~ ETOH_Bin, data = blunt_only, var.equal = TRUE)
t.test(GCS ~ ETOH_Bin, data = blunt_only, var.equal = FALSE)
for (i in c(0, 1)) {
  print(c(i, 
          mean(blunt_only$GCS[blunt_only$ETOH_Bin == i]), 
          sd(blunt_only$GCS[blunt_only$ETOH_Bin == i])))
}



penetrating_only <- subset(df.match, Injury_Type == 1, select=Trauma_Number:race)
t.test(GCS ~ ETOH_Bin, data = penetrating_only, var.equal = TRUE)
t.test(GCS ~ ETOH_Bin, data = penetrating_only, var.equal = FALSE)
for (i in c(0, 1)) {
  print(c(i, 
          mean(blunt_only$GCS[blunt_only$ETOH_Bin == i]), 
          sd(blunt_only$GCS[blunt_only$ETOH_Bin == i])))
}
