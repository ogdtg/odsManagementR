#' add_group
#'
#' Funktion um Gruppe zu erstellen.
#'
#' @param group_name Anzeigename der Gruppe
#'
#' @importFrom jsonlite toJSON
#' @importFrom httr POST
#' @importFrom httr authenticate
#'
#'
#' @export
#'
add_group <- function(group_name) {


  tryCatch({
    key = getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  groups <- get_groups()
  group_titles <- groups$group_info$title

  if(group_name %in% group_titles) {
    stop("Gruppenname bereits vergeben. Bitte waehlen Sie einen anderen Gruppennamen.")
  }

  data = list(title = group_name) %>% jsonlite::toJSON(auto_unbox = T)

  res <-
    httr::POST(
      url = paste0('https://',domain,'/api/management/v2/groups/'),
      body = data,
      query = list(apikey = key)
    )

}
