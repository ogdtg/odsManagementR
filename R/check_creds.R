#' Check Credentials
#'
#' Check whether key and domain are initialised
#'
#' @export
#'
check_creds <- function(){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })
}
