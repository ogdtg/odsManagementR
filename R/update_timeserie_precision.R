#' update_timeserie_precision
#'
#' @param dataset_uid kann metdadata_catalog entnommen werden
#' @param field_name Name des Feldes
#' @param annotation_args Possible arguments are year, month and day for date, hour and minute for datetime
#' @param proc_id processor_uid
#'
#' @export
#'
update_timeserie_precision <- function(dataset_uid,field_name,annotation_args,proc_id) {

  tryCatch({
    domain = getDomain()
    key = getKey()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  body <-
    create_fields_body(
      configuration_item = "annotate",
      edit_field_id = field_name,
      new_annotation = "timeserie_precision",
      annotation_args = annotation_args
    )


  PUT(paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/fields_specifications/",proc_id),
      body = body,
      query= list(apikey=key))

}
