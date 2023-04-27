#' check_dataset_exist
#'
#' Überprüft ob ein Datensatz mit der gegebenen dataset_uid existiert
#'
#' @param dataset_uid kann metadata_catalog entnommen werden
#'
#' @return boolean: wenn Datensatz existiert TRUE sonst FALSE
#' @export
#'
check_dataset_exist <- function(dataset_uid){
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })
  res <- httr::GET(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/status/"),
             query = list(apikey=key))

  if (res$status_code==200){
    return(TRUE)
  } else {
    return(FALSE)
  }

}

