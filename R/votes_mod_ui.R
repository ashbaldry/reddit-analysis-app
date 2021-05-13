votes_page_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "ui stackable grid padded-grid", id = ns("page_grid"),
    div(
      class = "ui top aligned modal", id = ns("vote_modal"),
      h4(class = "ui header", "Pulling upvoted and downvoted posts from Reddit (this may take a while)..."),
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
      class = "row",
      div(
        class = "six wide column",
        reddit_segment(
          h2("Information"),
          p("The last 1,000 upvotes and 1,000 downvotes have been pulled from Reddit to determine where you vote the most."),
          p()
        ),
        
        reddit_segment(
          highcharter::highchartOutput(ns("vote_ratio_plt"), height = "450px")
        )
      ),
      
      div(
        class = "ten wide column",
        div(
          class = "ui grid",
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
            ),
            
            div(
              class = "one column row",
              div(
                class = "column",
                div(
                  class = "ui form",
                  tags$label("Subreddit:"),
                  shiny.semantic::dropdown_input(ns("agree_sr"), "All", type = "inline search selection"),
                ),
                reddit_segment(
                  highcharter::highchartOutput(ns("vote_agree_plt"), height = "300px")
                )
              )
            )
          )
        )
      )
    )
  )
}
