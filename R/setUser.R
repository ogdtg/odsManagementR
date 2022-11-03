#init env
user <- new.env()

# Sets the value of the variable
#' setUsername
#'
#' @param username 
#'
#' @return
#' @export
#'
#' @examples
setUsername <- function(username) {
  assign("username", username, env=user)
}

# Sets the value of the variable
#' setKey
#'
#' @param apikey 
#'
#' @return
#' @export
#'
#' @examples
setKey <- function(apikey) {
  assign("apikey", apikey, env=user)
}

# Gets the value of the variable
#' getUsername
#'
#' @return
#' @export
#'
#' @examples
getUsername <- function() {
  return(get("username", user))
}

# Sets the value of the variable
#' getKey
#'
#' @return
#' @export
#'
#' @examples
getKey <- function() {
  return(get("apikey", user))
}

# Sets the value of the variable
#' setPassword
#'
#' @param password 
#'
#' @return
#' @export
#'
#' @examples
setPassword <- function(password) {  
  assign("password", password, env=user)
}

# Gets the value of the variable
#' getPassword
#'
#' @return
#' @export
#'
#' @examples
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
#' @return
#' @export
#'
#' @examples
setUser <- function(username,password,apikey){
  setUsername(username)
  setPassword(password)
  setKey(apikey)
}