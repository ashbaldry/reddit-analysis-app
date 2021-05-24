user_page_ui <- function(id) {
  ns <- NS(id)
  
  div(
    class = "ui container",
  div(
    class = "ui stackable grid padded-grid",
    div(
      class = "two column row",
      div(
        class = "column",
        div(
          class = "ui horizontal fluid card",
          uiOutput(class = "image", ns("user_icon")),
          div(
            class = "content",
            div(class = "header shiny-text-output", id = ns("user_name")),
            div(
              class = "meta", 
              div(
                reddit_karma_icon("banner-karma-icon"),
                span(class = "shiny-text-output", id = ns("total_karma")), "karma"
              ),
              div(
                tags$i(class = "birthday cake icon cake-day-icon"),
                span(class = "date shiny-text-output", id = ns("cake_day"))  
              )
            )
          )
        ),
        
        reddit_segment(
          div(
            class = "ui one statistics",
            div(
              class = "statistic",
              div(id = ns("n_subreddit"), class = "shiny-text-output value"),
              div(class = "label", "Subreddits Subscribed To")
            )
          )
        )
      ),
      
      div(
        class = "column",
        reddit_segment(
          div(
            class = "ui two stackable statistics",
            div(
              class = "statistic",
              div(id = ns("post_karma"), class = "shiny-text-output value"),
              div(class = "label", "Submission Karma")
            ),
            div(
              class = "statistic",
              div(id = ns("comm_karma"), class = "shiny-text-output value"),
              div(class = "label", "Comment Karma")
            ),
            div(
              class = "statistic",
              div(id = ns("awarder_karma"), class = "shiny-text-output value"),
              div(class = "label", "Awarder Karma")
            ),
            div(
              class = "statistic",
              div(id = ns("awardee_karma"), class = "shiny-text-output value"),
              div(class = "label", "Awardee Karma")
            )
          )
        )
      )
      
    )
  )
  )
}
