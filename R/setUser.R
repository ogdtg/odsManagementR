#init env
user <- new.env()

# Sets the value of the variable
#' setUsername
#'
#' @param username ODS Username
#'
#' @export
#'
setUsername <- function(username) {
  assign("username", username, env=user)
}

# Sets the value of the variable
#' setKey
#'
#' @param apikey API-Key mit den benötigten Berechtigungen
#'
#' @export
#'
setKey <- function(apikey) {
  assign("apikey", apikey, env=user)
}

# Gets the value of the variable
#' getUsername
#'
#' @return username
#' @export
#'
getUsername <- function() {
  return(get("username", user))
}

#' getKey
#'
#' @return apikey
#' @export
#'
getKey <- function() {
  return(get("apikey", user))
}

# Sets the value of the variable
#' setPassword
#'
#' @param password ODS-Passwort
#'
#' @export
#'
setPassword <- function(password) {
  assign("password", password, env=user)
}

# Gets the value of the variable
#' getPassword
#'
#' @return password
#' @export
#'
getPassword<- function() {
  return(get("password", user))
}

#' setDomain
#'
#' @param domain Domain des Portals (z.B. data.tg.ch)
#'
#' @export
#'
setDomain <- function(domain) {
  domain <- gsub("https://","",domain)
  domain <- gsub("http://","",domain)
  domain <- gsub("http:/","",domain)
  assign("domain", domain, env=user)
}

#' getDomain
#'
#' @return domain
#' @export
#'
getDomain<- function() {
  return(get("domain", user))
}

#' setUser
#'
#'Funktion um User Daten zu setzen um package nutzen zu können
#'
#' @param username ODS-Username
#' @param password ODS-Passwort
#' @param apikey API-Key mit den benötigten Berechtigungen (default=NULL)
#' @param domain Domain des Portals (z.B. data.tg.ch)
#'
#' @export
#'
setUser <- function(username=NULL,password=NULL,apikey,domain){
  setUsername(username)
  setPassword(password)
  setKey(apikey)
  setDomain(domain)
}
