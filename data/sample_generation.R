# Preliminaries
rm(list = ls(all = T))
gc()
`%!in%` <- Negate("%in%")
library(tidyverse)

# Read full data in, subset, select cols
tweets <- readr::read_csv('/Users/hbharathachakravarthy/Desktop/spring22/gov52_models/oroject/merged.csv') %>% # TODO edit before run
  filter(is_retweet == F, is_quote == F, lang == "en") %>% # this is new
  select(
    user_id.y,
    text,
    serial_dummy,
    favorite_count,
    retweet_count,
    account_created_at,
    verified,
    followers_count,
    friends_count,
    statuses_count
  ) %>% rename("user_id" = "user_id.y", "days_existed" = "account_created_at")
tweets$user_id <- as.factor(tweets$user_id)
tweets$verified <- as.numeric(tweets$verified)

# Number of times the same unique tweet was tweeted
tweets$n_tweeted <- as.numeric(ave(tweets$text, tweets$text, FUN = length))

# Convert date created into numeric
tweets$days_existed <-
  as.double(difftime(as.Date(Sys.Date()), as.Date(tweets$days_existed)))

# Subsample data by unique tweets and their Ns
temp <- tweets %>% 
  group_by(text, n_tweeted) %>% 
  summarise(
    n_tweeted = n_tweeted,
    serial_dummy = mean(serial_dummy),
    favorite_count = mean(favorite_count),
    retweet_count = mean(retweet_count),
    days_existed = mean(days_existed),
    verified = mean(verified),
    followers_count = mean(followers_count),
    friends_count = mean(friends_count),
    statuses_count = mean(statuses_count)
    )

# Split whole sample into 2 subsamples, 80% and 20% each, randomly
n <- nrow(temp)
split <- sample(c(TRUE, FALSE), n, replace=TRUE, prob=c(0.8, 0.2))
training <- temp[split, ]
testing <- temp[!split, ]
rm(temp)

# Now take a random subsample BY group for smaller N
# This function below samples n from every group (N tweeted)
# If the number of tweets with that number of N is is less than the 
# sample size, it takes the whole vector of that N-tweeted
varsample <- function(x, n) {
  if (length(x) <= n)
    return(x)
  x[x %in% sample(x, n)]
}
training <- training[unlist(lapply(split(1:nrow(training), training$n_tweeted), varsample, n = 1000)), ]
testing <- testing[unlist(lapply(split(1:nrow(testing), testing$n_tweeted), varsample, n = 100)), ]

# Now take only used rows and label where they went in the large data
tweets$usage <- ifelse(tweets$text %in% training$text, "training", NA)
tweets$usage <- ifelse(tweets$text %in% testing$text, "testing", tweets$usage)
tweets <- tweets %>% filter(!is.na(usage))

# Export the test and train text + target vector dfs and the compact
# dataframe with an assignment column
# TODO un-comment to resample
# write_csv(training, "training.csv")
# write_csv(testing, "testing.csv")
# write_csv(tweets, "used_tweets.csv")
