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
        class = "column",
        reddit_segment(
          NULL,
          div(
            class = "ui two statistics",
            div(
              class = "statistic",
              div(id = ns("post_karma"), class = "shiny-text-output value"),
              div(class = "label", "Post Karma")
            ),
            div(
              class = "statistic",
              div(id = ns("comm_karma"), class = "shiny-text-output value"),
              div(class = "label", "Comment Karma")
            ),
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
              div(id = ns("post_contro"), class = "shiny-text-output value"),
              div(class = "label", "Post Controversiality")
            ),
            div(
              class = "statistic",
              div(id = ns("comm_contro"), class = "shiny-text-output value"),
              div(class = "label", "Comment Controversiality")
            )
          )
        ),
        reddit_segment(
          NULL,
          highcharter::highchartOutput(ns("comm_word_cloud"), height = "350px")
        )
      ),
      
      div(
        class = "column",
        reddit_segment(
          NULL,
          tagList(
            form(
              multiple_radio(ns("vote_updown"), NULL, c("Upvotes", "Downvotes"), selected = "Upvotes", position = "inline")
            ),
            highcharter::highchartOutput(ns("vote_plt"), height = "350px")
          )
        ),
        reddit_segment(
          NULL,
          highcharter::highchartOutput(ns("vote_ratio_plt"), height = "350px")
        )
      )
    )
  )
}
