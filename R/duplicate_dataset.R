#' duplicate_dataset
#'
#' Funktion um Metadaten eines Datensatzes zu kopieren
#'
#' @param copy_id dataset_uid des zu kopierenden Datensatzes
#' @param new_id neue technische Kennung
#' @param title neuer Titel
#'
#' @export
#'
duplicate_dataset = function(copy_id,new_id,title) {

  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })


  tryCatch({
    metadata <- get_metadata(copy_id)
    new_uid <- create_dataset(identifier = new_id,title)

    set_metadata_from_df(new_uid,metas = metadata,title = title)
  }, error = function(cond){
    stop("Something went wrong")
  })

}
