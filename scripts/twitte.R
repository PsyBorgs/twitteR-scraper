library(rjson)
library(twitteR)
library(wordcloud)

# TODO: convert to use https://github.com/Btibert3/twitter-bot-highered/blob/master/bot.R

options(scipen=999)  # disable scientific notation


# Import project functions
source("scripts/functions.R")

# Import configuration settings
cfg <- rjson::fromJSON(file = "config.json")

# Setup Twitter authentication
twitteR::setup_twitter_oauth(
  cfg$twitter$consumer_key,
  cfg$twitter$consumer_secret,
  cfg$twitter$access_token,
  cfg$twitter$access_secret
)

# Get tweets
tweets <- getTweets(search_terms = cfg$search_terms)


# Analysis
# --------------------------------------------------

clean_tweets_corpus <- createCleanTextCorpus(tweets$text)

# Word cloud
wordcloud(clean_tweets_corpus,
    min.freq = 2,
    scale = c(7, .8),
    colors = brewer.pal(8, "Dark2"),
    random.color = TRUE,
    random.order = FALSE,
    max.words = 150
    )
