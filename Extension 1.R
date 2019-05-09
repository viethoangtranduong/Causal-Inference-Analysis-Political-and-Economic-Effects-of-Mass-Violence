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

"The treatment is being within 50km "

treat <- as.numeric(total_dta$CampDistKM <= 50)
total_dta$treat <- treat
  
genout1 <- GenMatch(Tr = treat, X = match_dta, pop.size = 500,
                      max.generations = 50, wait.generations = 10)
  
mout1 <- Match(Y = Outcome, Tr = treat, X = match_dta, 
                 Weight.matrix = genout1, BiasAdjust = TRUE)
  
mb1  <- MatchBalance(treat ~ distRail45 + IncTax95 + Pop95 + TotEnt95 + 
                         PrivEnt95,
                       data = total_dta, match.out = mout1, nboots=10000)
  
  # using a different starting point to yeild higher balance
genout2 <- GenMatch(Tr = treat, X = match_dta, pop.size = 500,
                      max.generations = 50, wait.generations = 10,
                      starting.values = genout1$par)
  
mout2 <- Match(Y = Outcome, Tr = treat, X = match_dta, 
                 Weight.matrix = genout2, BiasAdjust = TRUE)
  
mb2  <- MatchBalance(treat ~ distRail45 + IncTax95 + Pop95 + TotEnt95 + 
                        PrivEnt95,
                       data = total_dta, match.out = mout2, nboots=10000)
  
"Treatment Effect Stage 1:"
summary((mout1))
"No bias adjustment result:"
mout1$est.noadj
"Treatment Effect Stage 2:"
summary((mout2))
"No bias adjustment result:"
mout2$est.noadj
"Balance: "
"The smallest p.value before matching balance tests"
mb1$BMsmallest.p.value
"The smallest p.value after matching balance tests stage 1"
mb1$AMsmallest.p.value
"The smallest p.value before matching balance tests stage 2"
mb2$AMsmallest.p.value

