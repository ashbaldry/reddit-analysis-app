# Subreddit Page
sub_page <- shiny::div(
  shiny::h1("Reddit Analysis"),
  shiny::div(
    id = "sub_search", class = "ui search subreddit-search",
    shiny::div(
      class = "ui left icon input",
      tags$input(class = "prompt", type = "text", placeholder = "Search Subreddit"),
      tags$i(class = "reddit icon")
    )
  ),
  shiny::div("Subreddit Selected:", shiny::textOutput("selected_sub", inline = TRUE))
)