#' get_dataset_info
#'
#' Funktion um alle derzeit aufgeschalteten Metadaten herunterzuladen. Hier kann auch die dataset_uid entnommen werden.
#' Der Catalog wird in der Variable metadata_catalog gespeichert
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom httr authenticate
#' @importFrom dplyr bind_rows
#' @export
#'
get_dataset_info <- function() {
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })

  counter = 100
  page = 0
  result = list()
  while (counter==100) {
    page = page + 1
    res <- httr::GET(url = "https://data.tg.ch/api/management/v2/datasets/",
               query = list(rows = 100,
                            page=page),
               httr::authenticate(usr, pw))
    result[[page]] <- res$content %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      .$datasets
    counter = nrow(result[[page]])
    if (length(counter)==0){
      break
    }
  }
  if(exists("metadata_catalog")){
    warning("Variable metadata_catalog will b overwritten.")
    metadata_catalog <<- result %>% dplyr::bind_rows()
  } else {
    metadata_catalog <<- result %>% dplyr::bind_rows()
  }
  return(metadata_catalog)
}


