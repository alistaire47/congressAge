#!/usr/bin/Rscript

## An R script to graph the age of Members of Congress by party and house.
## Data downloaded 2015-03-24 from govtrack.us: https://www.govtrack.us/developers/data

## Load dependencies, import data
library('lubridate')
library('ggplot2')
data <- read.csv('legislators-current.csv')

## Calculating and adding age column from birthday
age <- c()
for (i in 1:nrow(data)) {
    age <- c(age, as.period(interval(data$birthday[i], now()))$year)
}
data <- cbind(data, age)

## Cleaning and reorganizing data
levels(data$type) <- c('House of Representatives', 'Senate')
data$type <- relevel(data$type, 'Senate')
drdata <- data[data$party %in% c('Democrat', 'Republican'),]

## Plotting jitter plot by gender
cols <- c('Democrat'='#1f78b4', 'Republican'='#e41a1c')
accents <- c('Democrat'='#9ecae1', 'Republican'='#fc9272')
jitter <- qplot(gender, age, data=drdata, geom='jitter', color=party, 
      main='Data: GovTrack.us') +
    scale_color_manual(values=cols) +
    guides(fill=FALSE, color=FALSE) +
    theme(legend.justification=c(1,1), legend.position=c(1,.8),
         plot.title=element_text(vjust=-54.5, hjust=0, size=10, color='gray40')) +
    facet_grid(type ~ party, scales='free_x')

## Plotting histograms
hist1 <- qplot(age, data=drdata, geom='histogram', binwidth=10, fill=party, 
               color=party, main='Data: GovTrack.us') +
    scale_fill_manual(values=cols) +
    scale_color_manual(values=accents) +
    guides(fill=FALSE, color=FALSE) +
    theme(legend.justification=c(1,1), legend.position=c(1,.8),
         plot.title=element_text(vjust=-54.5, hjust=0, size=10, color='gray40')) +
    facet_grid(type ~ party, space='free', scales='free_y')

hist2 <- qplot(age, data=drdata, geom='bar', binwidth=5, fill=party, 
               position='dodge', main='Data: GovTrack.us') +
    scale_fill_manual(values=cols) +
    scale_color_manual(values=accents) +
    guides(color=FALSE) +
    theme(legend.justification=c(1,1), legend.position=c(1,.8),
          plot.title=element_text(vjust=-54.5, hjust=0, size=10, color='gray40')) +
    facet_grid(type ~ ., space='free', scales='free_y')

ggsave(filename='congressAge.png', plot=hist2, 
       width=6, height=6, units='in', dpi=100)

