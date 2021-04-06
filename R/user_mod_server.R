user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  #### User Info ####
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  output$user_icon <- renderUI({
    rr()
    if (!reddit$is_authorized()) return(tags$img())
    tags$img(src = reddit$user_info$icon_img)
  })
  
  output$user_name <- renderText({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$user_info$name
  })
  
  output$account_age <- renderText({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    start_time <- as.Date(as.POSIXct(reddit$user_info$created_utc, origin = "1970-01-01", tz = "UTC"))
    curr_time <- as.Date(lubridate::with_tz(Sys.time(), tzone = "UTC"))
    years <- year(curr_time) - year(start_time) - (month(curr_time) < month(start_time))
    if (as.numeric(curr_time) %% 365 >= as.numeric(start_time) %% 365) {
      months <- month(curr_time) - month(start_time) - (mday(curr_time) < mday(start_time))
    } else {
      months <- 12 - month(curr_time) + month(start_time) - (mday(curr_time) < mday(start_time))
    }
    
    glue::glue("Account Age: {years} year{if (years != 1) 's' else ''} {months} month{if (months != 1) 's' else ''}")
  })
  
  #### Post Stats ####
  post_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$link_karma
  })
  output$post_karma <- renderText(post_karma())
  
  comm_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$comment_karma
  })
  output$comm_karma <- renderText(comm_karma())
}