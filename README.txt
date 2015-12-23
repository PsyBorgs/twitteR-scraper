# TwitteR-scraper

A tool for scrapping recent [Twitter](http://twitter.com) tweets, given a list of terms or hashtags, with the goal of later analysis.

The idea and some of the code for this project was cribbed (borrowed) from [Gaston Sanchez](http://www.gastonsanchez.com)'s [Quick guide to mining twitter with R](https://sites.google.com/site/miningtwitter/home); although, we have updated the code significantly in order to make it work with the latest iteration of the [Twitter API](https://dev.twitter.com/rest/public) as well as the [TwitteR package](https://cran.r-project.org/web/packages/twitteR/).

Twitter as a social media came of age together at a time when public engagement (knowledge mobilization) became an important concern for academics (e.g. open access).
You, as a researcher, may be interested in how both Twitter and your topic of interest are understood within the popular media and on the platform.
As such, the code in this repository can be used to explore that topic of interest as a scientific research program, and to answer some basic questions:

- How do people talk about a novel, interdisciplinary science with policy implications on a social media platform?
- What (kinds of) communities does this topic generate?
- How does information move through the network(s) of communities?

This code can begin to answer some of those questions by revealing how your chosen topic/terms of interest are represented as “trending science”  on social media.
It aims to do this by caching recent tweets related to your given terms/hashtags and performing some basic analyses on those data.


## Requirements

- [R](https://www.r-project.org/)
- [RStudio](www.rstudio.com/) (recommended)


## Installation

Install the required R packages:

    $ Rscript requirements.R

Create a `config.json` file (by copying `config-sample.json`) and configure the following:

- Your [Twitter API OAuth access tokens](https://dev.twitter.com/oauth/overview/application-owner-access-tokens) (note: you have to create a new "application" in your dev account)
- Your terms/hashtags of interest (e.g. `epigenetics`, `#epigenomics`)

Run the R script:

    $ Rscript scripts/twitte.R
