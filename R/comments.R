#' Get Reddit User Comments
get_user_comments <- function(user_name, access_token) {
  res <- httr::GET(
    glue::glue("https://oauth.reddit.com/user/{user_name}/comments"),
    httr::add_headers(Authorization = access_token),
    httr::user_agent("httr")
  )
  
  httr::stop_for_status(res)
  
  cont <- jsonlite::fromJSON(httr::content(res, as = "text"))
  out_dt <- cont$data$children$data
  count <- nrow(out_dt)
  
  while (!is.null(cont$data$after) && count < 1000) {
    res <- httr::GET(
      glue::glue("https://oauth.reddit.com/user/{user_name}/comments"),
      httr::add_headers(Authorization = access_token),
      httr::user_agent("httr"),
      query = list(after = cont$data$after, count = count)
    )
    
    httr::stop_for_status(res)
    
    cont <- jsonlite::fromJSON(httr::content(res, as = "text"))
    out_dt <- rbind(out_dt, cont$data$children$data)
    count <- nrow(out_dt)
  }
  
  suppressWarnings(setDT(out_dt))
  out_dt[]
}

get_user_posts <- function(user_name, access_token) {
  res <- httr::GET(
    glue::glue("https://oauth.reddit.com/user/{user_name}/submitted"),
    httr::add_headers(Authorization = access_token),
    httr::user_agent("httr")
  )
  
  httr::stop_for_status(res)
  
  clean_post_data <- function(x) {
    y <- x$data
    y$preview <- list(y$preview)
    y
  }
  
  cont <- httr::content(res)
  out_lst <- lapply(cont$data$children, clean_post_data)
  count <- length(out_lst)
  
  while (!is.null(cont$data$after) && count < 1000) {
    res <- httr::GET(
      glue::glue("https://oauth.reddit.com/user/{user_name}/submitted"),
      httr::add_headers(Authorization = access_token),
      httr::user_agent("httr"),
      query = list(after = cont$data$after, count = count)
    )
    
    httr::stop_for_status(res)
    
    cont <- jsonlite::fromJSON(httr::content(res, as = "text"))
    out_lst <- append(out_lst, lapply(cont$data$children, function(x) x$data))
    count <- length(out_lst)
  }
  
  suppressWarnings(rbindlist(out_lst, use.names = TRUE, fill = TRUE))
}
