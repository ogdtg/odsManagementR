#' Title
#'
#'Funktion um leeren Datensatz zu erstellen. Als Parameter wird die gewünschte Datensatz ID angegeben, die dann auch als Titel verwendet wird
#'
#' @param identifier 
#'
#' @return
#' @export
#'
#' @examples
create_empty_dataset <- function(identifier) {
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })
  
  httr::POST(url = 'https://data.tg.ch/api/management/v2/datasets/',
             httr::authenticate(usr, pw),
             body = toJSON(list(metas = list(
               default = list(title = identifier)
             )), auto_unbox = T))
}