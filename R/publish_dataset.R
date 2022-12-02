#' Datensatz publizieren
#'
#' Funktion published Datensatz, verändert aber NICHT die Sicherheitseinstellung (Datensatz nur für zugelassene Benutzer sichtbar)
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#' @importFrom httr PUT
#'
#' @export
#'
publish_dataset <- function(dataset_uid) {
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  tryCatch({
    httr::PUT(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,'/publish'),
              query = list(apikey=key))
  },
  error = function(cond){
    stop("Publishing process failed")
  })


}
