user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  #### User Info ####
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  output$user_icon <- renderUI({
    if (is.null(user_info())) return(tags$img()) else tags$img(src = user_info()$icon_img)
  })
  
  output$user_name <- renderText(if (is.null(user_info())) NA else user_info()$name)
  output$cake_day <- renderText({
    if (is.null(user_info())) return(NA)
    format(as.Date(as.POSIXct(user_info()$created_utc, origin = "1970-01-01", tz = "UTC")), format = "%d %B %Y")
  })
  
  #### Karma ####
  output$total_karma <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_info()$total_karma))
  output$post_karma <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_info()$link_karma))
  output$comm_karma <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_info()$comment_karma))
  output$awarder_karma <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_info()$awarder_karma))
  output$awardee_karma <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_info()$awardee_karma))
  
  #### Subreddits ####
  user_subreddits <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_subscribed_subreddits() 
  })
  
  output$n_subreddit <- renderText(if (is.null(user_info())) return(NA) else scales::comma(user_subreddits()[, .N]))
  
  #### Subreddit Karma ####
  user_subreddit_karma <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_subreddit_karma() 
  })
  
  output$karma_plt <- highcharter::renderHighchart({
    yaxis_col <- if (input$karma_toggle) "comment_karma" else "link_karma"
    karma_subreddit_chart(user_subreddit_karma(), yaxis_col = yaxis_col)
  })
}