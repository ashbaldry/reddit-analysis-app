user_home_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui container",
    h1("Reddit Profile Analyzer"),
    div(
      class = "login-prompt",
      a(
        class = "ui huge orange button", 
        href = auth_reddit_uri(client_id, redirect_uri, c("identity", "read", "history", "mysubreddits")), 
        "Sign In"
      )
    ),
    reddit_segment(
      div(
        h2("Hot Post on r/aww:"),
        uiOutput(ns("title"), container = h4),
        uiOutput(ns("post"), class = "centered-reddit-post"),
        tags$br(),
        uiOutput(ns("link"))
      )
    )
  )
}
