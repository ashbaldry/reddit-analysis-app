# User Information Page
user_page <- shiny::div(
  shiny::h1("User Analysis"),
  shiny::div("Reddit User:", shiny::textOutput("reddit_user", inline = TRUE))
)