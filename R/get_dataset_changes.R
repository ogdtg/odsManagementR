#' get_dataset_changes
#'
#' Datensatz Historie herunterladen
#'
#' @param dataset_uid Datensatz ID
#'
#' @return Datensatz mit allen Datenquellen die dem entsprechenden ODS Datensatz zugeordnet sind
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
get_dataset_changes = function(dataset_uid){
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  res <- httr::GET(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,"/changes"),
                   query = list(apikey=key))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()

  red_result <- result %>%
    select(change_uid, timestamp,can_restore)

  user <- result$user %>%
    select(username)

  dataset <- result$dataset %>%
    select(dataset_uid)

  red_result <- red_result %>%
    cbind(user) %>%
    cbind(dataset)
  return(red_result)

}
