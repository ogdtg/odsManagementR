#' add_user_to_data
#'
#' Funktion um User zum Datensatz hinzuzufügen (z.B. Amtsverantwortliche zur Kontrolle vor der Veröffentlichung)
#'
#' @param username Name des Users (ID)
#' @param dataset_uid Datensatz UID
#' @param permission_list Liste von Berechtigungen, die dem Nutzer für den Datensatz zugestanden werden (default ist 'explore_restricted_dataset')
#'
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
#' @importFrom httr authenticate
#'
#' @export
#'
add_user_to_data <- function(username,dataset_uid, permission_list = list("explore_restricted_dataset")) {

  if (!is.list(permission_list)) {
    stop("permission_list must be a list.")
  }

  tryCatch({
    pw=getPassword()
    usr=getUsername()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")
  })
  data = list(
    user = list(username = username),
    is_data_visible = TRUE,
    visible_fields = list(),
    filter_query = "",
    api_calls_quota = NA,
    permissions = permission_list
  )

  data <- data %>% jsonlite::toJSON(auto_unbox = T,na =  "null",pretty = T)

  httr::POST(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_uid,"/security/users"),
       body = data,
       httr::authenticate(usr, pw),verbose=T)

}
