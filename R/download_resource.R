#' download_resource
#'
#' Funktion um Resource eines Datensatzes herunterladen
#'
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#' @param resource_uid resource_id of the resource that should be updated
#'
#' @return the resource as data.frame
#' @export
#'
download_resource = function(dataset_uid,resource_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  res <- httr::GET(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,"/resources/",resource_uid,"/download"),
                   query = list(apikey=key))

  string <- res$content %>% rawToChar()
  if (!stringr::str_detect(string,"[\u00E4|\u00F6|\u00FC|\u00DC|\u00C4|\u00D6]")) {
    Encoding(string) <- "utf-8"
  }

  comma <- stringr::str_count(string, pattern = ",")
  semicol <- stringr::str_count(string, pattern = ";")

  if (comma>semicol){
    result <- readr::read_csv(string)
  } else {
    result <- readr::read_csv2(string)
  }

  return(result)

}
