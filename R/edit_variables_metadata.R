#' edit_variables_metadata
#'
#' Funktion um Namen, Spaltenbeschreibungen und Datentypen zu ändern
#'
#' @param dataset_uid kann metadta_catalog entnommen werden
#' @param schema ausgefülltes Schema excel
#'
#' @export
#'
edit_variables_metadata <- function(dataset_uid,schema) {
  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")
  spalten <- spalten[rowSums(is.na(spalten)) != ncol(spalten),]

  if (sum(is.na(spalten$Variablenbeschreibungen))>0) {
    stop("Variablenbeschreibungen unvollstaendig. Bitte Excel Schema checken.")
  }
  # resources <- get_dataset_resource(dataset_uid)
  #
  # glimpse_res <-glimpse_resource(dataset_uid = dataset_uid, resource_uid = resources$resource_uid[nrow(resources)])
  #
  # variables <- spalten$Name_Neu[spalten$Name_Neu %in% glimpse_res$fields$name]
  # uncommon <- spalten$Name_Neu[!spalten$Name_Neu %in% glimpse_res$fields$name]
  #
  # if(length(uncommon)>0){
  #   warning(paste0("The following variables are not present in the dataset resource and will therefore be ignored:",uncommon,"\nPlease update the dataset resource first"))
  # }
  # uncommon <- glimpse_res$fields$name[!glimpse_res$fields$name %in% spalten$Name_Neu]
  #
  # if(length(uncommon)>0){
  #   warning(paste0("The following variables are not present in the metadata file and will therefore be ignored:",uncommon,"\nPlease update the dataset resource first"))
  # }

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
}
