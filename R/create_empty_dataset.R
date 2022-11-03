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
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })

  tryCatch({
    res <- httr::POST(url = 'https://data.tg.ch/api/management/v2/datasets/',
               httr::authenticate(usr, pw),
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
