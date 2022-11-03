#' add_description_to_field
#'
#' Funktion um Variablenbeschreibungen anzulegen
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#' @param field_name Feldname zu dem die Beschreibung gehören soll
#' @param new_description neue Beschreibung (wird auch als Label angezeigt)
#'
#' @importFrom jsonlite fromJSON
#'
#' @return wenn erfolgreich: processor_uid, wenn nicht erfolgreich status code
#' @export
#'
add_description_to_field <- function(dataset_uid, field_name, new_description) {
  body <- create_fields_body(configuration_item = "description",edit_field_id = field_name,new_description = new_description)
  res = add_field_config(body=body,dataset_id = dataset_uid)

  tryCatch({
    result <- res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$processor_uid
  },
  error = function(cond){
    result <- res$status_code
  })

  return(result)
}
