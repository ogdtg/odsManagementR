#' create_dataset
#'
#' @importFrom jsonlite fromJSON
#'
#' @param identifier technische Kennung
#' @param title Titel
#'
#' @return dataset_uid
#' @export
#'
#'
create_dataset <- function(identifier,title) {

  metadata_catalog <<- get_dataset_info()


  if (identifier %in% metadata_catalog$dataset_uid) {
    temp_title <- metadata_catalog$metas$default$title[which(metadata_catalog$dataset_uid==identifier)]
    stop(paste0("Datensatz ID schon vergeben an ",temp_title,". Datensatz kann nicht erstellt werden Bitte andere ID wählen."))
  }
  if (title %in% metadata_catalog$metas$default$title) {
    stop(paste0("Titel schon vergeben an ",title,". Datensatz kann nicht erstellt werden Bitte anderen Titel wählen."))
  }

  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })

  dataset_id <- create_empty_dataset(identifier)
  set_title(title,dataset_id)
  return(dataset_id)
}
