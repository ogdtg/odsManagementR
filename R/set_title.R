#' set_title
#'
#'Titel eines Datensatzes setzen
#'
#' @importFrom jsonlite fromJSON
#' @importFrom jsonlite toJSON
#' @importFrom httr PUT
#' @importFrom httr authenticate
#'
#' @param title Neuer Titel
#' @param dataset_id kann metadata_catalog entnommen werden
#'
#' @export
#'
set_title = function(title,dataset_id) {

  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  httr::PUT(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_id,"/metadata/default/title"),
            query= list(apikey=key),
            body = jsonlite::toJSON(list(value=title,override_remote_value=TRUE), auto_unbox = T))
}
