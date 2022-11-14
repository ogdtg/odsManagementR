#' add_datetime_precision (funktioniert noch nicht wie gewünscht)
#'
#' @param dataset_uid kann metdadata_catalog entnommen werden
#' @param field_name Name des Feldes
#' @param annotation_args Possible arguments are year, month and day for date, hour and minute for datetime
#'
#' @importFrom jsonlite fromJSON
#' @return Status Code
#' @export
#'
add_datetime_precision <- function(dataset_uid,field_name,annotation_args){
  body <-
    create_fields_body(
      configuration_item = "annotate",
      edit_field_id = field_name,
      new_annotation = "timeserie_precision",
      annotation_args = annotation_args
    )
  res=add_field_config(body=body,dataset_id = dataset_uid)

  tryCatch({
    result <- res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$processor_uid
  },
  error = function(cond){
    result <- res$status_code
  })

  return(res)

}
