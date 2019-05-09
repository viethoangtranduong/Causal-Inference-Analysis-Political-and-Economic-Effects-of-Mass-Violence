#rm(list=ls())
library(sp)
library(arm)
library(Matching)
library(rbounds)
library(rgenoud)
set.seed(2019)


dir <- "C:/Users/Minerva Floater 2/Documents/CS112/Official FP/"
load(paste(dir, "MainDataset.RData", sep = ""))
#load(paste(dir, "textStemmed.Rdata", sep = ""))

# Filter the data
" 1. we sample communities located up to 50 km
  2. We examined predominantly rural communities around Treblinka 
     and excluded urban"
dta <- pol[which(pol$CampDistKM <= 50 & pol$type != "urban"),]

# The votes not for Liga Polskich Rodzin (LPR) in 2001 = total votes - LPR votes
dta$NonLPR2001 <- dta$Valid2001 - dta$LPR2001


dta$NonLPR2001 <- dta$Valid2001 - dta$LPR2001
glm1 <- glm(cbind(LPR2001, NonLPR2001) ~log(CampDistKM), data=dta, family = quasibinomial)
summary(glm1) 
glm1.sim <- sim(glm1, n.sims = 10000)

distance <- seq(floor(min(dta$CampDistKM)),50)

plot(x = c(1:100), y = c(1:100), type = "n", 
     xlim = c(0,55), ylim = c(0.08,0.2),
     main = "LPR vote choice (2001)",
     xlab = "Distance to Treblinka, km",
     ylab = "Proportion")

med_list <- c()
for (dist in distance) {
  storage <- c()
  for (i in 1:10000) {
    # plug the data the linear regression coefficients
    logit <- sum(coef(glm1.sim)[i, ]*c(1, log(dist)))
    result = exp(logit)/(exp(logit) + 1)
    
    storage <- c(storage, result)
  }
  
  segments(
    x0 = dist,
    y0 = quantile(storage, 0.025),
    x1 = dist,
    y1 = quantile(storage, 0.975),
    lwd = 2,
    col = rgb(0,0,1,.5))
  med_list <- c(med_list, median(storage))
  #points(dist, median(storage), col = "black", pch = 19)
}
lines(distance, med_list, col = "black", lwd = 2)