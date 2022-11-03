#' rename_field
#'
#' @param dataset_uid kann dem metadata_catalog entnommen werden
#' @param old_name der Name des Feldes (identifier)
#' @param new_name der neue technische Name (sollte dem alten entsprechen)
#' @param new_label der neue angezeigte Name (wird als Variablenname angezeigt)
#'
#' @importFrom jsonlite fromJSON
#'
#' @return wenn erfolgreich: processor_uid, wenn nicht erfolgreich status code
#' @export
#'
rename_field <- function(dataset_uid, old_name, new_name, new_label) {
  body <- create_fields_body(configuration_item = "rename",edit_field_id = old_name,new_name = new_name,new_label = new_label)
  res=add_field_config(body=body,dataset_id = dataset_uid)

  tryCatch({
    result <- res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$processor_uid
  },
  error = function(cond){
    result <- res$status_code
  })

  return(result)
}
