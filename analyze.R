library(readr)
library(wordcloud)
library(viridisLite)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
library(colorRamps)

rm(list = ls())

df = read_csv("shark_records_1995_2022.csv")

colnames(df) = gsub(" ", "_", colnames(df))

df <- df %>% separate("Shark", c("Shark", "Shark_details"), sep = "\\, ")

df$Shark = gsub("\\.", "", df$Shark)
df$Shark = gsub("Species uncertain", "Species unknown", df$Shark)
df$Shark = gsub("Species and length uncertain", "Species and length unknown", df$Shark)
df$Shark = gsub("Species and length uncertain", "Species and length unknown", df$Shark)
df$Shark = gsub("Species and length unknown", "Species unknown", df$Shark)
df$Shark = gsub("Data insufficient", "Species unknown", df$Shark)

freq_activitiy <- count(df, Activity)
freq_sharks <- count(df, Shark)

png("wordcloud_activity.png", height = 5, width = 5, units = "in", res = 500)

set.seed(2022)

wordcloud(words = freq_activitiy$Activity, 
          freq = freq_activitiy$n, 
          min.freq = 1,
          random.order = F, 
          rot.per = 0.2,
          colors = matlab.like(17))

dev.off()

png("wordcloud_shark.png", height = 5, width = 5, units = "in", res = 500)

set.seed(2022)

wordcloud(words = freq_sharks$Shark, 
          freq = freq_sharks$n, 
          min.freq = 1,
          random.order = F, 
          rot.per = 0.2,
          colors = viridis(9))

dev.off()


df <- df %>% separate("Date_and_Time", c("Date", "Time"), sep = "\\, ")
df <- df %>% separate("Date", c("Year", "Month", "Day"), sep = "/")

df$Time = gsub("noon", "pm", df$Time)
df$Time = gsub("p.m.", "pm", df$Time)
df$Time = gsub("approx 9:00 am", "9:00 am", df$Time)
df$Time = gsub("before 3:30 am", "3:00 am", df$Time)
df$Time = gsub("est. 8:30 am", "8:30 am", df$Time)

df$Time = format(as.POSIXct(df$Time,format='%I:%M %p'),format="%H:%M:%S")

png("time_activity.png", height = 6, width = 13, units = "in", res = 500)

(df %>% 
    mutate(Time = substr(Time, 1, 2)) %>% 
    group_by(Time, Activity) %>% 
    summarise(Freq = n()) %>% 
    ggplot(aes(x = Time, y = Freq, fill = Activity)) +
    geom_bar(stat = "identity", show.legend = T) + 
    xlab("Time of the day") + ylab("Frequency") +
    theme_half_open() +
    scale_fill_manual("", values = matlab.like(17)) +
    theme(legend.position = c(1, 1),
          legend.justification = c(1, 0.95),
          axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5, size = 10)))

dev.off()

