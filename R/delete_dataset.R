#' delete_dataset
#'
#' Funktion um Datensatz zu löschen
#'
#' @param dataset_uid dataset_uid,dataset_id oder Datensatz Titel können angegeben werden
#' @param ask wenn TRUE wird nach Bestätigung durch USer gefragt.
#'
#' @export
#'
delete_dataset <- function(dataset_uid, ask = TRUE) {
  tryCatch({
    key=getKey()
    domain = getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")
  })

  dataset_uid <- lookup_dataset_uid(dataset_uid)

  id <- metadata_catalog$dataset_id[which(metadata_catalog$dataset_uid==dataset_uid)]
  name <- metadata_catalog$metas$default$title[which(metadata_catalog$dataset_uid==dataset_uid)]

  if (ask) {
    response <- readline(prompt=paste0("If you want to permanently delete the dataset ",name," (",id,"), type 'yes' and press enter. \n If not, leave the line empty and press enter."))

    response <- tolower(response)
  } else if (!ask) {
    response = "ja"
  } else {
    stop("Deletion aborted")
  }



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
