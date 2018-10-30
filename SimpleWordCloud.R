#
# Check to see if the required libraries need to be downloaded from c-kan.
# If they are then download.
#
if(!require(twitteR))
{ install.packages("twitteR", repos="http://cran.r-project.org") } if(!require(wordcloud2))
{ install.packages("wordcloud2", repos="http://cran.r-project.org") } if(!require(RColorBrewer))
{ install.packages("RColorBrewer", repos="http://cran.r-project.org") } if(!require(ROAuth))
{ install.packages("ROAuth", repos="http://cran.r-project.org") }
#
# load the required libraries into the R environment #
library(twitteR)
library(wordcloud2)
library(RColorBrewer)
library(ROAuth)
#
# The set of credentials are supplied for the code to access the twitter feeds. #
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
consumerKey <- "<Twitter supplied Consumer key>"
consumerSecret <- "<Twitter supplied Consumer secret>"
accessToken <- "<Twitter supplied Access Token>"
accessSecret <- "<Twitter supplied Access Sceret>"
#
# The consumer and access tokens should be added to the
# application as part of the authentication process.
#
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
#
# An initial set of words to ignore from the twitter feed
#
ignoreWords<-c("http", "https", "htt", " for ", " with ", " esp ", " and ", " bit ", " the ", " how ", "now","this","any","has", "this")

#
# The incremental process of weeding out what is relevant #
# Extract the last 1500 tweets relating to #talkbigdata in English tweets=searchTwitter("#talkbigdata", n=1500, lang="en")
# Retrieve the entries as text
utweets=sapply(tweets, function(x) x$getText())
# Remove all the special characters @#&',.-:;?
vtweets<-gsub("[@#&',.-:;?]\\w+ *", " ", utweets)
# Remove all words that dont begin with a letter
wtweets<-gsub("[^A-z ]", " ", vtweets)
# Remove all words that are not longer than two characters ytweets<-gsub('\\b\\w{1,2}\\b', replacement=' ', wtweets)
#Convert the | delimited dataframe into a string vector
ztweets<-gsub(ytweets, pattern=paste(ignoreWords, collapse = "|"), ignore.case=TRUE, replacement = " ")
# Convert the remaining string vector to an array and convert to lower case words<-strsplit(tolower(ztweets), " ", perl=FALSE)
# load the data into a table for sorting
m<-table(unlist(words))
# Sort the remaining words in decreasing order based on frequency msort<-sort(m, decreasing=TRUE)
# Group the names and the frequency of words together into a table mtable<-paste(names(msort), msort, sep="\t")
# Load the names and frequency into a dataframe dm<-strsplit(mtable, split="\t")
dt<-do.call(rbind, dm)
df<-as.data.frame(dt)
# Ensure that the column refering to frequencies of words is actually numeric df[,2]<-as.numeric(as.character(df[,2]))
# Pass the cleaned data into the wordcloud function to produce the output.
wordcloud2(df, color = 'random-dark', backgroundColor = "white", shape='circle', size=20)
