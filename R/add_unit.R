#' add_unit
#'
#' Einheit zu Variable hinzufügen
#'
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#' @param field_name Feld zu dem Unit hinzugefügt werden soll
#' @param unit unterstützte Units unter https://betahelp.opendatasoft.com/management-api/#units
#'
#' @return wenn erfolgreich processor_id, wenn nicht Status Code
#' @export
#'
add_unit <- function(dataset_uid,field_name,unit){
  body <-create_fields_body(configuration_item = "annotate",edit_field_id = field_name,annotation_args = unit,new_annotation = "unit")
  res=add_field_config(body=body,dataset_id = dataset_uid)

  tryCatch({
    result <- res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$processor_uid
  },
  error = function(cond){
    warning("Given unit might not be supported by ODS. Please check https://betahelp.opendatasoft.com/management-api/#units.")
    result <- res$status_code
  })
  return(result)
}
