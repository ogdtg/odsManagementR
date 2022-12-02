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
#' @importFrom jsonlite fromJSON
#' @importFrom httr upload_file
#'
upload_file_to_ods <- function(filepath) {

  tryCatch({
    domain=getDomain()
    key = getKey()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })
  files = list(
    `file` = httr::upload_file(filepath)
  )

  res <- httr::POST(url = 'https://',domain,'/api/management/v2/files', body = files, encode = 'multipart',
                    query=list(apikey=key))

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
