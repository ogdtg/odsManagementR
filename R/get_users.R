#' get_users
#'
#' Funktion um Informationen über die auf ODS verfügbaren Nutzer sowie deren Berechtigungen und Gruppenzugehörigkeiten zu bekommen.
#'
#' @return gibt eine Liste mit einem dataframe user_info, einer Liste user_permissions und einer weiteren liste user_groups zurück
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @export
get_users <- function() {
  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })


  counter = 100
  page = 0
  result = list()
  while (counter==100) {
    page = page + 1
    res <- httr::GET(url = "https://",domain,"/api/management/v2/users/",
                     query = list(rows = 100,
                                  page=page,
                                  apikey = key))
    result[[page]] <- res$content %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      .$users
    counter = nrow(result[[page]])
    if (length(counter)==0){
      break
    }
  }

  final  <- result %>% dplyr::bind_rows()
  user_info <- final %>%
    dplyr::select(username:account_type)

  user_permissions <- final$permissions
  names(user_permissions) <- user_info$username

  user_groups <- final$groups
  names(user_groups) <- user_info$username

  return(list(user_info=user_info,user_permissions=user_permissions,user_groups=user_groups))

}
