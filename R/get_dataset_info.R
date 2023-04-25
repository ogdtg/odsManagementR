#' get_dataset_info
#'
#' Funktion um alle derzeit aufgeschalteten Metadaten herunterzuladen. Hier kann auch die dataset_uid entnommen werden.
#' Der Catalog wird automatisch in der Variable metadata_catalog gespeichert
#'
#' @param save_local logical ob Katalog lokal gespeichert werden soll (default ist TRUE)
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @export
#'
get_dataset_info <- function(save_local = TRUE) {
  tryCatch({
    key=getKey()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser() first.")

  })

  tryCatch({
    path=getPath()
  },
  error = function(cond){
    path = "Y:/SK/SKStat/Open Government Data _ OGD/Zusammenstellung Hilfsmittel OGD/Selbst erstellte Hilfsmittel/data_catalog.csv"

  })

  counter = 100
  page = 0
  result = list()
  while (counter==100) {
    page = page + 1
    res <- httr::GET(url = paste0("https://",domain,"/api/management/v2/datasets/"),
               query = list(rows = 100,
                            page=page,
                            apikey = key))
    result[[page]] <- res$content %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      .$datasets
    counter = nrow(result[[page]])
    if (length(counter)==0){
      break
    }
  }
  if(exists("metadata_catalog")){
    if (save_local){
      warning("Variable metadata_catalog will b overwritten.")
    }
    metadata_catalog <<- result %>% dplyr::bind_rows()
  } else {
    metadata_catalog <<- result %>% dplyr::bind_rows()
  }
  local_df <-
    metadata_catalog %>%
    dplyr::select(dataset_uid,dataset_id) %>%
    cbind(metadata_catalog$metas$default$title) %>%
    cbind(metadata_catalog$metas$default$publisher) %>%
    cbind(metadata_catalog$metas$dcat$creator) %>%
    setNames(c("datset_uid","dataset_id","title","publisher","creator"))

  if (save_local) {
    tryCatch({
      write_ogd(
        local_df,
        path
      )
      message(paste0("Katalog gespeichert unter ",path))
    },
    error = function(cond){
      stop("Katalog konnte nicht gespeichert werden. Wurde der Pfad richtig initialisiert")
    })
  }


}


