library(RSelenium)
library(tidyverse)
library(rvest)
library(XML)
library(RCurl)
library(getPass)
library(tsSelect)
library(lubridate)
library(magrittr)
library(httr)
library(stringr)

rd <- rsDriver(browser = "firefox",
               chromever = NULL,
               port= 4450L)

remDr <- rd[["client"]]



remDr$navigate("https://www.infobae.com/")

remDr$maxWindowSize()

Sys.sleep(10)


remDr$findElements("id", "onesignal-slidedown-cancel-button")[[1]]$clickElement()

Sys.sleep(3)

remDr$findElements("id", "hamburger-icon")[[1]]$clickElement()

Sys.sleep(2)

remDr$findElements("id", "search-icon")[[1]]$clickElement()

#remDr$findElements("id", "queryly_search_header_inner")[[1]]$clickElement()
Sys.sleep(2)

search_bar <- remDr$findElement(using = "id", value = "queryly_query")  # Ajusta el "id" según corresponda

Sys.sleep(2)

search_bar$sendKeysToElement(list("web scraping"))

Sys.sleep(5)

remDr$executeScript("window.scrollTo(0, document.body.scrollHeight);")

Sys.sleep(5)

remDr$executeScript("window.scrollTo(0, document.body.scrollHeight);")

Sys.sleep(5)

page_source <- remDr$getPageSource()[[1]]

Sys.sleep(3)

page <- read_html(page_source)


titles <- page %>% html_nodes("div.queryly_item_title") %>% 
  html_text() %>% 
  str_squish()

links <- page %>% 
  html_nodes("div.queryly_item_title") %>% 
  html_elements("a") %>% 
  html_attr("href") 

links <- links[!duplicated(links) ]

raiz <- "https://www.infobae.com"

links_completos <- str_c(raiz, links)

noticia <-  read_html(links_completos[1])

results <- tibble(
  Titulo = as.character(),
  Link = as.character()
)

titulo <- noticia %>% 
  html_element("h1") %>% 
  html_text() %>% 
  str_squish()

cuerpo <- noticia %>% 
  html_element("p.paragraph") %>% 
  html_text() %>% 
  str_squish()


fecha  <- noticia %>% 
  html_element("span.sharebar-article-date") %>% 
  html_text() %>% 
  str_squish()

autor  <- noticia %>% 
  html_element("span.author-name") %>% 
  html_text() %>% 
  str_squish()
#####
tabla_noticias <- function(links){
  
  
  noticia <- read_html(links)
  
  titulo <- noticia %>% 
    html_element("h1") %>% 
    html_text() %>% 
    str_squish()
  
  cuerpo <- noticia %>% 
    html_element("p.paragraph") %>% 
    html_text() %>% 
    str_squish()
  
  
  fecha  <- noticia %>% 
    html_element("span.sharebar-article-date") %>% 
    html_text() %>% 
    str_squish()
  
  autor  <- noticia %>% 
    html_element("span.author-name") %>% 
    html_text() %>% 
    str_squish()
  
  web <- links
  
  tabla_final <- as.data.frame(cbind("titulo"=titulo, "autor" = autor,  "cuerpo"=cuerpo,
                                     "fecha" = fecha, "Link" = web
  ))
  
  return(tabla_final)
  
}
###
noticias <- tibble(
  titulo=character(),
  cuerpo=character(),
  fecha=character(),
  autor= character()
)

for(i in 1:length(links_completos)){
  
  resultado <- tabla_noticias(links_completos[i])
  
  noticias <- noticias %>% 
    bind_rows(resultado)
  
}






