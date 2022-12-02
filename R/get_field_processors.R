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
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  res <- httr::GET(paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/fields_specifications/"),
                   query = list(apikey=key))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()
  return(result)
}
