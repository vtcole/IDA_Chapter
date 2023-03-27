library(lavaan)

##################################################
### Generating data #############################
#################################################
set.seed(58585)

male.12 <- rbinom(750, 1, .5)
male.3 <- rbinom(250, 1, .68)
male <- c(male.12, male.3)
white <- rbinom(1000, 1, .5)

ID <- 1:1000
study.1 <- c(rep(1, 250), rep(0, 750))
study.2 <- c(rep(0, 250), rep(1, 500), rep(0, 250))

pre.data <- data.frame(ID, study.1, study.2, male, white)

study.1.ID <- rep(1:250, each = 4)
study.1.age <- rep(2:5, 250)
study.1.dat <- cbind(study.1.ID, study.1.age)
study.1.dat <- as.data.frame(study.1.dat)
colnames(study.1.dat) <- c("ID", "age")
study.2.ID <- rep(251:750, each = 4)
study.2.age <- rep(c(4,6,8,10), 500)
study.2.dat <- cbind(study.2.ID, study.2.age)
study.2.dat <- as.data.frame(study.2.dat)
colnames(study.2.dat) <- c("ID", "age")
study.3.ID <- rep(751:1000, each = 6)
study.3.age <- rep(c(3:8), 250)
study.3.dat <- cbind(study.3.ID, study.3.age)
study.3.dat <- as.data.frame(study.3.dat)
colnames(study.3.dat) <- c("ID", "age")

first.dat <- rbind(study.1.dat, study.2.dat, study.3.dat)
pre.data <- merge(first.dat, pre.data, by = "ID")

pre.data$ToM.latent <- rnorm(nrow(pre.data), 0, 1) + 1.4*(pre.data$age-2) - .2*pre.data$white
pre.data$extraneous.latent.variable.1 <- rnorm(nrow(pre.data), 0, 1) #Adding in a second variable that affects 4 of the tasks, just to induce some misfit
pre.data$extraneous.latent.variable.2 <- rnorm(nrow(pre.data), 0, 1) #and a third

#ToM tasks are tasks 1-3
#Some other binary measure is 4 (should be parental report)
#Some other binary measure is 5 (should be teacher report)
#Perspective-taking is 6
#Some other ordinal measure is 7
#Continuous ToM measure is 8

task.1.star <- .3*pre.data$ToM.latent + .3*(pre.data$age-2) + rnorm(nrow(pre.data), 0, 1) + .75*pre.data$extraneous.latent.variable.2 +  .75*pre.data$extraneous.latent.variable.1
task.2.star <- .2*pre.data$ToM.latent + rnorm(nrow(pre.data), 0, 1) + pre.data$extraneous.latent.variable.1 + .5*pre.data$extraneous.latent.variable.2
task.3.star <- .4*pre.data$ToM.latent + .3*pre.data$male*pre.data$ToM.latent + rnorm(nrow(pre.data), 0, 1) + pre.data$extraneous.latent.variable.1 + .5*pre.data$extraneous.latent.variable.2
task.4.star <- .5*pre.data$ToM.latent + rnorm(nrow(pre.data), 0, 2) + 2*pre.data$extraneous.latent.variable.1 + .75*pre.data$extraneous.latent.variable.2
task.5.star <- .3*pre.data$ToM.latent + 2*pre.data$extraneous.latent.variable.1
task.6.star <- .4*pre.data$ToM.latent + .2*pre.data$white*pre.data$ToM.latent + rnorm(nrow(pre.data), 0, 1) + .5*pre.data$extraneous.latent.variable.2
task.7.star <- .1*pre.data$ToM.latent + .3*pre.data$study.2 + rnorm(nrow(pre.data), 0, 1) + pre.data$extraneous.latent.variable.1
task.8.star <- .2*pre.data$ToM.latent + .2*pre.data$study.2*pre.data$ToM.latent + rnorm(nrow(pre.data), 0, .5) + .5*pre.data$extraneous.latent.variable.2 + pre.data$extraneous.latent.variable.1

