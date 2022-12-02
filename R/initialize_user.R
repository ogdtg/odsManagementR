#' initialize_user
#'
#' Funktion um User zu initialisieren und neuen Key zu erstellen.
#'
#' @param username Username (muss nur angegeben werden, wenn kein Key angegeben wird)
#' @param password Password (muss nur angegeben werden, wenn kein Key angegeben wird)
#' @param domain Domain der betreffenden Seite z.B. data.tg.ch
#' @param key Sollte bereits ein Key erstellt worden sein, der die nötige Berechtigungen enthält, kann dieser hier angeben werden.
#'
#' @export
#'
initialize_user <- function(username=NULL,password=NULL,domain,key=NULL) {

  if (is.null(key)) {
    message(paste0("No API Key given. New key with all permissions will be created"))

    pattern <- c('[A-Z]','[a-z]' ,'[0-9]', '[A-Z]','[a-z]' ,'[0-9]')
    use_pattern <- sample(pattern,size=6,replace = F)

    length_vec <- c(2,3,1,1,3,2)
    use_length <- sample(length_vec,size=6,replace = F)

    key_name <- do.call(paste0, Map(stringi::stri_rand_strings, n=1, use_length,
                        pattern = use_pattern))

    if (!is.null(username) | !is.null(password)) {
      key <- create_key(key_name=key_name,username=username,password=password,domain=domain)

      message(paste0("Key with name ",key_name," created. User initialized. Use getKey() to see the key."))

      setDomain(domain)
      setKey(key)

    } else {
      stop("Please provide username and password")
    }

  } else {
    message("User initialized. Use getKey() to see the key.")
    setDomain(domain)
    setKey(key)
  }

}


