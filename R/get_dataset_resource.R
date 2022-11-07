#' get_dataset_resource
#'
#' @param dataset_uid Datensatz ID
#'
#' @return Datensatz mit allen Datenquellen die dem entsprechenden ODS Datensatz zugeordnet sind
#' @export
#'
#' @importFrom httr authenticate
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
get_dataset_resource = function(dataset_uid){
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")

  })

  res <- httr::GET(url = paste0('https://data.tg.ch/api/management/v2/datasets/',dataset_uid,"/resources"),
                   httr::authenticate(usr, pw))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()
  return(result)

}
