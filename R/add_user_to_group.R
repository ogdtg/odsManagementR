#' add_user_to_group
#'
#' Funktion um User zu Gruppe hinzuzufügen
#'
#' @param group_id Gruppen ID (kann über get_groups ermittelt werden)
#' @param user_list Liste von Useramen (nicht Email Adressen). Parameter MUSS eine Liste sein
#'
#' @importFrom httr PUT
#' @importFrom httr authenticate
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite fromJSON
#'
#'
add_user_to_group <- function(group_id,user_list){

  if (!is.list(user_list)) {
    stop("user_list must be a list.")
  }

  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  data = list(usernames = user_list) %>% jsonlite::toJSON(auto_unbox = T)

  res <-
    httr::POST(
      url = paste0('https://',domain,'/api/management/v2/groups/',group_id,'/users'),
      body = data,
      query = list(apikey=key)
    )

  test <- res$content %>% rawToChar() %>% jsonlite::fromJSON()

  for (i in 1:length(test)) {
    if (test[[i]]=="success") {
      message(paste0(names(test)[i]," zu Gruppe ",group_id," hinzugefuegt." ))
    }
    if (test[[i]]=="duplicate") {
      message(paste0(names(test)[i]," ist bereits Mitglied."))
    }
    if (test[[i]]=="error") {
      message(paste0(names(test)[i]," konnte nicht hinzugefuegt werden. Ist ",names(test)[i]," ein valider Username?"))
    }

  }
}
