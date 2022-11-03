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
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")

  })

  res <- httr::GET(url = 'https://data.tg.ch/api/management/v2/files',
                   httr::authenticate(usr, pw))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()
  return(result)

}
