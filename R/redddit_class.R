#' REddit Account Object
#' 
#' @export
Reddit <- R6::R6Class(
  "Reddit",
  public = list(
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
      auth_reddit_uri(private$client_id, private$redirect_uri)
    },
    
    get_access_token = function(auth_code) {
      private$reactive_dep(isolate(private$reactive_dep()) + 1)
      
      private$auth_code <- auth_code
      res <- get_reddit_access_token(auth_code, private$redirect_uri, private$client_id, private$client_secret)
      private$access_token <- paste("bearer", res$access_token)
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
    
    logout = function() {
      private$reactive_dep(isolate(private$reactive_dep()) + 1)
      
      private$auth_code <- NULL
      private$access_token <- NULL
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
