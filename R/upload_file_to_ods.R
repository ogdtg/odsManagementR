#' upload_file_to_ods
#'
#' Funktion um CSV Files hochzuladen
#'
#' @param filepath Pfad zum CSV File, das hochgeladen werden soll
#'
#' @return Liste mit Statuscode des API Calls
#' @export
#'
#' @importFrom httr POST
#' @importFrom httr authenticate
#' @importFrom jsonlite fromJSON
#'
upload_file_to_ods <- function(filepath) {

  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")

  })
  files = list(
    `file` = upload_file(filepath)
  )

  res <- httr::POST(url = 'https://data.tg.ch/api/management/v2/files', body = files, encode = 'multipart',
                    httr::authenticate(usr, pw))

  result <- res$content %>% rawToChar() %>% jsonlite::fromJSON()

  tryCatch({
    exists(result$file_id)
    print(paste0("File uploaded succesfully. Available on ODS with the name ",result$file_id," (",result$url,")"))
  },
  error = function(cond){
    stop(paste0("error ",result$status_code,": ",result$message))

  })

  return(result)
}
