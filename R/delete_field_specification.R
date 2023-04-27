#' delete_field_specification
#'
#' Eine  bestimmte Field Specification löschen
#'
#' @param processor_uid UID des zu löschenden field specifications
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#'
#' @importFrom jsonlite toJSON
#'
#' @export
#'
delete_field_specification <-  function(dataset_uid, processor_uid ){
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  res <- httr::DELETE(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/fields_specifications/",processor_uid),
                      query = list(apikey = key))



}
