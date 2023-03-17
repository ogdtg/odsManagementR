#' glimpse_resource
#'
#' Funktion um ersten paar Zeilen der Resource eines Datensatzes herunterladen
#'
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#' @param resource_uid resource_id of the resource that should be updated
#'
#' @return a data.frame
#' @export
#'
glimpse_resource = function(dataset_uid,resource_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  res <- httr::GET(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,"/resources/",resource_uid,"/preview"),
                   query = list(apikey=key))

  data <- res$content %>% rawToChar() %>%  jsonlite::fromJSON()

  return(data)

}
