#' create_dataset
#'
#' @importFrom jsonlite fromJSON
#'
#' @param identifier technische Kennung
#' @param title Titel
#' @param save_local siehe `get_dataset_info`
#'
#' @return dataset_uid
#' @export
#'
#'
create_dataset <- function(identifier,title,save_local = TRUE) {

  get_dataset_info(save_local = save_local)


  if (identifier %in% metadata_catalog$dataset_id) {
    temp_title <- metadata_catalog$metas$default$title[which(metadata_catalog$dataset_id==identifier)]
    stop(paste0("Datensatz ID schon vergeben an ",temp_title,". Datensatz kann nicht erstellt werden Bitte andere ID waehlen."))
  }
  if (title %in% metadata_catalog$metas$default$title) {
    stop(paste0("Titel schon vergeben an ",title,". Datensatz kann nicht erstellt werden Bitte anderen Titel waehlen."))
  }

  dataset_id <- create_empty_dataset(identifier)
  set_title(title,dataset_id)
  return(dataset_id)
}
