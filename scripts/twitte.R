library(base64enc)
library(httr)
library(twitteR)


source("scripts/functions.R")


# Import configuration settings
cfg <- fromJSON(file = "config.json")

# Setup Twitter authentication
setup_twitter_oauth(
    cfg$consumer_key,
    cfg$consumer_secret
    )

# Get caches tweets (if any exist)
# cached_tweets <- getCachedTweets()

# Search Twitter for tweets with given search terms
new_tweets <- getLatestTweets(cfg$search_terms)
cacheTweets(new_tweets)
