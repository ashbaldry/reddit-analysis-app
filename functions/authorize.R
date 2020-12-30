# These functions allow the app to get a token to run any other API function
#
# More information available here: https://github.com/reddit-archive/reddit/wiki/OAuth2

#' Create Reddit API Authorization URI
#' 
#' Use in a shiny UI within a button/link to send the user to a page to allow the app to use Reddit data.
#' 
#' @details 
#' Client app information available at \url{https://www.reddit.com/prefs/apps}.
#' 
#' @param client_id The ID of the Reddit client app.
#' @param redirect_uri URI of the redirect. Should be the same as the app URL.
#' @param scope Vector of permissions the app requires for APIs..
#' 
#' @return 
#' A URI to request access to Reddit information
#' 
#' @examples
#' library(shiny)
#' tags$a(
#'   class = "ui button", 
#'   href = auth_reddit_uri("client_id", "redirect_uri"),
#'   "Reddit Button"
#' )
auth_reddit_uri <- function(client_id, redirect_uri, scope = c("identity", "read")) {
  uri_state <- paste(sample(c(LETTERS, letters, 0:9), 10, replace = TRUE), collapse = "")
  utils::URLencode(glue::glue(
    "https://www.reddit.com/api/v1/authorize?client_id={client_id}&response_type=code&state={uri_state}&",
    "redirect_uri={redirect_uri}&duration=temporary&scope=", paste0(scope, collapse = " ")
  ))
}

#' Obtain Reddit API Access Token
#' 
#' Once the user has allowed Reddit access, they'll be returned to the \code{redirect_uri}, with the
#' authorization code a query parameter in the URL. Using \code{\link[shiny]{parseQueryString}}, the
#' code can be extracted and used for this function.
#' 
#' This function gets the Bearer token that will be used for all subsequent API calls to Reddit.
#' 
#' @param auth_code Code query parameter obtained when returning from the \code{redirect_uri}.
#' @param redirect_uri URI of the redirect. Should be the same as the app URL.
#' @param client_id The ID of the Reddit client app.
#' @param client_secret The secret of the Reddit client app.
#' 
#' @return 
access_reddit_uri <- function(auth_code, redirect_uri, client_id, client_secret) {
  result <- httr::POST(
    "https://ssl.reddit.com/api/v1/access_token", 
    config = c(httr::authenticate(client_id, client_secret)), 
    body = glue::glue("grant_type=authorization_code&code={auth_code}&redirect_uri={redirect_uri}"),
    httr::content_type("application/x-www-form-urlencoded"),
    httr::user_agent("httr")
  )
  
  httr::content(result)
}