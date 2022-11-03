#init env
user <- new.env()

# Sets the value of the variable
#' setUsername
#'
#' @param username
#'
#' @export
#'
setUsername <- function(username) {
  assign("username", username, env=user)
}

# Sets the value of the variable
#' setKey
#'
#' @param apikey
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
#' @param password
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

#' setUser
#'
#'Funktion um User Daten zu setzen um package nutzen zu können
#'
#' @param username ODS-Username
#' @param password ODS-Passwort
#' @param apikey ODS-API Key
#'
#' @export
#'
setUser <- function(username,password,apikey){
  setUsername(username)
  setPassword(password)
  setKey(apikey)
}
