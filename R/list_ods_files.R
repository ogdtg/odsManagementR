#' list_ods_files
#'
#' @return Datensatz mit allen Files die auf ODS hochgeladen wurden
#' @export
#'
#' @importFrom httr authenticate
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
list_ods_files = function(){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  res <- httr::GET(url = paste0('https://',domain,'/api/management/v2/files'),
                   query = list(apikey=key))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()
  return(result)

}
