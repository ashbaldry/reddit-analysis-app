votes_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  user_upvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_upvotes()
  })
  
  user_downvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_downvotes()
  })
  
  output$upvote_plt <- highcharter::renderHighchart({
    votes_chart(user_upvotes(), color = "#FF8B60", label = "Upvotes")
  })
  
  output$downvote_plt <- highcharter::renderHighchart({
    votes_chart(user_downvotes(), color = "#9494FF", label = "Downvotes")
  })
  
  output$vote_ratio_plt <- highcharter::renderHighchart({
    vote_ratio_chart(user_upvotes(), user_downvotes())
  })
}