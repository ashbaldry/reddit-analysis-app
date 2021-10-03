#### Time ####
weekday_abbr <- c("Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun")

comment_time_chart <- function(dt, label = "Posts") {
  time_dt <- dt[, .(count = .N), keyby = .(day = wday(created_utc), hour = hour(created_utc))]
  time_dt <- time_dt[CJ(day = 1:7, hour = 0:23)]
  set(time_dt, which(is.na(time_dt$count)), "count", 0)
  time_dt[, wday := factor(day, labels = weekday_abbr)]
  time_dt[, xhr := paste(ifelse(hour %% 12 == 0, 12, hour %% 12), ifelse(hour >= 12, "PM", "AM"))]
  
  highcharter::highchart() %>%
    highcharter::hc_chart(
      type = "heatmap"
    ) %>%
    highcharter::hc_add_series(
      time_dt, type = "heatmap", name = label,
      highcharter::hcaes(x = hour, xhr = xhr, y = wday, wday = wday, value = count),
      tooltip = list(
        headerFormat = "",
        pointFormat = paste0(
          "<span style='color:{point.color}'>●</span> <span> {point.wday} {point.xhr}</span><br/>",
          "{series.name}: {point.value}<br/>"
        )
      )
    ) %>%
    highcharter::hc_colorAxis(
      minColor = "#ffffff", maxColor = upvote_colour
    ) %>%
    highcharter::hc_yAxis(
      categories = weekday_abbr, type = "category"
    ) %>%
    highcharter::hc_title(
      text = glue::glue("Frequency of {label} During the Week")
    )
}

comment_karma_tl <- function(dt, label = "Posts", cake_day = NULL) {
  date_dt <- dt[
    , 
    .(score = sum(score), max_score = max(score), posts = .N, 
      subreddit = subreddit_name_prefixed[which.max(score)], permalink = permalink[which.max(score)]), 
    keyby = .(date = as.Date(created_utc))
  ]
  
  if (!is.null(cake_day) && !cake_day %in% date_dt$date) {
    date_dt <- rbindlist(list(
      data.table(
        date = cake_day, score = 0, max_score = 0, posts = 0, 
        subreddit = NA_character_, permalink = NA_character_
      ),
      date_dt
    ))
  }
  
  s_label <- sub("s$", "", label)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      date_dt, highcharter::hcaes(x = date, y = cumsum(score)),
      type = "line", cursor = "pointer", showInLegend = FALSE,
      marker = list(radius = 4, enabled = TRUE),
      tooltip = list(
        pointFormat = paste(
          "Number of", tolower(label), "made: <b>{point.posts}</b><br/>",
          "Karma gained/lost: <b>{point.score}</b><br/>",
          "Subreddit with top", s_label, ": <b>{point.subreddit}</b><br/>",
          "Click to see top", tolower(s_label), "in Reddit"
        )
      )
    ) %>%
    highcharter::hc_chart(
      zoomType = "x"
    ) %>%
    highcharter::hc_xAxis(
      type = "datetime"
    ) %>%
    highcharter::hc_yAxis(
      title = list(text = paste(s_label, "Karma"))
    )  %>%
    highcharter::hc_colors(upvote_colour) %>%
    highcharter::hc_title(
      text = paste("Karma Gained from", label, "Over Time")
    ) %>%
    highcharter::hc_subtitle(
      text = "Drag the plot area to zoom in"
    ) %>%
    highcharter::hc_plotOptions(
      series = list(point = list(events = list(click = htmlwidgets::JS(
        "function() { window.open('https://www.reddit.com' + this.permalink); }"
      ))))
    )
}

#### Comments ####
# Checks for word breaks. If so then excludes when r/subreddit, u/username or /s (sarcasm) is used.
# Otherwise checks for when spaces and non-words are combined
tokenize_reddit <- function(x, m = names(x), split_hyphens = TRUE) {
  x[is.na(x)] <- ""
  
  x_clean <- remove_hyperlinks(x)
  x_clean <- remove_urls(x_clean)
  
  reddit_regex <- "(?:(\\b)(?:(?<!\\b[ru]\\/)((?=[^s])|(?=\\w{2})|(?<=[^\\/])))((?<=[^ru])|(?<=\\w{2})|(?=[^\\/])))|((?:(?!=\\w)(?<=\\s))|((?:(?=\\W)(?<=\\W))))"
  
  if (split_hyphens) x_clean <- gsub("(?<=[a-zA-Z])\\-(?=[a-zA-Z])", ("\\1xyzzyx\\2"), x_clean, perl = TRUE)
  y <- structure(stringi::stri_split_regex(x_clean, reddit_regex), names = m)
  if (split_hyphens) y <- lapply(y, gsub, pattern = "xyzzyx", replacement = "-")
  y
}

get_comment_words <- function(dt, text_col = "body") {
  words <- quanteda::tokens(tokenize_reddit(dt[[text_col]], dt$id), remove_punct = TRUE, remove_symbols = TRUE) %>%
    quanteda::tokens_remove(c("`", "http", "https", "didn", "wasn", "ve")) %>%
    quanteda::tokens_tolower(keep_acronyms = TRUE) %>%
    quanteda::tokens_select(pattern = quanteda::stopwords(language = "en", source = "smart"), selection = "remove")
  
  words_dt <- data.table(id = rep(names(words), times = sapply(words, length)), word = unlist(words))
  
  id_dt <- dt[, .(id, subreddit = subreddit_name_prefixed, created_utc, ups, downs, score)]
  id_dt[words_dt, on = "id"]
}

remove_hyperlinks <- function(x) gsub("\\[(.*?)\\]\\(.*?\\)", "\\1", x)
remove_urls <- function(x) gsub("http(s|):\\/\\/.*?(\\s|$)", "\\2", x)

word_freq_cloud <- function(word_dt, label = "Posts") {
  if (is.null(word_dt) || nrow(word_dt) == 0) return(highcharter::highchart())
  
  uniq_word_dt <- unique(word_dt)[
    , 
    .(key_subreddit = names(which.max(table(subreddit))),
      last_post = max(created_utc),
      count = scales::number(.N), 
      avg_score = scales::number(mean(score)),
      score = round(mean(score))
    ), 
    by = .(word)
  ]
  setorder(uniq_word_dt, -count, -last_post, -avg_score)
  uniq_word_dt[, color := highcharter::colorize(score, c(downvote_colour, upvote_colour))]
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      uniq_word_dt[seq(min(.N, 100))],
      highcharter::hcaes(name = word, weight = count, sub = key_subreddit, color = color),
      type = "wordcloud",
      maxFontSize = 32,
      minFontSize = 8,
      tooltip = list(
        pointFormat = paste0(
          "Word: <b>{point.name}</b><br/>Posts: <b>{point.weight}</b><br/>",
          "Average Rating: <b>{point.avg_score}</b><br/>",
          "Subreddit Most Used:<br/><b>{point.sub}</b>"
        )
      )
    ) %>%
    highcharter::hc_title(
      text = paste("Top, ", min(c(100, nrow(uniq_word_dt))), "Words Used in", label)
    ) %>%
    highcharter::hc_subtitle(
      text = "Colour based on average score of post"
    )
}
