#### Packages ####
library(shiny)
library(shiny.semantic)
library(highcharter)
library(data.table)
library(quanteda)
library(magrittr)
library(httr)
# library(promises)
# library(future)

#### Multi-Session ####
# plan(multisession)

#### Reddit Authentication ####
# RStudio Cloud or local
if (!interactive()) {
  client_id <- Sys.getenv("reddit_client_id")
  client_secret <- Sys.getenv("reddit_client_secret")
  redirect_uri <- "https://ashbaldry.shinyapps.io/reddit_analysis/"
} else {
  client_id <- Sys.getenv("local_client_id")
  client_secret <- Sys.getenv("local_client_secret")
  redirect_uri <- "http://127.0.0.1:8100"
}

#### Highcharts ####
hc_opts <- getOption("highcharter.chart")
hc_opts$chart$style$fontFamily <- "Noto Sans"
options(highcharter.chart = hc_opts)
