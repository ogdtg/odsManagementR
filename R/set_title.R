#' set_title
#'
#' @param title Neuer Titel
#' @param dataset_id kann metadata_catalog entnommen werden
#'
#' @return
#' @export
#'
#' @examples
set_title = function(title,dataset_id) {
  
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })
  
  httr::PUT(url = paste0("https://data.tg.ch/api/management/v2/datasets/",dataset_id,"/metadata/default/title"),
            httr::authenticate(usr, pw),
            body = toJSON(list(value=title,override_remote_value=TRUE), auto_unbox = T))
}