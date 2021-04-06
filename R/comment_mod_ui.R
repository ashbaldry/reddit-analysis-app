comments_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    div(
      class = "ui modal", id = ns("comments_modal"),
      div(
        class = "content", 
        h4("Pulling posts and comments from Reddit..."),
        div(class = "ui large active orange loader")
      )
    ),
    tags$script(
      glue::glue(
        "Shiny.initSemanticModal('[ns('comments_modal')]');
         $('#[ns('comments_modal')]').modal({context: '#[ns('page_grid')]', closable: false});",
        .open = "[", .close = "]"
      )
    ),
    div(
      class = "three column row",
      div(
        class = "column",
        reddit_segment(
          div(
            class = "ui two statistics",
            div(
              class = "statistic",
              div(id = ns("post_ratio"), class = "shiny-text-output value"),
              div(class = "label", "Post Upvote Ratio")
            ),
            div(
              class = "statistic",
              div(id = ns("comm_ratio"), class = "shiny-text-output value"),
              div(class = "label", "Comment Upvote Ratio")
            ),
            div(
              class = "statistic",
              div(id = ns("comm_contro"), class = "shiny-text-output value"),
              div(class = "label", "Comment Controversiality")
            )
          )
        )
      ),
      div(
        class = "column",
        reddit_segment(
          highcharter::highchartOutput(ns("comm_word_cloud"), height = "350px")
        )
      ),
      
      div(
        class = "column",
        reddit_segment(NULL)
      )
    )
  )
}
