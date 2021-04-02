votes_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui stackable grid padded-grid",
    div(
      class = "three column row",
      div(
        class = "column",
        reddit_segment(
          tagList(
            highcharter::highchartOutput(ns("upvote_plt"), height = "330px")
          )
        )
      ),
      
      div(
        class = "column",
        reddit_segment(
          tagList(
            highcharter::highchartOutput(ns("downvote_plt"), height = "330px")
          )
        )
      ),
      
      div(
        class = "column",
        reddit_segment(
          highcharter::highchartOutput(ns("vote_ratio_plt"), height = "450px")
        )
      )
    )
  )
}
