### Alexa URL category lookup###
library(aws.alexa)
set_secret_key(key = '###', secret = '###', force = TRUE)
#use this to set environment for using this particular key
Sys.setenv(AWS_ACCESS_KEY_ID = "###")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "###")

url=c("https://www.google.com/","https://www.yahoo.com","https://www.wsj.com")

#testing purposes
url_cats <- url_info(url = url, response_group = 'Categories')
url_cats <- url_info(url = "https://www.google.com"
                     , response_group = 'RelatedLinks,Categories,Rank,RankByCountry,UsageStats,AdultContent,Speed,Language,OwnedDomains,LinksInCount'
)

url_cats$Response$UrlInfoResult$Alexa$Related$Categories$CategoryData$AbsolutePath %>% unlist

#related links
url_cats$Response$UrlInfoResult$Alexa$Related$RelatedLinks%>%unlist%>%as.data.frame()

test1<-lapply(url,url_info,response_group='Categories')
test2<-lapply(url,url_info,response_group='RelatedLinks,Categories,Rank,RankByCountry,UsageStats,AdultContent,Speed,Language,OwnedDomains,LinksInCount')

lapply(test2, function(x) x$Response$UrlInfoResult$Alexa$Related$Categories$CategoryData$AbsolutePath%>%unlist )
newlist<-lapply(test2, function(x) x$Response$UrlInfoResult$Alexa$Related$RelatedLinks)
newlist<-newlist%>%unlist%>%as.data.frame() 
names(newlist)[1]<-"store_name"
newlist[1]<-lapply(newlist[1], as.character)
newlist