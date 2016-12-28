
# This R script uses the data set acoustic_data_visualization.csv 
# A more detailed tutorial can be found for this script at <http://skylions.org/2016/12/27/acoustic-data-visualization/>

#requires the following packages: 
library(tidyr)
library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)

acoustic <- read.csv("path to acoustic_data_visualization.csv")
acoustic <- acoustic[-1204,] # I eliminated a row from the dataset that had a nonsense date entry.

date<- select(acoustic, Filename) 
date <- str_match(date$Filename, "201.....") 
year <- str_match(date, "20..")
date = ymd(date) 
julian<- yday(date)

calls <- select(acoustic,Consensus) 
calls <- data.frame(cbind(year,julian,calls))

species_of_interest <- c("Lano", "Laci") 
Laci_Lano <- calls %>% filter(Consensus %in% species_of_interest) 
call_count<- count(Laci_Lano, year, julian, Consensus)

#jpeg("AcousticDataVizNov16.jpg", res = 300, height = 1200, width = 1800)
acoustic_viz <- ggplot(call_count, aes( x = julian, y = n, colour = Consensus)) + geom_bar(stat="identity") 
acoustic_viz <- acoustic_viz + facet_wrap(~year,nrow = 3, scales = "free_y") 
acoustic_viz <- acoustic_viz + theme_bw() + scale_y_continuous("Calls/Night") + scale_x_continuous("Julian Date")
acoustic_viz
#dev.off()

species_of_interest <- c("Lano", "Laci","Tabr","Myca")
all_species <- calls %>% filter(Consensus %in% species_of_interest)





