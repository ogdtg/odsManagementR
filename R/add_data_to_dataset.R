#' add_data_to_dataset
#' Funktion um csv file hochzuladen, mit Metadaten zu verknüpfen und Spaltenbeschreibungen zu ergänzen (wrapper)
#'
#' @param dataset_uid kann metadta_catalog entnommen werden
#' @param schema ausgefülltes Schema excel
#' @param ogd_file csv file, welches die Daten enthält
#' @param resource_title geünschter Titel der Resource auf ODS
#' @param save_names boolean der angibt ob die Variablennamen aus dem Excel gespeichert werden sollen (nur bei Automatischem Ablauf benötigt)
#' @param dataset_info dataset_info Element (nur bei Automatischem Ablauf benötigt)
#'
#' @importFrom readxl read_excel
#'
#' @export
#'
add_data_to_dataset <- function(dataset_uid,schema,ogd_file,resource_title, save_names =FALSE, dataset_info = NULL){


  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")
  spalten <- spalten[rowSums(is.na(spalten)) != ncol(spalten),]

  if (sum(is.na(spalten$Variablenbeschreibungen))>0) {
    stop("Variablenbeschreibungen unvollstaendig. Bitte Excel Schema checken.")
  }

  # check names Path
  variables <- tryCatch({
    readRDS(original_name_path)
  }, error = function(e){
    lgr$info("add_data_to_dataset: No change_names given or file does not exist.")
    spalten$Name_Neu
  })

  if (length(variables)!=length(spalten$Name_Neu)){
    lgr$error(paste0("edit_variables_metadata: Metadata (",length(spalten$Name_Neu),") and data (",length(variables),") do not contain the same amount of variables"))
    stop()
  }


  # Upload zu ODS
  filename_ods <- upload_file_to_ods(ogd_file)

  # Hochegladenes File zu Datenquelle machen
  add_resource_to_data(filename_ods$file_id,dataset_uid = dataset_uid,title = resource_title)



  for (i in 1:nrow(spalten)){

    # Falls nötig Spaltenumbenennen
    if (variables[i]!=spalten$Name_Neu[i]) {
      rename_field(
        dataset_uid = dataset_uid,
        old_name = variables[i],
        new_name = spalten$Name_Neu[i],
        new_label = spalten$Name_Neu[i]
      )
    }


    # Beschreibung hinzufügen
    add_description_to_field(
      dataset_uid = dataset_uid,
      field_name = spalten$Name_Neu[i],
      new_description = spalten$Variablenbeschreibungen[i]
    )

    # Datentyp definieren
    add_type(
      dataset_uid = dataset_uid,
      field_name = spalten$Name_Neu[i],
      new_type  = spalten$type[i]
    )

    # Falls angegeben Einheit definieren

    if (!is.na(spalten$kurz[i])) {
      add_unit(
        dataset_uid = dataset_uid,
        field_name = spalten$Name_Neu[i],
        unit = spalten$kurz[i]
      )
    }
    # Datumspräzision definieren
    if (!is.na(spalten$precision[i])) {
      add_timeserie_precision(
        dataset_uid = dataset_uid,
        field_name = spalten$Name_Neu[i],
        annotation_args = spalten$precision[i]
      )
    }
  }

  # Felder sortierbar machen
  text_fields <- spalten$Name_Neu[which(spalten$type=="text")]
  make_fields_sortable(dataset_uid = dataset_uid,fields = text_fields)

  if (save_names & !is.null(dataset_info)){
    dataset_info$original_names <- spalten$Name_Neu
    lgr$info("add_data_to_dataset: original_names saved")
    return(dataset_info)
  }
}
