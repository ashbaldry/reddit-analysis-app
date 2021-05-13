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

#### Comments ####
# Checks for word breaks. If so then excludes when r/subreddit, u/username or /s (sarcasm) is used.
# Otherwise checks for when spaces and non-words are combined
tokenize_reddit <- function(x, m = names(x), split_hyphens = TRUE) {
  reddit_regex <- "(?:(\\b)(?:(?<!\\b[ru]\\/)((?=[^s])|(?=\\w{2})|(?<=[^\\/])))((?<=[^ru])|(?<=\\w{2})|(?=[^\\/])))|((?:(?!=\\w)(?<=\\s))|((?:(?=\\s)(?<!\\w))))"
  x[is.na(x)] <- ""
  if (split_hyphens) x <- gsub("(?<=[a-zA-Z])\\-(?=[a-zA-Z])", ("\\1xyzzyx\\2"), x, perl = TRUE)
  y <- structure(stringi::stri_split_regex(x, reddit_regex), names = m)
  if (split_hyphens) y <- lapply(y, gsub, pattern = "xyzzyx", replacement = "-")
  y
}

get_comment_words <- function(dt, text_col = "body") {
  words <- quanteda::tokens(tokenize_reddit(dt[[text_col]], dt$id), remove_punct = TRUE) %>%
    quanteda::tokens_remove(c("`", "http", "https", "didn", "wasn", "ve")) %>%
    quanteda::tokens_tolower(keep_acronyms = TRUE) %>%
    quanteda::tokens_select(pattern = quanteda::stopwords(language = "en", source = "smart"), selection = "remove")
  
  words_dt <- data.table(id = rep(names(words), times = sapply(words, length)), word = unlist(words))
  
  id_dt <- dt[, .(id, subreddit = subreddit_name_prefixed, created_utc, ups, downs, score)]
  id_dt[words_dt, on = "id"]
}

word_freq_cloud <- function(word_dt) {
  if (is.null(word_dt) || !nrow(word_dt)) return(highcharter::highchart())
  
  uniq_word_dt <- unique(word_dt)[
    , 
    .(key_subreddit = names(which.max(table(subreddit))),
      last_post = max(created_utc),
      count = .N, 
      avg_score = mean(score)
    ), 
    by = .(word)
  ]
  setorder(uniq_word_dt, -count, -last_post)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      uniq_word_dt[seq(min(.N, 100))],
      highcharter::hcaes(name = word, weight = count, sub = key_subreddit),
      type = "wordcloud",
      tooltip = list(
        pointFormat = "Word: <b>{point.name}</b><br/>Posts: <b>{point.weight}</b><br/>Subreddit Most Used:<br/><b>{point.sub}</b>"
      )
    )
}
