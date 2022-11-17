#' add_data_to_dataset
#' Funktion um csv file hochzuladen, mit Metadaten zu verknüpfen und Spaltenbeschreibungen zu ergänzen (wrapper)
#'
#' @param dataset_uid kann metadta_catalog entnommen werden
#' @param schema ausgefülltes Schema excel
#' @param ogd_file csv file, welches die Daten enthält
#' @param resource_title geünschter Titel der Resource auf ODS
#'
#' @importFrom readxl read_excel
#'
#' @export
#'
add_data_to_dataset <- function(dataset_uid,schema,ogd_file,resource_title){

  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")

  if (sum(is.na(spalten$Variablenbeschreibungen))>0) {
    stop("Variablenbeschreibungen unvollständig. Bitte Excel Schema checken.")
  }


  # Upload zu ODS
  filename_ods <- upload_file_to_ods(ogd_file)

  # Hochegladenes File zu Datenquelle machen
  add_resource_to_data(filename_ods$file_id,dataset_uid = dataset_uid,title = resource_title)


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
    add_type(
      dataset_uid = dataset_uid,
      field_name = spalten$Name_Neu[i],
      new_type  = spalten$type[i]
    )
    if (!is.na(spalten$precision[i])) {
      add_datetime_precision(
        dataset_uid = dataset_uid,
        field_name = spalten$Name_Neu[i],
        annotation_args = list(spalten$precision[i])
      )
    }

    if (!is.na(spalten$kurz[i])) {
      add_unit(
        dataset_uid = dataset_uid,
        field_name = spalten$Name_Neu[i],
        unit = spalten$kurz
      )
    }
  }

}
