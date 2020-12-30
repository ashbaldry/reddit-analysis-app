#### Packages ####
library(shiny)
library(shiny.semantic)
library(data.table)
library(httr)
library(glue)

#### Reddit Authentication ####
# RStudio Cloud or local
if (TRUE) {
  client_id <- Sys.getenv("reddit_client_id")
  client_secret <- Sys.getenv("reddit_client_secret")
  redirect_uri <- "https://ashbaldry.shinyapps.io/reddit_analysis/"
} else {
  client_id <- Sys.getenv("local_client_id")
  client_secret <- Sys.getenv("local_client_secret")
  redirect_uri <- "https://ashbaldry.rstudio.cloud/a7c0af4af54646c883dda5c5e84326a6/p/d2440426/"
}

#### Sourcing Scripts ####
# Functions
for (i in list.files("functions", full.names = TRUE)) source(i)
# Pages
for (i in list.files("pages", full.names = TRUE)) source(i)
# CLeanup
remove(i)
