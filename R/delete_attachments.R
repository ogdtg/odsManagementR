#' delete_attachments
#'
#' Funktion um Datensatz Anhänge zu löschen
#'
#' @param dataset_uid dataset_uid,dataset_id oder Datensatz Titel können angegeben werden
#'
#' @export
#'
delete_attachments <- function(dataset_uid) {
  tryCatch({
    key=getKey()
    domain = getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")
  })

  df <- get_dataset_attachments(dataset_uid = dataset_uid)
  if (length(df)>0){
    invisible(lapply(df$attachment_uid,function(x){
      res <- httr::DELETE(url = paste0('https://',domain,'/api/management/v2/datasets/',dataset_uid,"/attachments/", x),
                          query = list(apikey = key))
    }))
  }






}
