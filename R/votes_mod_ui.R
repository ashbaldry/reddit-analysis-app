votes_page_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    div(
      class = "stretched row",
      div(
        class = "six wide column",
        reddit_segment(
          h2("Information"),
          p("The last 1,000 upvotes and 1,000 downvotes have been pulled from Reddit to determine where and how you 
            vote the most."),
          p("Votes are only based on posts, comment ratings are currently unavailable.")
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
                highcharter::highchartOutput(ns("upvote_plt"), height = "335px")
              )
            ),
            div(
              class = "column",
              reddit_segment(
                highcharter::highchartOutput(ns("downvote_plt"), height = "335px")
              )
            )
            ),
            
            div(
              class = "one column row",
              div(
                class = "column",
                reddit_segment(
                  div(
                    class = "ui right corner label info-popup",
                    shiny.semantic::icon(class = "question mark"),
                    `data-content` = "Looking at the percentage of redditors that also upvoted/downvoted a post you voted on"
                  ),
                  
                  div(
                    tags$label("Subreddit:"),
                    shiny.semantic::dropdown_input(
                      ns("agree_sr"), "All", value = "All",
                      type = "search selection subreddit-search-dd"
                    )
                  ),
                  highcharter::highchartOutput(ns("vote_agree_plt"), height = "340px")
                )
              )
            )
          )
      )
    )
  )
}
