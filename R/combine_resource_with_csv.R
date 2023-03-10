#' combine_resource_with_csv
#'
#' Funktion um vorhandene Resource mit neuen Daten zu verbinden (rbind). Neue Da
#'
#' @param filepath Pfad zum CSV File, das hochgeladen werden soll
#' @param dataset_uid dataset_uid des Datensatz, dem die Ressource zugeordnet werden soll
#' @param resource_uid resource_id of the resource that should be updated
#' @param delim_local_csv seperator for the local csv file (default is ',')
#'
#' @export
#'
combine_resource_with_csv <- function(filepath, dataset_uid, resource_uid = NULL, delim_local_csv = ",") {

  if (is.null(resource_uid)) {
    resource_info <- get_dataset_resource(dataset_uid = dataset_uid)
    if (length(resource_info)==0) {
      stop("There is no resource to update")
    }

    if (length(resource_info$resource_uid)>1) {
      warning("multiple resources and no resource_uid provided by user. Will update the last updated resource")
    }

    resource_uid <- resource_info$resource_uid[nrow(resource_info)]
  }

  df_old<- download_resource(dataset_uid = dataset_uid, resource_uid = resource_uid)

  df_new <-  readr::read_delim(filepath, delim = delim_local_csv)


  df <- rbind(df_new,df_old) %>%
    dplyr::distinct()

  dest_file <- tempfile(fileext = ".csv")
  write.csv(df, dest_file, row.names = F)

  update_resource_with_csv(filepath = dest_file, dataset_uid, resource_uid)

}
