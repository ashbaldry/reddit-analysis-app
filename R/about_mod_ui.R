about_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui basic container",
    reddit_segment(
      h3("About"),
      p("This application was designed to be an analysis of user activity on the Reddit social media platform.",
        "The UI has been created to emulate the look of the 'new' Reddit web interface."),
      p("Many similar applications provide analysis on posts and comments through publicly available APIs.",
        "In this application there is also insight on upvotes and downvotes, which is why authentication is",
        "required to access the analysis."),
      p("There is a 1,000 limit on the number of votes/posts pulled to prevent the data pull to take too long."),
    ),
    div(
      class = "ui warning message",
      div(class = "header", "Disclaimer"),
      div(
        class = "content",
        "This application is not associated to Reddit. Only data that is required for user analysis is requested",
        "through authentication, and no user data is stored when exiting/signing out of the application."
      )
    )
  )
}
