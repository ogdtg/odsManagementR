#' Title
#'
#'Funktion um leeren Datensatz zu erstellen. Als Parameter wird die gewünschte Datensatz ID angegeben, die dann auch als Titel verwendet wird
#'
#' @importFrom jsonlite fromJSON
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
#' @importFrom httr authenticate
#'
#' @param identifier gewünschte Technische Kennung
#'
#' @return dataset_uid des neuen Datensatzes
#' @export
#'
create_empty_dataset <- function(identifier) {
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  tryCatch({
    res <- httr::POST(url = paste0('https://',domain,'/api/management/v2/datasets/'),
                      query = list(apikey=key),
               body = jsonlite::toJSON(list(metas = list(
                 default = list(title = identifier)
               )), auto_unbox = T))
    dataset_id = res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$dataset_uid
    return(dataset_id)
  },
  error = function(cond){
    return(NULL)
  })

}
