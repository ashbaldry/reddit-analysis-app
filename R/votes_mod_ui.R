votes_page_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    div(
      class = "ui top aligned modal", id = ns("vote_modal"),
      h4(class = "ui header", "Pulling upvoted and downvoted posts from Reddit..."),
      div(
        class = "content", 
        div(class = "ui large inline centered active orange loader")
      )
    ),
    tags$script(
      glue::glue(
        "Shiny.initSemanticModal('[ns('vote_modal')]');
         $('#[ns('vote_modal')]').modal({context: 'main', closable: false});",
        .open = "[", .close = "]"
      )
    ),
    div(
      class = "three column row",
      div(
        class = "column",
        reddit_segment(
          highcharter::highchartOutput(ns("upvote_plt"), height = "330px")
        )
      ),
      
      div(
        class = "column",
        reddit_segment(
          highcharter::highchartOutput(ns("downvote_plt"), height = "330px")
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
