#' get_metadata
#'
#'Funktion um Metadaten eines bestimmten Datensatzes zu erhalten
#'
#' @param dataset_uid
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom httr authenticate
#'
#'
#' @return Datensatz mit Metadaten eines gewünschten Datensatzes
#' @export
#'
get_metadata <- function(dataset_uid){
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })

  url = paste0('https://data.tg.ch/api/management/v2/datasets/',dataset_uid,'/metadata')

  res <- httr::GET(url = url,
                   httr::authenticate(usr, pw))
  result <- res$content %>%
    rawToChar() %>%
    jsonlite::fromJSON()
  return(result)
}
