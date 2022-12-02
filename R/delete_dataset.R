#' delete_dataset
#'
#' Funktion um Datensatz zu löschen
#'
#' @param dataset_uid dataset_uid,dataset_id oder Datensatz Titel können angegeben werden
#'
#' @export
#'
delete_dataset <- function(dataset_uid) {
  tryCatch({
    key=getKey()
    domain = getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")
  })
  get_dataset_info()

  if (dataset_uid %in% metadata_catalog$dataset_uid) {
    dataset_uid <- dataset_uid
  } else if (dataset_uid %in% metadata_catalog$dataset_id) {
    dataset_uid <- metadata_catalog$dataset_uid[which(metadata_catalog$dataset_id==dataset_uid)]
  } else if (dataset_uid %in% metadata_catalog$metas$default$title) {
    dataset_uid <- metadata_catalog$dataset_uid[which(metadata_catalog$metas$default$title==dataset_uid)]
  } else {
    stop("Dataset does not exist.")
  }


  id <- metadata_catalog$dataset_id[which(metadata_catalog$dataset_uid==dataset_uid)]
  name <- metadata_catalog$metas$default$title[which(metadata_catalog$dataset_uid==dataset_uid)]

  response <- readline(prompt=paste0("If you want to permanently delete the dataset ",name," (",id,"), type 'yes' and press enter. \n If not, leave the line empty and press enter."))

  response <- tolower(response)

  if (response %in% c("ja","j","y","yes")) {
    tryCatch({
      httr::DELETE(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid),
                   query = list(apikey = key))
    },
    error = function(cond){
      stop("Deletion process failed")
    })
  } else {
    stop("Deletion aborted")
  }

}
