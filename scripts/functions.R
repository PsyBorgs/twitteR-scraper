library(jsonlite)
library(readr)
library(twitteR)
library(tm)
library(wordcloud)


CACHE_DIR <- file.path("cache")
TWEETS_CSV <- file.path(CACHE_DIR, "tweets.csv")
MAX_TWEETS <- 100  # number of tweets to return per request; API maximum is 100


# Get cached tweets (from previous searches). Return list of lists.
getCachedTweets <- function() {
  tweets <- NULL

  if (file.exists(TWEETS_CSV)) {
    tweets <- read_csv(TWEETS_CSV)
  }

  return(tweets)
}


# Get most recent tweet from a dataframe of cached tweets. Return list.
getLatestCachedTweet <- function(cached_tweets) {
  ordered_tweets <- cached_tweets[ordered(cached_tweets$id), ]
  latest_cached_tweet <- as.list(ordered_tweets[1, ])
  return(latest_cached_tweet)
}


# Search Twitter and download the most recent tweets containing terms of
# interest. Return list of lists.
downloadNewTweets <- function(search_terms, last_cached_tweet) {
  # Get ID of last tweet
  last_tweet_id <- NULL
  if (typeof(last_cached_tweet) == "list" &&
      "id" %in% names(last_cached_tweet)) {
    last_tweet_id <- last_cached_tweet$id
  }

  # Download tweets for each search term
  tweets <- c()
  for (term in search_terms) {
    print(paste0(
      "Searching Twitter for tweets with the term '", term, "'",
      " (max. ", MAX_TWEETS, " tweets)..."
      )
    )

    term_tweets <- twitteR::searchTwitter(term,
      n = MAX_TWEETS,
      sinceID = last_tweet_id
      )

    print(paste("Found", length(term_tweets), "tweets."))

    tweets <- c(tweets, term_tweets, recursive = TRUE)
  }

  tweets.df <- twListToDF(tweets)

  return(tweets)
}


# Cache list of jsonified tweets. Return nothing.
cacheTweets <- function(tweets) {
  write_csv(tweets, path = TWEETS_CSV)
}
