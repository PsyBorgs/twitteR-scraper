library(jsonlite)
library(twitteR)
library(tm)
library(wordcloud)


CACHE_DIR <- file.path("cache", "tweets")
# MAX_TWEETS <- 45000  # rate-limit of 450 requests per 15 minutes * 100 tweets per request max
MAX_TWEETS <- 45


# Get cached tweets (from previous searches). Return list of lists.
getCachedTweets <- function() {
  tweets <- NULL

  return(tweets)
}


# Search Twitter and download the most recent tweets containing terms of
# interest. Return list of lists.
getLatestTweets <- function(search_terms) {
  max_tweets <- floor(MAX_TWEETS / length(search_terms))

  tweets <- lapply(search_terms,
    searchTwitter, n = max_tweets)

  return(tweets)
}


# Cache list of jsonified tweets. Return nothing.
cacheTweets <- function(tweets) {

  return(NULL)
}
