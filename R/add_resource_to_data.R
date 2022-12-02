#' add_resource_to_data
#'
#' Hochegladene Datei (Resoource) mit Datensatz auf ODS verbinden
#'
#' @param resource Name der Ressource (kann aus files_list entnommen werden)
#' @param title Gewünschter Titel der Ressource
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#'
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
#' @importFrom httr authenticate
#'
#' @export
#'
add_resource_to_data <-  function(resource,title,dataset_uid){
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

  httr::POST(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/resources/"),
             body = body,
             query = list(apikey = key))

}
