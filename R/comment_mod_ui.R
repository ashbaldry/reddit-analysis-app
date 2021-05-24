comments_page_ui <- function(id, type = "Comment") {
  ns <- NS(id)
  
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
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
              div(class = "label", glue::glue("Karma Per {type}"))
            ),
            if (type == "Comment") {
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
        reddit_segment(
            class = "top-low-comment",
            div(
              class = "ui orange message",
              div(
                class = "content",
                div(
                  class = "item",
                  div(
                    class = "content",
                    div(class = "header", glue::glue("Top {type}")),
                    div(
                      class = "meta",
                      textOutput(ns("comm_top_subreddit"), inline = TRUE)
                    ),
                    div(class = "description", textOutput(ns("comm_top_title"), tags$p)),
                    div(
                      class = "extra",
                      textOutput(ns("comm_top_time"), inline = TRUE),
                      " - ",
                      textOutput(ns("comm_top_karma"), inline = TRUE),
                      "karma - ",
                      uiOutput(ns("comm_top_link"), inline = TRUE)
                    )
                  )
                )
              )
            ),
            div(
              class = "ui blue message",
              div(
                class = "content",
                div(
                  class = "item",
                  div(
                    class = "content",
                    div(class = "header", glue::glue("Worst {type}")),
                    div(
                      class = "meta",
                      textOutput(ns("comm_low_subreddit"), inline = TRUE)
                    ),
                    div(class = "description", textOutput(ns("comm_low_title"), tags$p)),
                    div(
                      class = "extra",
                      textOutput(ns("comm_low_time"), inline = TRUE), 
                      " - ",
                      textOutput(ns("comm_low_karma"), inline = TRUE),
                      "karma - ",
                      uiOutput(ns("comm_low_link"), inline = TRUE)
                    )
                  )
                )
              )
            )
          )
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
        reddit_segment(
          div(
            class = "ui right corner label info-popup",
            `data-content` = "Karma based on time of posting rather than when voted on",
            shiny.semantic::icon(class = "question mark")
          ),
          highcharter::highchartOutput(ns("karma_time_plt"), height = "350px")
        )
      )
    )
  )
}
