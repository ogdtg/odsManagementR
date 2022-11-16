#' get_dataset_info
#'
#' Funktion um alle derzeit aufgeschalteten Metadaten herunterzuladen. Hier kann auch die dataset_uid entnommen werden.
#' Der Catalog wird in der Variable metadata_catalog gespeichert
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom httr authenticate
#' @importFrom dplyr bind_rows
#' @importFrom tidyr unnest
#' @importFrom dplyr select
#' @export
#'
get_dataset_info <- function(path = "Y:\\SK\\SKStat\\Open Government Data _ OGD\\Zusammenstellung Hilfsmittel OGD\\Selbst erstellte Hilfsmittel\\data_catalog.csv") {
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })

  counter = 100
  page = 0
  result = list()
  while (counter==100) {
    page = page + 1
    res <- httr::GET(url = "https://data.tg.ch/api/management/v2/datasets/",
               query = list(rows = 100,
                            page=page),
               httr::authenticate(usr, pw))
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
    warning("Variable metadata_catalog will b overwritten.")
    metadata_catalog <<- result %>% dplyr::bind_rows()
  } else {
    metadata_catalog <<- result %>% dplyr::bind_rows()
  }
  local_df <-
    metadata_catalog %>%
    tidyr::unnest_wider(metas) %>%
    tidyr::unnest(default) %>%
    tidyr::unnest(visualization) %>%
    tidyr::unnest(internal) %>%
    tidyr::unnest(dcat) %>%
    tidyr::unnest(dcat_ap_ch) %>%
    dplyr::select(dataset_uid,dataset_id,title,creator,publisher)


  tryCatch({
    write_ogd(
      local_df,
      path
      )
      message(paste0("Katalog gespeichert unter ",path))
  },
  error = function(cond){
    stop("Katalog konnte nicht gespeichert werden")
  })
  return(metadata_catalog)
}


