#rm(list=ls())
library(sp)
library(arm)
library(Matching)
library(rbounds)
library(rgenoud)
set.seed(2019)

dir <- "C:/Users/Minerva Floater 2/Documents/CS112/Official FP/"
load(paste(dir, "MainDataset.RData", sep = ""))

total_dta <- data.frame("distRail45" = pol$distRail45, 
                        "IncTax95" = as.numeric(pol$IncTax95),
                        "Pop95" = pol$Pop95, "TotEnt95" = pol$TotEnt95,
                        "PrivEnt95" = pol$PrivEnt95, "PlacDist" = pol$PlacDist,
                        "Plac2Dist" = pol$Plac2Dist, "Plac3Dist" = pol$Plac3Dist, 
                        "LPR2001" = pol$LPR2001, "Valid2001" = pol$Valid2001,
                        "CampDistKM" = pol$CampDistKM)
total_dta <- total_dta[-which(is.na(total_dta$Pop95) == TRUE), ]

match_dta <- data.frame("distRail45" = total_dta$distRail45, "IncTax95" = total_dta$IncTax95,
                        "Pop95" = total_dta$Pop95, "TotEnt95" = total_dta$TotEnt95,
                        "PrivEnt95" = total_dta$PrivEnt95)

Outcome <- total_dta$LPR2001/total_dta$Valid2001

# Create a function to test different treatment at different distance
treat_eval <- function(bound) {
  treat <- as.numeric(total_dta$CampDistKM <= bound)
  total_dta$treat <- treat
  
  genout1 <- GenMatch(Tr = treat, X = match_dta, pop.size = 500,
                      max.generations = 50, wait.generations = 10)
  
  mout1 <- Match(Y = Outcome, Tr = treat, X = match_dta, 
                 Weight.matrix = genout1, BiasAdjust = TRUE)
  
  mb1  <- MatchBalance(treat ~ distRail45 + IncTax95 + Pop95 + TotEnt95 + 
                         PrivEnt95,
                       data = total_dta, match.out = mout1, nboots=100000)
  
  ATT.adj <- mout1$est
  ATT.noadj <- mout1$est.noadj
  ATT.pvalue <- (1 - pnorm(abs(mout1$est/mout1$se))) * 2
  minimumBalance <- mb1$AMsmallest.p.value
  return(c(ATT.adj, ATT.noadj, ATT.pvalue, minimumBalance))
}


total_effect <- data.frame(double(), double(), double(), double(), double())
names(total_effect) <- c("Treatment", "ATT.adj", "ATT.noadj", 
                         "ATT.pvalue", "minimumBalance")

for (i in 40) {
  print(i)
  result <- treat_eval(i)
  total_effect[nrow(total_effect) + 1,] <- c(i, result)
} 
total_effect
#haha <- total_effect
#write.csv(total_effect, "total_effect1.csv")
