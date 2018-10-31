library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(markdown)
library(knitr)
library(DT)
library(car)
library(wordcloud)
library(ngram)

#load data
ard_data = read.csv("data/ard_data.csv", header = TRUE)
ard_data$Title = as.character(ard_data$Title)
ard_data$Description = as.character(ard_data$Description)
ard_data$CommentsNum = as.numeric(ard_data$CommentsNum)
ard_data$Followers = as.numeric(ard_data$Followers)
ard_data$Projects = as.numeric(ard_data$Projects)
ard_data$Respects = as.numeric(ard_data$Respects)
ard_data$Views = as.numeric(ard_data$Views)
ard_data = ard_data %>% mutate(., RespectPerView = round(Respects / Views, 5))

#create boolean columns for each topic
names_topics = ard_data %>% transmute(.,
                                      Title = Title,
                                      Description = Description,
                                      Views = Views,
                                      TopicList = strsplit(as.character(Topics), ','))

all_topics = unlist(c(names_topics$TopicList))
#only want topics that are found on 0.5% or more of projects, otherwise irrelevant
selected_topics_df = data_frame(topics = all_topics, index = 1:length(all_topics)) %>%
  group_by(., topics) %>% summarise(., reps = n()) %>%
  filter(., reps >= sum(reps)/200)

selected_topics = unique(selected_topics_df$topics)

names_topics[selected_topics] = 0

#to-do: get rid of for loop
for(name in names_topics$Title) {
  names_topics[names_topics$Title == name, selected_topics] = selected_topics %in%
    unlist(names_topics[names_topics$Title == name, "TopicList"])
}

#add scraped data and topic columns to create useable dataset
use_data = merge(ard_data[, !(names(ard_data) %in% c("Topics"))],
                names_topics[, !(names(names_topics) %in% c("TopicList"))],
                #include Description and Views to avoid problems w/ duplicate titles
                by = c("Title", "Description", "Views"))


predict_data = use_data[,!(names(use_data) %in% c("Respects","Views",
                                                  "CommentsNum", "Title","Date",
                                                  "Description", "Creator"))]


# Make the wordcloud drawing predictable during a session
wordcloud_rep <- repeatable(wordcloud)



