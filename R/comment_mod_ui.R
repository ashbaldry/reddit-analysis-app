comments_page_ui <- function(id, type = "Comment") {
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
      class = "three column stretched row",
      div(
        class = "column",
        reddit_segment(
          div(
            class = "ui one stackable statistics",
            div(
              class = "statistic",
              div(id = ns("comm_up_perc"), class = "shiny-text-output value"),
              div(class = "label", glue::glue("{type} Upvote Percent"))
            ),
            div(
              class = "statistic",
              div(id = ns("comm_ratio"), class = "shiny-text-output value"),
              div(class = "label", glue::glue("Upvote to {type} Ratio"))
            ),
            if (type = "Comment") {
              div(
                class = "statistic",
                div(id = ns("comm_contro"), class = "shiny-text-output value"),
                div(class = "label", glue::glue("{type} Controversiality"))
              )
            }
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
    ),
    
    div(
      class = "two column stretched row",
      div(
        class = "column",
        reddit_segment(
          highcharter::highchartOutput(ns("comm_time_plt"), height = "350px")
        )
      ),
      
      div(
        class = "column",
        reddit_segment(NULL)
      )
    )
  )
}
