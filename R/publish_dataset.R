#' Datensatz publizieren
#'
#' Funktion published Datensatz, verändert aber NICHT die Sicherheitseinstellung (Datensatz nur für zugelassene Benutzer sichtbar)
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#' @importFrom httr authenticate
#' @importFrom httr PUT
#'
#' @export
#'
publish_dataset <- function(dataset_uid) {
  tryCatch({
    pw=getPassword()
    usr=getUsername()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  tryCatch({
    httr::PUT(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,'/publish'),
              httr::authenticate(usr,pw))
  },
  error = function(cond){
    stop("Publishing process failed")
  })


}
