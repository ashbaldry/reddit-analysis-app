user_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui stackable grid padded-grid",
    div(
      class = "three column row",
      div(
        class = "column"
      ),
      div(
        class = "column"
      ),
      div(
        class = "column",
        div(
          class = "ui orange segment",
          highcharter::highchartOutput(ns("upvote_plt"), height = "300px")
        ),
        div(
          class = "ui blue segment",
          highcharter::highchartOutput(ns("downvote_plt"), height = "300px")
        )
      )
    )
  )
}
