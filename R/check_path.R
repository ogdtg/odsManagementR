#' Check Path
#'
#' Checks whther path is initialised. If not a default path for local catalog will be initialised
#'
#' @return path_var
#' @export
#'
check_path <- function(){
  tryCatch({
    path_var=getPath()
  },
  error = function(cond){
    path_var = "Y:/SK/SKStat/Open Government Data _ OGD/Zusammenstellung Hilfsmittel OGD/Selbst erstellte Hilfsmittel/data_catalog.csv"

  })
  return(path_var)
}

