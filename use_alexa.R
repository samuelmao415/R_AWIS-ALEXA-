### Alexa URL category lookup###
library(aws.alexa)
set_secret_key(key = '###', secret = '###', force = TRUE)
#use this to set environment for using this particular key
Sys.setenv(AWS_ACCESS_KEY_ID = "###")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "###")

url=c("https://www.google.com/","https://www.yahoo.com","https://www.wsj.com")

ALEXA_test<-function(url)
  {
  test2<-lapply(url,url_info,response_group='RelatedLinks,Categories,Rank,RankByCountry,UsageStats,AdultContent,Speed,Language,OwnedDomains,LinksInCount')
  #get category
  #lapply(test2, function(x) x$Response$UrlInfoResult$Alexa$Related$Categories$CategoryData$AbsolutePath%>%unlist )
  #get related link
  newlist<-lapply(test2, function(x) x$Response$UrlInfoResult$Alexa$Related$RelatedLinks)
  newlist<-lapply(newlist, function(x) lapply(x,function(x)x[2]$NavigableUrl[[1]]))
  newlist_copy<-newlist

  url_list<-lapply(url,list)

  newlist_copy<-lapply(newlist_copy,unname)

  for (i in 1:length(newlist_copy)){
    newlist_copy[[i]]=c(newlist_copy[[i]],url_list[[i]])
  }

  #name the list with the website searched url on ALEXA
  for (i in 1:length(newlist_copy)){
    names(newlist_copy)[i]<-tail(newlist_copy[[i]],1)
  }

  unlist_newlist_copy<-lapply(X = newlist_copy,FUN = unlist)
  require(tidyr)
  unlist_newlist_copy1<-lapply(unlist_newlist_copy, `length<-`, max(lengths(unlist_newlist_copy)))
  #fill na so the list lengths are the same


  hack<-as_tibble(unlist_newlist_copy1) #this keeps the column name unchaged (https:// is keeped!)
  hack1<-gather(hack,key="input_domain",value="similar_domain")
  library(urltools)
  hack1$similar_domain<-suffix_extract(domain(hack1$similar_domain))#extract just domain for analytics

  similar_domain<-hack1$similar_domain$domain
  input_domain<-hack1$input_domain
  newhack<-as.data.frame(cbind(input_domain,similar_domain))
  newhack$input_domain<-as.factor(newhack$input_domain)

  hack1 %>% write.csv2('./data/similar_domains_test.csv'
                       , row.names = FALSE
                       , quote = TRUE)
  return(newhack)
}

newhack<-ALEXA_test(url)
