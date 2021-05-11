user_home_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui container",
    reddit_segment(
      h2("Welcome!"),
      p("This aim of the app is to provide some insight to your behaviour on the Reddit site. It looks at upvote and 
        downvote history, as well as posts and comments made."),
      p("To see your results, please sign in"),
      a(
        class = "ui inverted orange button", 
        href = auth_reddit_uri(client_id, redirect_uri, c("identity", "read", "history", "mysubreddits")), 
        "Sign In"
      )
    ),
    reddit_segment(
      div(
        h2("Hot Post on r/aww:"),
        textOutput(ns("title"), h4),
        uiOutput(ns("post"), class = "centered-reddit-post")
      )
    )
  )
}
