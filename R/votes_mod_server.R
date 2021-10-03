votes_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  user_upvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_upvotes(max_posts = 1000)
  })
  
  user_downvotes <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    dt <- reddit$get_user_downvotes(max_posts = 1000)
    dt
  })
  
  observeEvent(user_downvotes(), {
    if (!reddit$is_authorized()) {
      shiny.semantic::update_dropdown_input(session, "agree_sr", "All", value = "All")      
    } else {
      dt <- rbindlist(list(user_upvotes()[, .(subreddit_name_prefixed)], user_downvotes()[, .(subreddit_name_prefixed)]))
      shiny.semantic::update_dropdown_input(
        session, "agree_sr", 
        choices = dt[, .N, by = .(subreddit_name_prefixed)][order(-N), c("All", subreddit_name_prefixed)],
        value = "All"
      )
    }
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
  
  output$vote_time_plt <- highcharter::renderHighchart({
    vote_time_chart(user_upvotes(), user_downvotes())
  })
  
  vote_agree_rdt <- reactive(vote_agree_data(user_upvotes(), user_downvotes()))
  
  output$vote_agree_plt <- highcharter::renderHighchart({
    dt <- vote_agree_rdt()
    if (input$agree_sr != "All") dt <- dt[subreddit == input$agree_sr]
    vote_agree_chart(dt)
  })
}
