#' Komplett Upload
#'
#' Wrapper um Daten, Metadaten und Anhänge auf ODS hochzuladen
#'
#' @param metadata_schema Pfad zum Metadaten Schema
#' @param data Pfad zu den CSV Daten
#' @param attachement_directory siehe `add_attachments`
#' @param attachement_files siehe `add_attachments`
#' @param ...
#'
#' @return dataset_uid
#' @export
#'
upload_all <- function(metadata_schema, data,attachement_directory = NULL,attachement_files = NULL,...){
  resource_title <- stringr::str_split(normalizePath(data),"\\\\") %>% unlist() %>% tail(n=1)
  dataset_uid <- add_metadata_from_scheme(filepath = metadata_schema,...)
  add_data_to_dataset(dataset_uid = dataset_uid,schema = metadata_schema,ogd_file = data, resource_title = resource_title)
  if (!is.null(attachement_directory) | !is.null(attachement_files)){
    add_attachments(directory = attachement_directory, files = attachement_files, dataset_uid = dataset_uid)
  }
  return(dataset_uid)
}
