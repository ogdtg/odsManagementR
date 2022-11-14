#' add_type
#'
#' @param dataset_uid Kann metadata_catalog entnommen werden
#' @param field_name name des Feldes
#' @param new_type Neuer Typ (siehe verwendbare Typen unter https://betahelp.opendatasoft.com/management-api/#type)
#'
#' @export
#'
add_type <- function(dataset_uid,field_name,new_type) {
  body <- create_fields_body(configuration_item = "type",edit_field_id= field_name,new_type=new_type)
  add_field_config(body = body, dataset_id = dataset_uid)
}