task.1 <- rep(NA, nrow(pre.data))
task.2 <- rep(NA, nrow(pre.data))
task.3 <- rep(NA, nrow(pre.data))
task.4 <- rep(NA, nrow(pre.data))
task.5 <- rep(NA, nrow(pre.data))
task.6 <- rep(NA, nrow(pre.data))
task.7 <- rep(NA, nrow(pre.data))
task.8 <- rep(NA, nrow(pre.data))


#Task 1 is binary
task.1[task.1.star > 0] <- 1
task.1[task.1.star <= 0] <- 0
#Task 2 is binary
task.2[task.2.star > 0] <- 1
task.2[task.2.star <= 0] <- 0
#Task 3 is binary
task.3[task.3.star > 0] <- 1
task.3[task.3.star <= 0] <- 0
#Task 4 is binary
task.4[task.4.star > 0] <- 1
task.4[task.4.star <= 0] <- 0
#Task 5 is binary
task.5[task.5.star > 0] <- 1
task.5[task.5.star <= 0] <- 0
#Task 6 is ordinal
task.6[task.6.star > 1] <- 3
task.6[task.6.star <=1 & task.6.star > 0] <- 2
task.6[task.6.star <=0 & task.6.star > -1] <- 1
task.6[task.6.star <=-1] <- 0
#Task 7 is ordinal
task.7[task.7.star > .75] <- 2
task.7[task.7.star <=.75 & task.7.star > -.5] <- 1
task.7[task.7.star <=-.5] <- 0
#Task 8 is continuous
task.8 <- round(abs(min(task.8.star)) + task.8.star)

all.tasks <- data.frame(task.1, task.2, task.3, task.4, task.5, task.6, task.7, task.8)

alltogether <- cbind(pre.data, all.tasks)



#Study 1 has 1,2,3,7 
alltogether$task.4[alltogether$study.1 == 1] <- NA
#alltogether$task.5[alltogether$study.1 == 1] <- NA
alltogether$task.6[alltogether$study.1 == 1] <- NA
#alltogether$task.8[alltogether$study.1 == 1] <- NA

#Study 2 has 4,5,7,8
alltogether$task.1[alltogether$study.2 == 1] <- NA
alltogether$task.2[alltogether$study.2 == 1] <- NA
alltogether$task.6[alltogether$study.2 == 1] <- NA


#Study 3 has 1,2,3,5,6,7,8
alltogether$task.4[((alltogether$study.1 != 1) & (alltogether$study.2 != 1))] <- NA


#If we wanted to write out the full dataset
#write.table(alltogether, file = "C:/Users/colev/Dropbox/IDA_chapter/fulldataset_08012022.csv", sep = ",", row.names = FALSE, col.names = FALSE, na = "-55555")


take.1 <- function(x) x[sample(nrow(x),1),]

calib <- ddply(alltogether,.(ID), take.1)

alltogether$study <- NA
alltogether$study[alltogether$study.1 == 1] <- 1
alltogether$study[alltogether$study.2 == 1] <- 2
alltogether$study[alltogether$study.1 == 0 & alltogether$study.2 == 0] <- 3
alltogether$Item1 <- alltogether$task.1
alltogether$Item2 <- alltogether$task.2
alltogether$Item3 <- alltogether$task.3
alltogether$Item4 <- alltogether$task.4
alltogether$Item5 <- alltogether$task.5
alltogether$Item6 <- alltogether$task.6
alltogether$Item7 <- alltogether$task.7
alltogether$Item8 <- alltogether$task.8
alltogether$White <- alltogether$white
alltogether$Male <- alltogether$male
alltogether$Study <- alltogether$study
alltogether$Age <- alltogether$age

FullDataset <- alltogether[,c("ID", "Study", "Age", "Male", "White", "Item1", "Item2", "Item3", "Item4", "Item5", "Item6", "Item7", "Item8")]
CalibrationDataset <- ddply(FullDataset,.(ID), take.1)

