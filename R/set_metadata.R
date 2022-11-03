#' set_metadata
#'
#' Funktion um einen Eintrag in den Metadaten zu ändern
#'
#' @param dataset_id kann metadata_catalog entnommen werden
#' @param template kann metadata_catalog entnommen werden
#' @param meta_name kann metadata_catalog entnommen werden
#' @param meta_value neuer Wert
#'
#' @return
#' @export
#'
#' @examples
#' 
#' ## Not Run
#' set_metadata(dataset_id="da-XXXX",template="default",meta_name ="title",meta_value="Hier der Titel")
#' 
set_metadata <- function(dataset_id,template,meta_name,meta_value) {
  
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })
  
  
  final_list = list(metas = list(list(template_name=template,
                                      metadata_name=meta_name,
                                      override_remote_value = TRUE,
                                      value = meta_value)))
  
  new_val = final_list %>% toJSON(auto_unbox = T)
  httr::PUT(url = paste0("https://data.tg.ch/api/management/v2/datasets/",dataset_id,"/metadata/"),
            httr::authenticate(usr, pw),
            body = new_val)
}