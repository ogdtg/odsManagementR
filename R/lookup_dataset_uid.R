#' lookup_dataset_uid
#'
#' Funktion um dataset_uid aus dataset_id oder Titel zu ermitteln
#'
#' @param id_or_title Titel oder dataset_id
#'
#' @return dataset_uid
#' @export
#'
lookup_dataset_uid <- function(id_or_title) {

  metadatda_catalog <- get_dataset_info()

  if (id_or_title %in% metadata_catalog$dataset_uid) {
    dataset_uid <- id_or_title
  } else if (id_or_title %in% metadata_catalog$dataset_id) {
    dataset_uid <- metadata_catalog$dataset_uid[which(metadata_catalog$dataset_id==id_or_title)]
  } else if (id_or_title %in% metadata_catalog$metas$default$title) {
    dataset_uid <- metadata_catalog$dataset_uid[which(metadata_catalog$metas$default$title==id_or_title)]
  } else {
    stop("Dataset does not exist.")
  }

  return(dataset_uid)

}
