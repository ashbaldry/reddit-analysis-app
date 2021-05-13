comments_page_server <- function(input, output, session, reddit, rr, type = "Comments", text_col = "body") {
  ns <- session$ns
  
  #### Data Pull ####
  user_comments <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    dt <- reddit[[glue::glue("get_user_{tolower(type)}")]](max_posts = 1000)
    dt
  })
  
  #### Post Stats ####
  comment_time <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA)
    comment_time_chart(user_comments(), label = type)
  })
  
  output$comm_time_plt <- highcharter::renderHighchart(comment_time())
  
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
  
  #### Comments ####
  comm_words <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NULL)
    get_comment_words(user_comments(), text_col)
  })
  
  output$comm_word_cloud <- highcharter::renderHighchart({
    word_freq_cloud(comm_words())
  })
}