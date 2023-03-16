#' create_new_dataset_id
#'
#' Funktion erzeugt Kennung mit durchgängiger Nummerierung ohne Duplikate
#'
#' @param test_id String in Form Departement-Amt (Beispiel: sk-stat)
#' @param save_local see `get_dataset_info()`
#'
#' @return dataset_id/technische Kennung
#' @export
#'
create_new_dataset_id = function(test_id,save_local = TRUE){
  get_dataset_info(save_local = save_local)

  id_mod = gsub("-\\d+","",test_id)
  id_vec = metadata_catalog$dataset_id[grep(id_mod,metadata_catalog$dataset_id)]
  if (length(id_vec)==0){
    new_id = paste0(test_id,"-1")
    return(new_id)
  } else {
    new_id = gsub(paste0(id_mod, "-"), "", id_vec) %>%
      as.numeric() %>%
      max() %>%
      +1 %>%
      paste0(id_mod,"-",.)
    return(new_id)
  }


  print("new ID")
}
