library(base64enc)
library(httr)
library(readr)
library(tm)
library(twitteR)


CACHE_DIR <- file.path("cache")
TWEETS_CSV <- file.path(CACHE_DIR, "tweets.csv")
MAX_TWEETS <- 1500


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
  new_tweets <- NULL

  # Get ID of last tweet
  last_tweet_id <- NULL
  if (typeof(last_cached_tweet) == "list" &&
      "id" %in% names(last_cached_tweet)) {
    last_tweet_id <- last_cached_tweet$id
  }

  # Download tweets for each search term
  query <- paste(search_terms, collapse = " OR ")
  print(paste0(
    "Searching Twitter for tweets with the query '", query, "'",
    " (max. ", MAX_TWEETS, " tweets)..."
    )
  )
  new_tweets.list <- twitteR::searchTwitter(query,
    n = MAX_TWEETS,
    sinceID = last_tweet_id,
    lang = "en"
    )
  print(paste("Found", length(new_tweets.list), "tweets."))

  # Convert list of tweets to data frame
  print(length(new_tweets.list) > 0)
  if (length(new_tweets.list) > 0) {
    new_tweets <- twListToDF(new_tweets.list)
  }

  return(new_tweets)
}


# Cache list of tweets. Return nothing.
cacheTweets <- function(tweets) {
  write_csv(tweets, path = TWEETS_CSV)
}


# Collect cached and new tweets. Cache new tweets and return data frame.
getTweets <- function(search_terms) {

  # Get caches tweets (if any exist)
  cached_tweets <- getCachedTweets()
  last_cached_tweet <- getLatestCachedTweet(cached_tweets)

  # Search Twitter for latest tweets with given search terms
  new_tweets <- downloadNewTweets(search_terms, last_cached_tweet)

  # Combine and (re-)cache all unique tweets
  tweets <- unique(rbind(cached_tweets, new_tweets))
  cacheTweets(tweets)

  return(tweets)
}


# Clean corpus text. Return text corpus.
createCleanTextCorpus <- function(text) {
  # omit all non-english symbols, including emoticons
  text <- sapply(text, function(row) iconv(row, "latin1", "ASCII", sub=""))
  #convert all text to lower case
  text <- tolower(text)
  # Replace rt with blank space
  text <- gsub("rt", "", text)
  # Replace @UserName
  text <- gsub("@\\w+", "", text)
  # Remove punctuation
  text <- gsub("[[:punct:]]", "", text)
  # Remove links -- though obviously you might WANT links for your analysis
  text <- gsub("http\\w+", "", text)
  # Remove tabs
  text <- gsub("[ |\t]{2,}", "", text)
  # Remove blank spaces at the beginning
  text <- gsub("^ ", "", text)
  # Remove blank spaces at the end
  text <- gsub(" $", "", text)

  # create TM corpus
  text_corpus <- Corpus(VectorSource(text))
  # remove stopwords
  text_corpus <- tm_map(text_corpus, function(x) removeWords(x, stopwords()))

  return(text_corpus)
}
