#' add_field_config
#'
#' Funktiion führt POST request mit erzrugtem JSON Body durch
#'
#' @param body JSON File erzeugt durch create_fields_body
#' @param dataset_id kann metadata_catalog entnommen werden
#'
#' @importFrom httr authenticate
#' @importFrom httr POST
#'
#'
add_field_config <- function(body, dataset_id){
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })
  httr::POST(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_id,"/fields_specifications/"),
             body = body,
             query = list(apikey=key))
}
