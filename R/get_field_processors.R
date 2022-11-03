#' get_field_processors
#'
#' Funktion um alle processor Schritte (Umbenennungen, Veränderung Beschreinung, Veränderung Typ,etc.) eines Datensatzes anzuzeigen
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#'
#' @return dataframe mit processor Schritten
#' @export
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
get_field_processors <- function(dataset_uid) {

  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")

  })

  res <- httr::GET(paste0("https://data.tg.ch/api/management/v2/datasets/",dataset_uid,"/fields_specifications/"),
                   httr::authenticate(usr, pw))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()
  return(result)
}
