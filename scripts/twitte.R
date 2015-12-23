library(base64enc)
library(httr)
library(rjson)
library(twitteR)
library(wordcloud)


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

# Get caches tweets (if any exist)
cached_tweets <- getCachedTweets()
last_cached_tweet <- getLatestCachedTweet(cached_tweets)

# Search Twitter for tweets with given search terms
new_tweets.list <- downloadNewTweets(cfg$search_terms, last_cached_tweet)
new_tweets <- twListToDF(new_tweets.list)

# Combine and (re-)cache all unique tweets
tweets <- unique(rbind(cached_tweets, new_tweets))
cacheTweets(tweets)


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