#If we wanted to write out the 
write.table(CalibrationDataset, file = "C:/Users/colev/Dropbox/IDA_chapter/IDA_chapter/mplus/PerspectiveTakingData.csv", sep = ",", row.names = FALSE, col.names = FALSE, na = "-55555")




###############################################
#Testing unidimensionality within each dataset
###############################################

model.1 = 'ToM =~ task.1 + task.2 + task.3 + task.5 + task.7 + task.8'
fitcheck.1 <- cfa(model.1, data = subset(calib, calib$study.1 == 1), ordered = c('task.1', 'task.2', 'task.3', 'task.5', 'task.7'))
fitMeasures(fitcheck.1)

model.2 = 'ToM =~ task.4 + task.5 + task.7 + task.8'
fitcheck.2 <- cfa(model.2, data = subset(calib, calib$study.2 == 1), ordered = c('task.4', 'task.5', 'task.7'))
fitMeasures(fitcheck.2)

model.3 = 'ToM =~ task.1 + task.2 + task.3 + task.5 + task.6 + task.7 + task.8'
fitcheck.3 <- cfa(model.3, data = subset(calib, (calib$study.1 == 0 & calib$study.2 == 0)), ordered = c(
  'task.1', 'task.2', 'task.3', 'task.5', 'task.6', 'task.7'))
fitMeasures(fitcheck.3)

###########################################
### Plotting the factor scores ############
###########################################


fscores_08012022 <- read.table("C:/Users/colev/Dropbox/IDA_chapter/scores_08012022.dat", header = FALSE, na = "*")
just.fscores <- fscores_08012022[,c("V12", "V9")]
names(just.fscores) <- c("Score", "Age")
boxplot(Score~Age,
        data=just.fscores,
        main="Distribution of scores by age",
        xlab="Age in years",
        ylab="Predicted score",
        col="orange",
        border="brown"
)

MeanScores <- by(fscores_08012022$V12, fscores_08012022$V9, mean)
age.nums <- c(250,500,1000,500,750,250,750,500)^.8/100
Ages <- c(2,3,4,5,6,7,8,10) 

plot(Ages, MeanScores, cex = age.nums, ylim = c(0, 2), pch = 20)
lines(lowess(Ages, MeanScores), col='black')

f.study.1 <- subset(fscores_08012022, fscores_08012022$V10 == 1)
mean.study.1 <- by(f.study.1$V12, f.study.1$V9, mean)
ages.1 <- 2:5

f.study.2 <- subset(fscores_08012022, fscores_08012022$V11 == 1)
mean.study.2 <- by(f.study.2$V12, f.study.2$V9, mean)
ages.2 <- c(4,6,8,10)

f.study.3 <- subset(fscores_08012022, fscores_08012022$V11 == 0 & fscores_08012022$V11 == 0)
mean.study.3 <- by(f.study.3$V12, f.study.3$V9, mean)
ages.3 <- 2:8

plot(Ages, MeanScores, cex = age.nums, ylim = c(0, 2), pch = 20, xlab = "Age in years", ylab = "Average score", cex.lab = .8, cex.axis = .8)
lines(Ages, MeanScores, col='#444444', lwd = 2)

lines(ages.1, mean.study.1, col = "#F34F1C", lwd = 2)
#lines(lowess(ages.1, mean.study.1), col = "red")
lines(ages.2, mean.study.2, col = "#7FBC00", lwd = 2)
#lines(lowess(ages.2, mean.study.2), col = "blue")
lines(ages.3, mean.study.3, col = "#01A6F0", lwd = 2)
#lines(lowess(ages.3, mean.study.3), col = "green")
points(Ages, MeanScores, col='#444444', pch = 20, cex = age.nums)

legend("topleft", legend = c("Study 1", "Study 2", "Study 3"), 
       lwd = 2, col = c("#F34F1C", "#7FBC00", "#01A6F0"), y.intersp = .67,
       bty = "n", cex = .67)

