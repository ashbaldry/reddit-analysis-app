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

get_comment_words <- function(dt) {
  words <- quanteda::tokens(tokenize_reddit(dt$body, dt$id), remove_punct = TRUE) %>%
    quanteda::tokens_remove(c("`", "http", "https", "didn", "wasn", "ve")) %>%
    quanteda::tokens_tolower(keep_acronyms = TRUE) %>%
    quanteda::tokens_select(pattern = quanteda::stopwords(language = "en", source = "smart"), selection = "remove")
  
  words_dt <- data.table(id = rep(names(words), times = sapply(words, length)), word = unlist(words))
  
  id_dt <- dt[, .(id, subreddit = subreddit_name_prefixed, created_utc, ups, downs, controversiality, score, score_hidden)]
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

#### Upvotes/Downvotes ####
votes_chart <- function(dt, color = "#333333", label = "Upvotes") {
  if (is.null(dt)) return(highcharter::highchart())
  plt_dt <- dt[, .(count = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(plt_dt, -count)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      plt_dt[seq(min(10, .N))], 
      highcharter::hcaes(x = subreddit, y = count),
      type = "bar", name = label, color = color
    ) %>%
    highcharter::hc_xAxis(
      type = "category"
    ) %>%
    highcharter::hc_title(
      text = glue::glue("Top {sub('s$', 'd', label)} Subreddits")
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}

vote_ratio_chart <- function(up_dt, down_dt) {
  if (is.null(up_dt) || is.null(down_dt)) return(highcharter::highchart())
  up_cnt_dt <- up_dt[, .(upvote = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(up_cnt_dt, -upvote)
  
  down_cnt_dt <- down_dt[, .(downvote = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(down_cnt_dt, -downvote)
  
  cnt_dt <- merge(up_cnt_dt, down_cnt_dt, by = "subreddit", all = TRUE)
  set(cnt_dt, which(is.na(cnt_dt$upvote)), "upvote", 0)
  set(cnt_dt, which(is.na(cnt_dt$downvote)), "downvote", 0)
  cnt_dt[, count := upvote + downvote]
  setorder(cnt_dt, -count)
  
  plt_dt <- cnt_dt[seq(min(15, .N))]
  plt_dt[, ratio := (upvote - downvote) / (upvote + downvote)]
  plt_dt[, bar_color := fifelse(ratio >= 0, "#FF8B60", "#9494FF")]
  plt_dt[, ratio_order := fifelse(ratio >= 0, count, -count)]
  setorder(plt_dt, -ratio, -ratio_order)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      plt_dt, 
      highcharter::hcaes(x = subreddit, y = ratio, color = bar_color, up = upvote, down = downvote),
      type = "bar", name = "Ratio",
      tooltip = list(
        pointFormat = "Ratio: <b>{point.value}</b><br/>Upvotes: <b>{point.up}</b> Downvotes: <b>{point.down}</b>",
        valueDecimals = 2
      )
    ) %>%
    highcharter::hc_xAxis(
      type = "category"
    ) %>%
    highcharter::hc_yAxis(
      min = -1, max = 1
    ) %>%
    highcharter::hc_title(
      text = "Top Voted Subreddits Upvote/Downvote Ratio"
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}
