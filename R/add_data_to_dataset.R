#' add_data_to_dataset
#' Funktion um csv file hochzuladen, mit Metadaten zu verknüpfen und Spaltenbeschreibungen zu ergänzen (wrapper)
#'
#' @param dataset_uid kann metadta_catalog entnommen werden
#' @param schema ausgefülltes Schema excel
#' @param ogd_file csv file, welches die Daten enthält
#' @param resource_title geünschter Titel der Resource auf ODS
#'
#' @export
#'
add_data_to_dataset <- function(dataset_uid,schema,ogd_file,resource_title){

  # Upload zu ODS
  filename_ods <- upload_file_to_ods(ogd_file)

  # Hochegladenes File zu Datenquelle machen
  add_resource_to_data(filename_ods$file_id,dataset_uid = dataset_uid,title = resource_title)

  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")

  variables <- read.table(ogd_file,             # Read only header of example data
                          head = TRUE,
                          nrows = 1, sep = ",") %>% names()


  for (i in 1:nrow(spalten)){

    if (variables[i]!=spalten$Name_Neu[i]) {
      rename_field(
        dataset_uid = dataset_uid,
        old_name = variables[i],
        new_name = spalten$Name_Neu[i],
        new_label = spalten$Name_Neu[i]
      )
    }

    add_description_to_field(
      dataset_uid = dataset_uid,
      field_name = spalten$Name_Neu[i],
      new_description = spalten$Variablenbeschreibungen[i]
    )
    s=add_type(
      dataset_uid = dataset_uid,
      field_name = spalten$Name_Neu[i],
      new_type  = spalten$type[i]
    )
    if (is.na(spalten$precision[i])) {
      next
    } else {
      add_datetime_precision(
        dataset_uid = dataset_uid,
        field_name = spalten$Name_Neu[i],
        annotation_args = list(spalten$precision[i])
      )

    }

  }

}
