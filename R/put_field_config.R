#' put_field_config
#'
#' Funktiion führt PUT request mit erzrugtem JSON Body durch
#'
#' @param body JSON File erzeugt durch create_fields_body
#' @param dataset_id kann metadata_catalog entnommen werden
#' @param processor_uid kann field processors entnommen werden
#'
#' @importFrom httr authenticate
#' @importFrom httr PUT
#'
#'
put_field_config <- function(body, dataset_id,processor_uid){
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })
  httr::PUT(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_id,"/fields_specifications/",processor_uid),
             body = body,
             query = list(apikey=key))
}
