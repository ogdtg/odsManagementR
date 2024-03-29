#' get_latest_change
#'
#' Neueste change_uid
#'
#' @param dataset_uid dataset_uid
#'
#' @return change_uid
#' @export
#'
get_latest_change <- function(dataset_uid) {
  changes <- get_dataset_changes(dataset_uid)
  if (length(df)>0){
    return(changes$change_uid[1])
  } else {
    return(NULL)
  }
}

