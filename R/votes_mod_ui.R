votes_page_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    div(
      class = "row",
      div(
        class = "six wide column",
        reddit_segment(
          h2("Information"),
          p("The last 1,000 upvotes and 1,000 downvotes have been pulled from Reddit to determine where you vote the most."),
          p()
        ),
        
        reddit_segment(
          highcharter::highchartOutput(ns("vote_ratio_plt"), height = "588px")
        )
      ),
      
      div(
        class = "ten wide column",
        div(
          class = "ui stackable grid",
          div(
            class = "two column row",
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
            )
            ),
            
            div(
              class = "one column row",
              div(
                class = "column",
                reddit_segment(
                  div(
                    class = "ui form",
                    tags$label("Subreddit:"),
                    shiny.semantic::dropdown_input(
                      ns("agree_sr"), "All", value = "All",
                      type = "inline search selection subreddit-search-dd"
                    ),
                  ),
                  highcharter::highchartOutput(ns("vote_agree_plt"), height = "300px")
                )
              )
            )
          )
      )
    )
  )
}
