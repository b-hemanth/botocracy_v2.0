# rm(list = ls(all = T))
# gc()

library(tidyverse)
library(rtweet)
library(keras)
library(reticulate)
library(tensorflow) 
library(text)
library(reticulate)
library(glmnet)
library(parsnip)
library(workflows)
library(lubridate)


# Initialize the installed conda environment and save settings
text::textrpp_initialize()

fit <- readr::read_rds("./rf.rds")

bot_check <- function(screen_name, num) {
  tweets <- rtweet::lookup_users(
    screen_name,
    parse = T,
    token = token
  ) 
  temp <- rtweet::get_timeline(
    user = screen_name,
    n = num,
    parse = T,
    token = token
  ) %>% select(-created_at)
  temp$screen_name <- tweets$screen_name
  tweets <- left_join(temp, tweets, by = "screen_name") 
  tweets <- tweets %>% 
    select(
      full_text,
      screen_name,
      favorite_count,
      retweet_count,
      created_at,
      followers_count,
      friends_count,
      statuses_count
    )
  tweets$created_at <- as.POSIXct(tweets$created_at,
                                  format = "%a %b %d %H:%M:%S +0000 %Y",
                                  tz = "GMT")
  tweets$days_existed <-
    as.double(difftime(as.Date(Sys.Date()), as.Date(tweets$created_at)))
  tweets$serial_dummy <- ifelse(
    tweets$screen_name %in% grep("[0-9]{8}", tweets$screen_name, value = T),
    1,
    0
  )
  temp2 <- tweets %>% select(screen_name, full_text)
  tweets <- select(tweets, -screen_name)
  rm(temp)
  bert_we <- textEmbed(tweets, model = "bert-base-uncased", print_python_warnings = T)
  bert_we <- bert_we$full_text %>% as_tibble()
  bert_we <- prcomp(bert_we, center = T, scale = T)
  bert_we <- as.data.frame(bert_we$x)
  tweets <- cbind(tweets, bert_we) 
  tweets <- tweets %>% select(-full_text, -created_at)
  y_predicted <- predict(fit, tweets)
  y_predicted <- as_tibble(cbind(temp2, y_predicted)) %>% 
    rename("Screen Name" = "screen_name",
           "Tweet Text" = "full_text", 
           "BotOrNot" = "y_predicted")
  return(y_predicted)
}

