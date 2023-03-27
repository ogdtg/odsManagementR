#' get_dataset_status
#'
#' Datensatz Status herunterladen
#'
#' @param dataset_uid Datensatz ID
#'
#' @return Name des dataset_status
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
get_dataset_status = function(dataset_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  res <- httr::GET(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,"/status"),
                   query = list(apikey=key))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()

  return(result$name)
}
