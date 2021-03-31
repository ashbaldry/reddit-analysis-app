#' REddit Account Object
#' 
#' @export
Reddit <- R6::R6Class(
  "Reddit", 
  
  public = list(
    user_info = NULL,
    user_name = NULL,
    user_posts = NULL,
    user_comments = NULL,
    user_upvotes = NULL,
    user_downvotes = NULL,
    
    initialize = function(client_id, client_secret, redirect_uri) {
      private$reactive_dep <- reactiveVal(0)
      private$client_id <- client_id
      private$client_secret <- client_secret
      private$redirect_uri <- redirect_uri
    },
    
    get_auth_uri = function() {
      if (is.null(client_id) || is.null(redirect_uri)) {
        stop("Client ID and Redirect URI must be specified for Authorization URI")
      }
      auth_reddit_uri(
        private$client_id, 
        private$redirect_uri, 
        c("identity", "read", "history")
      )
    },
    
    get_access_token = function(auth_code) {
      private$reactive_dep(isolate(private$reactive_dep()) + 1)
      
      if (!is.null(private$access_token)) return(TRUE)
      
      private$auth_code <- auth_code
      res <- get_reddit_access_token(auth_code, private$redirect_uri, private$client_id, private$client_secret)
      private$access_token <- paste("bearer", res$access_token)
      
      self$user_info <- self$get_user_info()
      self$user_name <- self$user_info$name
      
      return(TRUE)
    },
    
    is_authorized = function() {
      !is.null(private$access_token)
    },
    
    get_user_info = function() {
      if (is.null(private$access_token)) {
        stop("Unable to find access code")  
      }
      
      res <- httr::GET(
        "https://oauth.reddit.com/api/v1/me",
        httr::add_headers(Authorization = private$access_token),
        httr::user_agent("httr")
      )
      
      httr::content(res)
    },
    
    get_user_comments = function(user_name = self$user_name) {
      if (is.null(user_name)) return(NULL)
      if (user_name == self$user_name && !is.null(self$user_comments)) return(self$user_comments)
      
      comments <- get_user_activity(
        user_name = user_name, access_token = private$access_token, api_call = "comments"
      )
      if (user_name == self$user_name) self$user_comments <- comments
      comments
    },
    
    get_user_posts = function(user_name = self$user_name) {
      if (is.null(user_name)) return(NULL)
      if (user_name == self$user_name && !is.null(self$user_posts)) return(self$user_posts)
      
      posts <- get_user_activity(
        user_name = user_name, access_token = private$access_token, api_call = "submitted"
      )
      if (user_name == self$user_name) self$user_posts <- posts
      posts
    },
    
    get_user_upvotes = function(user_name = self$user_name) {
      if (is.null(user_name)) return(NULL)
      if (user_name == self$user_name && !is.null(self$user_upvotes)) return(self$user_upvotes)
      
      comments <- get_user_activity(
        user_name = user_name, access_token = private$access_token, api_call = "upvoted"
      )
      if (user_name == self$user_name) self$user_upvotes <- comments
      comments
    },
    
    get_user_downvotes = function(user_name = self$user_name) {
      if (is.null(user_name)) return(NULL)
      if (user_name == self$user_name && !is.null(self$user_downvotes)) return(self$user_downvotes)
      
      comments <- get_user_activity(
        user_name = user_name, access_token = private$access_token, api_call = "downvoted"
      )
      if (user_name == self$user_name) self$user_downvotes <- comments
      comments
    },
    
    logout = function() {
      private$reactive_dep(isolate(private$reactive_dep()) + 1)
      
      private$auth_code <- NULL
      private$access_token <- NULL
      self$user_info <- NULL
      self$user_name <- NULL
      self$user_posts <- NULL
      self$user_comments <- NULL
      self$user_upvotes <- NULL
      self$user_downvotes <- NULL
    },
    
    get_reactive = function() {
      private$reactive_dep()
      self
    }
  ),
  
  private = list(
    reactive_dep = NULL,
    client_id = NULL,
    client_secret = NULL,
    redirect_uri = NULL,
    auth_code = NULL,
    access_token = NULL
  )
)
