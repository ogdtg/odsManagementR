#' restore_change
#'
#' Historie wiederherstellen
#'
#' @param dataset_uid Datensatz ID
#' @param restore_uid Change ID
#'
#' @return Datensatz mit allen Datenquellen die dem entsprechenden ODS Datensatz zugeordnet sind
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
restore_change = function(dataset_uid, restore_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })


  headers = c(
    `Content-Type` = 'application/x-www-form-urlencoded'
  )

  data = jsonlite::toJSON(list(change_uid = restore_uid), auto_unbox = TRUE)

  res <- httr::PUT(
    url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,'/restore_change'),
    httr::add_headers(.headers = headers),
    body = data,
    query = list(apikey=key)
  )
  print(res)

  return(res$status_code)
}
