get_user_activity <- function(user_name, access_token, api_call = "comments", max_posts = 1000) {
  res <- httr::GET(
    glue::glue("https://oauth.reddit.com/user/{user_name}/{api_call}"),
    httr::add_headers(Authorization = access_token),
    httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)"))
  )
  
  httr::stop_for_status(res)
  
  clean_post_data <- function(x) {
    y <- x$data
    
    y_len <- sapply(y, length)
    y <- y[y_len > 0]
    
    multi_items <- intersect(
      c("preview", "gildings", "all_awardings", "media_embed", "secure_media", 
        "secure_media_embed", "media", "link_flair_richtext"),
      names(y)
    )
    for (i in multi_items) y[[i]] <- list(y[[i]])
    
    y$created <- as.POSIXct(y$created, origin = "1970-01-01", tz = "UTC")
    y$created_utc <- as.POSIXct(y$created_utc, origin = "1970-01-01", tz = "UTC")
    
    as.data.table(y)
  }
  
  cont <- httr::content(res)
  out_lst <- lapply(cont$data$children, clean_post_data)
  count <- length(out_lst)
  
  while (!is.null(cont$data$after) && count < max_posts) {
    res <- httr::GET(
      glue::glue("https://oauth.reddit.com/user/{user_name}/{api_call}"),
      httr::add_headers(Authorization = access_token),
      httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)")),
      query = list(after = cont$data$after, count = count)
    )
    
    httr::stop_for_status(res)
    
    cont <- httr::content(res)
    out_lst <- append(out_lst, lapply(cont$data$children, clean_post_data))
    count <- length(out_lst)
  }
  
  rbindlist(out_lst, use.names = TRUE, fill = TRUE)
}

get_subreddit_karma <- function(access_token) {
  res <- httr::GET(
    glue::glue("https://oauth.reddit.com/api/v1/me/karma"),
    httr::add_headers(Authorization = access_token),
    httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)"))
  )
  
  httr::stop_for_status(res)
  
  rbindlist(httr::content(res)$data, use.names = TRUE, fill = TRUE)
}

get_subscribed_subreddits <- function(access_token) {
  res <- httr::GET(
    glue::glue("https://oauth.reddit.com/subreddits/mine/subscriber"),
    httr::add_headers(Authorization = access_token),
    httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)")),
    query = list(show = "all", limit = 100)
  )
  
  httr::stop_for_status(res)
  
  clean_post_data <- function(x) {
    y <- x$data
    
    y_len <- sapply(y, length)
    y <- y[y_len > 0]
    
    multi_items <- intersect(
      c("preview", "gildings", "all_awardings", "media_embed", "secure_media", 
        "secure_media_embed", "media", "link_flair_richtext", 
        "icon_size", "header_size", "banner_size", "user_flair_richtext", "emojis_custom_size"),
      names(y)
    )
    for (i in multi_items) y[[i]] <- list(y[[i]])
    
    y$created <- as.POSIXct(y$created, origin = "1970-01-01", tz = "UTC")
    y$created_utc <- as.POSIXct(y$created_utc, origin = "1970-01-01", tz = "UTC")
    
    as.data.table(y)
  }
  
  cont <- httr::content(res)
  out_lst <- lapply(cont$data$children, clean_post_data)
  count <- length(out_lst)
  
  while (!is.null(cont$data$after)) {
    res <- httr::GET(
      glue::glue("https://oauth.reddit.com/subreddits/mine/subscriber"),
      httr::add_headers(Authorization = access_token),
      httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)")),
      query = list(after = cont$data$after, count = count)
    )
    
    httr::stop_for_status(res)
    
    cont <- httr::content(res)
    out_lst <- append(out_lst, lapply(cont$data$children, clean_post_data))
    count <- length(out_lst)
  }
  
  rbindlist(out_lst, use.names = TRUE, fill = TRUE)
}
