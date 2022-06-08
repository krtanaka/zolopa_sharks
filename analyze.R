library(readr)
library(wordcloud)
library(viridisLite)
library(wordcloud2)
library(dplyr)
library(tidyr)

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

set.seed(2022)

wordcloud(words = freq_activitiy$Activity, 
          freq = freq_activitiy$n, 
          min.freq = 1,
          random.order = F, 
          rot.per = 0.2,
          colors = viridis(6))

wordcloud(words = freq_sharks$Shark, 
          freq = freq_sharks$n, 
          min.freq = 1,
          random.order = F, 
          rot.per = 0.2,
          colors = viridis(6))



