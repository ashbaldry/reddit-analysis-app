user_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui stackable grid padded-grid",
    div(
      class = "row",
      h1("User Analysis")
    ),
    div(
      class = "three column row",
      div(
        class = "column",
        div(
          class = "ui card",
          div(class = "image shiny-html-output", id = ns("avatar")),
          div(
            class = "content",
            div(class = "header", textOutput(ns("username")))
          )
        )
      )
    )
  )
}
