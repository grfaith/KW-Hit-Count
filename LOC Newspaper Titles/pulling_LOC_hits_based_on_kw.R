##### Preliminaries

library(httr)
library(dplyr)
library(tidyr)
library(XML)
library(xml2)

setwd("C:\\Users\\grfai\\Documents\\0_Dissertation\\Code\\ChronAm\\LOC Newspaper Titles")

baseurl <- "https://chroniclingamerica.loc.gov/search/pages/results/"

rowsperpg <- 1000

kw_file="keyword_hit_totals_by_year.csv"

#### Creating Hit Table, key words, etc.
key_words <- read.csv(file=kw_file,sep=",")
key_words <- key_words$Term
key_words <- key_words[!duplicated(key_words)]

hit_table = data.frame(matrix(nrow=0,ncol=(length(key_words)+1)))
colnames(hit_table) = c("search_id",key_words)
write.table (hit_table,file="init_file.csv", sep=",")


# s_term <- "asteroid"
# s_year <- 1857


##### Function

s_hits = function (s_term,s_year) {

  page <- 1
  maxPages <- 1
  hits <-0
  hit_table <- read.csv (file="init_file.csv")

  
  

  
  
  search_pause <- 8
  
  ### pages loop
  while(page <= maxPages) {
  
    query <- paste0(baseurl,
                    "?",
                    "dateFilterType=yearRange&date1=",s_year,"&date2=",s_year,
                    "&andtext=",s_term,
                    "&page=",page, 
                    "&rows=",rowsperpg,
                    "&language=eng",
                    "&searchType=advanced",
                    "&format=atom")
   
    xmlresp <- try(read_xml(GET(query))) #introducing error handling segment here
      while (inherits(xmlresp,"try-error")) {
        message ("Pausing search...")
        Sys.sleep (900) #Takes a fifteen minute break if there's an error
        xmlresp <- try(read_xml(GET(query))) #Try again
        }
    #update maxpages
    if(page==1){
      hits <- xml_text(xml_find_all(xmlresp,xpath="//opensearch:totalResults")) #total hits from query
      hits <- as.integer(hits)
      maxPages <- ceiling(hits / rowsperpg) #calculating last page - starts at 1 not 0
      pages_lst <- list() #empty list to concatenate results
    }
    # Reads atom file to get list of ids    
    result <- read_xml(query)
    result <- xmlParse(result)
    clean_resp <- xmlToDataFrame(result)
    clean_resp <- subset(clean_resp, id!="NA")

#### Loop several times to get all pages of results 
    
    for(numrows in 1:(nrow (clean_resp))) {
      current_id <- (clean_resp$id[[numrows]])
      current_id <- gsub("info:lc/ndnp/lccn/","",current_id)

          if (isFALSE(current_id %in% hit_table$search_id)) {
            
            
            new_row = data.frame(matrix(0,nrow=1,ncol=(1+length(key_words))))
            colnames(new_row) = c("search_id",key_words)
            new_row$search_id <- current_id
            hit_table <- rbind (hit_table,new_row)
          } 
          
      add_to_row <- which(hit_table$search_id == current_id) 
      add_to_col <- which(colnames(hit_table) == s_term)
      hit_table[add_to_row,add_to_col] <- hit_table[add_to_row,add_to_col] + 1
      } 
    write.table (hit_table,file=myfile, sep=",", row.names=FALSE, quote = FALSE)
    Sys.sleep(search_pause)
    page <- page + 1
    
    }   
}


###Sys.sleep(120) ### Pause for remote desktop access (so you can log off before this starts)

##### Loop through the Lex

search_lex <- read.csv(kw_file)
names(search_lex) <- c("lex_term,lex_year")

for(search_row in 1:nrow(search_lex)) {
  lex_term <- search_lex[search_row,1]
  lex_year <- search_lex[search_row,2]
  lex_count <- search_lex[search_row,3]
  if (lex_count >0) {
    print (Sys.time())
    print(noquote(c("The Current Term is ",lex_term,lex_year," ")))
    s_hits(lex_term,lex_year)
  }
}
