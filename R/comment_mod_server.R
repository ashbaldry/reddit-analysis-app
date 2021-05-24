comments_page_server <- function(input, output, session, reddit, rr, type = "Comments", text_col = "body") {
  ns <- session$ns
  
  #### Data Pull ####
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  user_comments <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit[[glue::glue("get_user_{tolower(type)}")]](max_posts = 1000)
  })
  
  #### Post Stats ####
  comment_time <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA)
    comment_time_chart(user_comments(), label = type)
  })
  
  output$comm_time_plt <- highcharter::renderHighchart(comment_time())
  
  karma_time <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA)
    comment_karma_tl(
      user_comments(), 
      label = type,
      cake_day = as.Date(as.POSIXct(user_info()$created_utc, origin = "1970-01-01", tz = "UTC"))
    )
  })
  
  output$karma_time_plt <- highcharter::renderHighchart(karma_time())
  
  #### Comment Stats ####
  comm_score <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA)
    user_comments()[, sum(score)]
  })
  output$comm_score <- renderText(comm_score())
  
  comm_up_cnt <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NULL)
    user_comments()[, sum(ups)]
  })
  
  comm_down_cnt <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NULL)
    user_comments()[, sum(downs)]
  })
  
  comm_up_perc <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_real_)
    comm_up_cnt() / (comm_up_cnt() + comm_down_cnt())
  })
  output$comm_up_perc <- renderText(scales::percent(comm_up_perc()))
  
  comm_ratio <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_real_)
    user_comments()[, mean(score)]
  })
  output$comm_ratio <- renderText(scales::number(comm_ratio(), accuracy = 0.1))
  
  comm_controversiality <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_real_)
    user_comments()[, mean(controversiality)]
  })
  output$comm_contro <- renderText(scales::percent(comm_controversiality()))
  
  #### Top/Bottom Comments ####
  comm_top_comment <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_character_)
    user_comments()[which.max(score)]
  })
  
  comm_top_title <- reactive({
    if (!inherits(comm_top_comment(), "data.table")) comm_top_comment()
    if (type == "Posts") comm_top_comment()$title else comm_top_comment()$body
  })
  output$comm_top_title <- renderText(comm_top_title())

  comm_top_time <- reactive({
    if (!inherits(comm_top_comment(), "data.table")) comm_top_comment()
    format(comm_top_comment()$created, format = "%d %B %Y")
  })
  output$comm_top_time <- renderText(comm_top_time())
  
  comm_top_subreddit <- reactive({
    if (!inherits(comm_top_comment(), "data.table")) comm_top_comment()
    comm_top_comment()$subreddit_name_prefixed
  })
  output$comm_top_subreddit <- renderText(comm_top_subreddit())
  
  comm_top_karma <- reactive({
    if (!inherits(comm_top_comment(), "data.table")) comm_top_comment()
    comm_top_comment()$score
  })
  output$comm_top_karma <- renderText(comm_top_karma())
  
  comm_top_link <- reactive({
    if (!inherits(comm_top_comment(), "data.table")) comm_top_comment()
    tags$a(
      href = paste0("https://www.reddit.com", comm_top_comment()$permalink),
      target = "_blank",
      "Link"
    )
  })
  output$comm_top_link <- renderUI(comm_top_link())
  
  comm_low_comment <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_character_)
    user_comments()[which.min(score)]
  })
  
  comm_low_title <- reactive({
    if (!inherits(comm_low_comment(), "data.table")) comm_low_comment()
    if (type == "Posts") comm_low_comment()$title else comm_low_comment()$body
  })
  output$comm_low_title <- renderText(comm_low_title())
  
  comm_low_time <- reactive({
    if (!inherits(comm_low_comment(), "data.table")) comm_low_comment()
    format(comm_low_comment()$created, format = "%d %B %Y")
  })
  output$comm_low_time <- renderText(comm_low_time())
  
  comm_low_subreddit <- reactive({
    if (!inherits(comm_low_comment(), "data.table")) comm_low_comment()
    comm_low_comment()$subreddit_name_prefixed
  })
  output$comm_low_subreddit <- renderText(comm_low_subreddit())
  
  comm_low_karma <- reactive({
    if (!inherits(comm_low_comment(), "data.table")) comm_low_comment()
    comm_low_comment()$score
  })
  output$comm_low_karma <- renderText(comm_low_karma())
  
  comm_low_link <- reactive({
    if (!inherits(comm_low_comment(), "data.table")) comm_low_comment()
    tags$a(
      href = paste0("https://www.reddit.com", comm_low_comment()$permalink),
      target = "_blank",
      "Link"
    )
  })
  output$comm_low_link <- renderUI(comm_low_link())
  
  #### Comments ####
  comm_words <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NULL)
    get_comment_words(user_comments(), text_col)
  })
  
  output$comm_word_cloud <- highcharter::renderHighchart({
    word_freq_cloud(comm_words(), label = type)
  })
}