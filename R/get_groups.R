#' get_groups
#'
#' Funktion um Informationen über die auf ODS verfügbaren Gruppen sowie deren Berechtigungen  zu bekommen.
#'
#' @return gibt eine Liste mit einem dataframe group_info, einer Liste group_permissions zurück
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom httr authenticate
#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @export
get_groups <- function() {
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })


  counter = 100
  page = 0
  result = list()
  while (counter==100) {
    page = page + 1
    res <- httr::GET(url = "https://",domain,"/api/management/v2/groups/",
                     query = list(rows = 100,
                                  page=page,
                                  apikey = key),
                     httr::authenticate(usr, pw))
    result[[page]] <- res$content %>%
      rawToChar() %>%
      jsonlite::fromJSON()

    counter = nrow(result[[page]])
    if (length(counter)==0){
      break
    }
  }

  final  <- result %>% dplyr::bind_rows()
  group_info <- final %>%
    dplyr::select(group_id,title,user_count)

  group_permissions <- final$permissions
  names(group_permissions) <- group_info$group_id


  return(list(group_info=group_info,group_permissions=group_permissions))

}
