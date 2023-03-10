#' update_resource
#'
#' Resource eines Datensatzes ersetzen mit bereits hochgeladenem File
#'
#' @param resource Name der Ressource (kann aus files_list entnommen werden)
#' @param title Gewünschter Titel der Ressource
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#' @param resource_uid resource_id of the resource that should be updated
#'
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
#' @importFrom httr authenticate
#'
#' @export
#'
update_resource <-  function(resource,title,dataset_uid, resource_uid){
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  resource = paste0("odsfile://",resource)
  body <-
    list(
      url = resource,
      title = title,
      type = "csvfile",
      params = list(headers_first_row = TRUE, separator = ",")
    )
  body <- jsonlite::toJSON(body,auto_unbox = T)

  httr::PUT(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/resources/",resource_uid),
             body = body,
             query = list(apikey = key))

}
