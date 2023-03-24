### LOC Chronicaling America API

### This asks the API how many hits each keyword gets in each given year


library(httr)
library(dplyr)
library(tidyr)
library(XML)
library(xml2)
library(rjson)



setwd("C:\\Users\\grfai\\Documents\\0_Dissertation\\Code\\Keyword\\KW Hit Counter")

baseurl <- "https://chroniclingamerica.loc.gov/search/pages/results/"

###Create df for search_hits

hit_results <- list(search_coords = character()
                   )
hit_results <- append (hit_results,"Gotta Start Somewhere")



s_hits_by_year = function(searchterms,searchyr){
  
  rowsperpg <- 20 
  startyr <- searchyr
  endyr <- searchyr
  #skipyear <- 31
  search_pause <- 2
  

  
  ##multi-year loop
  for(searchyr in startyr:endyr){
  
    
    #reset these every loop
    page <- 1
    maxPages <- 1
    hits <-0
    
    ### pages loop
    while(page <= maxPages) {
    
    query <- paste0(baseurl,
                    "?",
                    "dateFilterType=yearRange&date1=",searchyr,"&date2=",searchyr,
                    ####"&proxtext=",lex_term,"+",lex_term,"&proxdistance=100000",
                    "&andtext=",lex_term,
                    "&page=",page, 
                    "&rows=",rowsperpg,
                    "&language=eng",
                    "&searchType=advanced",
                    "&format=atom")
    Sys.sleep(search_pause)   
    xmlresp <- read_xml(GET(query))

    #update maxpages
      if(page==1){
        hits <- xml_text(xml_find_all(xmlresp,xpath="//opensearch:totalResults")) #total hits from query
        hits <- as.integer(hits)
        maxPages <- ceiling(hits / rowsperpg) #calculating last page - starts at 1 not 0
        # pages_lst <- list() #empty list to concatenate results
      }
    
    # Reads atom file to get list of ids    
        result <- read_xml(query)
        result <- xmlParse(result)
        clean_resp <- xmlToDataFrame(result)
        clean_resp <- subset(clean_resp, id!="NA")
        #print(clean_resp$id)
        
    # Loop to read list of ids
        
        for(numrows in 1:(nrow (clean_resp))){
          current_id <- (clean_resp$id[[numrows]])
          # hit_results <- read.csv (file = 'BabyTest.csv')  
          search_pair <- paste (lex_term,searchyr,sep=",")
          thisrow <- which(sapply(hit_results,function (x) current_id %in% x))
          # print (c(search_pair,numrows))

          if (length(thisrow)>0) {
             # add new search pair to pairs vector for the current id
              hit_results <- append (hit_results[[thisrow]],search_pair)
              print (c(hit_results[[thisrow]],search_pair))
             # print (hit_results,file = "BabyTest.csv")
              }
          else {
             # write new row at bottom with new hit ID
              hit_results <- append(hit_results, c(current_id,search_pair))
              print (c("Else",(new_hit_row)))
              # print(hit_results)
              # print(hit_results,file = "BabyTest.csv")
              }  
        }  
          
    page <- page + 1
     
  }
}
}

search_lex <- read.csv("baby_test_search.csv")
names(search_lex) <- c("lex_word,searchyr")

## For testing lex_term <- "asteroid"
## For testing lex_year<- 1852

for(search_row in 1:nrow(search_lex)) {
  lex_term <- search_lex[search_row,1]
  lex_year <- search_lex[search_row,2]
  print(noquote(c("The Current Term is ",lex_term,lex_year)))
  s_hits_by_year(lex_term,lex_year)
}

print("And so say we all...")

