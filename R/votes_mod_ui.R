votes_page_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    modal(
      id = ns("vote_modal"),
      content = "Pulling upvote/downvote data from Reddit...",
      footer = NULL,
      div(class = "ui large active orange loader")
    ),
    tags$script(
      glue::glue("$('#[ns('vote_modal')]').modal({context: '#[ns('page_grid')]', closable: false});", .open = "[", .close = "]")
    ),
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
