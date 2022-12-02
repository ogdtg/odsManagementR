#' update_group
#'
#' Funktion um Namen und Permissions von Gruppen zu verändern
#'
#' @param group_id Gruppen ID
#' @param group_name Neuer Name
#' @param permission_list Liste von permissions (muss als Liste angegeben werden)
#'
#'
#' @importFrom httr PUT
#' @importFrom jsonlite toJSON
#' @export
#'
update_group <- function(group_id,group_name=NULL,permission_list=NULL) {

  if (is.null(group_name) & is.null(permission_list)) {
    stop("Please provide either group_name or permission_list")
  }

  if (!is.null(permission_list)) {
    if (!is.list(permission_list)) {
      stop("permission_list must be a list.")
    }
  }

  if (is.null(permission_list)) {
    data = list(title = group_name) %>% jsonlite::toJSON(auto_unbox = T)
  } else if (is.null(group_name)){
    data = list(permissions = permission_list) %>% jsonlite::toJSON(auto_unbox = T)
  } else {
    data = list(title = group_name,permissions = permission_list) %>% jsonlite::toJSON(auto_unbox = T)
  }

  tryCatch({
    domain = getDomain()
    key = getKey()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")
  })



  res <-
    httr::PUT(
      url = paste0('https://',domain,'/api/management/v2/groups/',group_id,"/"),
      body = data,
      query = list(apikey=key)
    )
}
