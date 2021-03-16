user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  #### Upvotes ####
  user_upvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_upvotes()
  })
  
  output$upvote_plt <- highcharter::renderHighchart({
    votes_chart(user_upvotes(), color = "FF8B60", label = "Upvotes")
  })
  
  #### Downvotes ####
  user_downvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_downvotes()
  })

  output$downvote_plt <- highcharter::renderHighchart({
    votes_chart(user_downvotes(), color = "9494FF", label = "Downvotes")
  })
}