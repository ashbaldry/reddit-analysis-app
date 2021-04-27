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
  
  output$user_name <- renderText(if (is.null(user_info())) return(NA) else user_info()$name)
  output$cake_day <- renderText({
    if (is.null(user_info())) return(NA)
    format(as.Date(as.POSIXct(user_info()$created_utc, origin = "1970-01-01", tz = "UTC")), format = "%d %B %Y")
  })
  
  output$account_age <- renderText({
    if (is.null(user_info())) return(NA)
    start_time <- as.Date(as.POSIXct(user_info()$created_utc, origin = "1970-01-01", tz = "UTC"))
    curr_time <- as.Date(lubridate::with_tz(Sys.time(), tzone = "UTC"))
    years <- year(curr_time) - year(start_time) - (month(curr_time) < month(start_time))
    if (as.numeric(curr_time) %% 365 >= as.numeric(start_time) %% 365) {
      months <- month(curr_time) - month(start_time) - (mday(curr_time) < mday(start_time))
    } else {
      months <- 12 + (month(curr_time) - month(start_time)) - (mday(curr_time) < mday(start_time))
    }
    
    glue::glue("Account Age: {years} year{if (years != 1) 's' else ''} {months} month{if (months != 1) 's' else ''}")
  })
  
  #### Karma ####
  output$total_karma <- renderText(if (is.null(user_info())) return(NA) else user_info()$total_karma)
  output$post_karma <- renderText(if (is.null(user_info())) return(NA) else user_info()$link_karma)
  output$comm_karma <- renderText(if (is.null(user_info())) return(NA) else user_info()$comment_karma)
  output$awarder_karma <- renderText(if (is.null(user_info())) return(NA) else user_info()$awarder_karma)
  output$awardee_karma <- renderText(if (is.null(user_info())) return(NA) else user_info()$awardee_karma)
}