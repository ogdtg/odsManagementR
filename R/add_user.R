#' add_user
#'
#' Funktion um ODS-Einladungsmails an einen oder mehrere Mail Adressen zu versenden. Bereits hinzugefügte Nutzer werden nicht erneut eingeladen.
#'
#' @param email_list Muss eine Liste sein, auch wenn nur ein Nuter hinzugefügt werden soll.
#'
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite fromJSON
#' @importFrom httr POST
#'
#' @export
#'
add_user <- function(email_list) {

  if (!is.list(email_list)) {
    stop("email_list must be a list.")
  }

  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No Key or Domain initialized. Please use setUser() first.")

  })


  data = list(emails = email_list) %>% jsonlite::toJSON(auto_unbox = T)

  res <-
    httr::POST(
      url = 'https://',domain,'/api/management/v2/users/',
      body = data,
      query = list(apikey = key)
    )

  test <- res$content %>% rawToChar() %>% jsonlite::fromJSON()

  for (i in 1:length(test)) {
    if (test[[i]]=="success") {
      message(paste0("Email-Einladung an ",names(test)[i]," versendet."))
    }
    if (test[[i]]=="already-member") {
      message(paste0(names(test)[i]," ist bereits Member. Keine weitere Einladung versendet."))
    }

  }

}
