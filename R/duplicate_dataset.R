#' duplicate_dataset
#'
#' Funktion um Metadaten eines Datensatzes zu kopieren
#'
#' @param copy_id dataset_uid des zu kopierenden Datensatzes
#' @param new_id neue technische Kennung
#' @param title neuer Titel
#' @param save_local siehe `get_dataset_info`
#'
#' @return new_uid dataset_uid des neu erstellten Datensatz
#' @export
#'
duplicate_dataset = function(copy_id,new_id,title,save_local = TRUE) {

  tryCatch({
    metadata <- get_metadata(copy_id)
    new_uid <- create_dataset(identifier = new_id,title,save_local = save_local)

    set_metadata_from_df(new_uid,metas = metadata,title = title)
  }, error = function(cond){
    message(cond)
    return(NULL)
  })
  return(new_uid)

}
