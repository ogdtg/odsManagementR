#' get_metadata
#'
#'Funktion um Metadaten eines bestimmten Datensatzes zu erhalten
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
#'
#' @return Datensatz mit Metadaten eines gewünschten Datensatzes
#' @export
#'
get_metadata <- function(dataset_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,'/metadata')

  res <- httr::GET(url = url,
                   query = list(apikey=key))
  result <- res$content %>%
    rawToChar() %>%
    jsonlite::fromJSON()
  return(result)
}
