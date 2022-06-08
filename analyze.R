library(readr)
library(wordcloud)
library(viridisLite)
library(wordcloud2)
library(dplyr)

df = read_csv("shark_records_1995_2022.csv")

df_2 <- count(df, Activity)

set.seed(2022)
wordcloud(words = df_2$Activity, 
          freq = df_2$n, 
          min.freq = 1,
          random.order = F, 
          rot.per = 0.2,
          colors = viridis(6))
