#' Anlagen hinzufügen
#'
#' Mit dieser Funktion können eines oder mehere Files bzw. der Inhalt ganzer Ordner als Anlage zu einem Datensatz zugeordnet werden
#'
#' @param directory Pfad zu Ordner welcher alle Anlagen enthält (Wenn nicht NULL, werden alle Inhalte des Ordners hochgeladen)
#' @param files eines oder mehrere Files die als Anlage hochgeladen werden
#' @param dataset_uid dataset_uid
#'
#' @export
#'
add_attachments <- function(directory=NULL, files=NULL, dataset_uid) {
  if (is.null(directory) && is.null(files)) {
    stop("Either files or directory must be provided")
  }
  if (!is.null(directory) && !is.null(files)) {
    stop("Files and directory will be uploaded")
    files_mod <- list.files(directory)
    files_mod <- paste0(normalizePath(directory),"/",files_mod)
    files <- c(files, files_mod)
  }
  if (is.null(files)) {
    files <- list.files(directory)
    files <- paste0(normalizePath(directory),"/",files)
  }
  tryCatch({
    key = getKey()
    domain = getDomain()
  },
  error = function(cond) {
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })

  filelist <- lapply(files, upload_file_to_ods)

  res <- lapply(filelist, function(x){
    data <- paste0('{"url": "',x$url,'"}')
    res <-
      httr::POST(
        url = paste0(
          'https://',
          domain,
          '/api/management/v2/datasets/',
          dataset_uid,
          '/attachments'
        ),
        body = data,
        query = list(apikey = key)
      )
  })


}

