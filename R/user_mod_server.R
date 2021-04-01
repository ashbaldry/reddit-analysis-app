user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  #### User Info ####
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  #### Posts ####
  user_posts <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_posts()
  })
  
  #### Post Stats ####
  post_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$link_karma
  })
  output$post_karma <- renderText(post_karma())
  
  post_score <- reactive({
    if (is.null(user_posts()) || !nrow(user_posts())) return(NA)
    user_posts()[, sum(score)]
  })
  output$post_score <- renderText(post_score())
  
  post_up_cnt <- reactive({
    if (is.null(user_posts()) || !nrow(user_posts())) return(NULL)
    user_posts()[, sum(ups)]
  })
  
  post_down_cnt <- reactive({
    if (is.null(user_posts()) || !nrow(user_posts())) return(NULL)
    user_posts()[, sum(ups / upvote_ratio * (1 - upvote_ratio))]
  })
  
  post_ratio <- reactive({
    if (is.null(user_posts()) || !nrow(user_posts())) return(NA_real_)
    post_up_cnt() / (post_up_cnt() + post_down_cnt())
  })
  output$post_ratio <- renderText(scales::percent(post_ratio()))
  
  #### Comments ####
  user_comments <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_comments()
  })
  
  #### Comment Stats ####
  comm_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$comment_karma
  })
  output$comm_karma <- renderText(comm_karma())
  
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
  
  comm_ratio <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_real_)
    comm_up_cnt() / (comm_up_cnt() + comm_down_cnt())
  })
  output$comm_ratio <- renderText(scales::percent(comm_ratio()))
  
  comm_controversiality <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NA_real_)
    user_comments()[, mean(controversiality)]
  })
  output$comm_contro <- renderText(scales::percent(comm_controversiality()))
  
  #### Comments ####
  comm_words <- reactive({
    if (is.null(user_comments()) || !nrow(user_comments())) return(NULL)
    get_comment_words(user_comments())
  })
  
  output$comm_word_cloud <- highcharter::renderHighchart({
    word_freq_cloud(comm_words())
  })
  
  #### Upvotes/Downvotes ####
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

  output$vote_plt <- highcharter::renderHighchart({
    if (input$vote_updown == "Upvotes") {
      votes_chart(user_upvotes(), color = "#FF8B60", label = "Upvotes")
    } else {
      votes_chart(user_downvotes(), color = "#9494FF", label = "Downvotes")
    }
  })
  
  output$vote_ratio_plt <- highcharter::renderHighchart({
    vote_ratio_chart(user_upvotes(), user_downvotes())
  })
}