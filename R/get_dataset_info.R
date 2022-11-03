#' get_dataset_info
#'
#' Funktion um alle derzeit aufgeschalteten Metadaten herunterzuladen. Hier kann auch die dataset_uid entnommen werden.
#'
#' @export
#' @return verschachtelter Metadaten Dataframe
#'
#' @examples
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
    res <- GET(url = "https://data.tg.ch/api/management/v2/datasets/",
               query = list(rows = 100,
                            page=page),
               httr::authenticate(usr, pw))
    result[[page]] <- res$content %>% 
      rawToChar() %>% 
      fromJSON() %>% 
      .$datasets
    counter = nrow(result[[page]])
  }
  return(result %>% bind_rows())
  
}