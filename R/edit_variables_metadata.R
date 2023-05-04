#' edit_variables_metadata
#'
#' Funktion um Namen, Spaltenbeschreibungen und Datentypen zu ändern
#'
#' @param dataset_uid kann metadta_catalog entnommen werden
#' @param schema ausgefülltes Schema excel
#' @param lgr ein lgr Objekt
#' @param save_names boolean der angibt ob die Variablennamen aus dem Excel gespeichert werden sollen (nur bei Automatischem Ablauf benötigt)
#' @param dataset_info dataset_info Element (nur bei Automatischem Ablauf benötigt)
#'
#' @export
#'
edit_variables_metadata <- function(dataset_uid,schema,lgr = NULL, save_names = FALSE, dataset_info = NULL) {
  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")
  spalten <- spalten[rowSums(is.na(spalten)) != ncol(spalten),]
  #

  if (sum(is.na(spalten$Variablenbeschreibungen))>0) {
    stop("Variablenbeschreibungen unvollstaendig. Bitte Excel Schema checken.")
  }
  # resources <- get_dataset_resource(dataset_uid)

  # glimpse_res <-glimpse_resource(dataset_uid = dataset_uid, resource_uid = resources$resource_uid[nrow(resources)])

  # if(is.null(change_names)){
  #   variables <- spalten$Name_Neu
  # } else {
  #   variables <- readRDS(change_names)
  # }
  variables <- tryCatch({
    dataset_info$original_names
  }, error = function(e){
    lgr$info("edit_variables_metadata: No dataset_info given.")
    spalten$Name_Neu
  })
  if (is.null(variables)){
    variables <- spalten$Name_Neu
  }

  # variables <- spalten$Name_Neu[spalten$Name_Neu %in% glimpse_res$fields$name]
  # uncommon <- spalten$Name_Neu[!spalten$Name_Neu %in% glimpse_res$fields$name]

  if (length(variables)!=length(spalten$Name_Neu)){
    lgr$error(paste0("edit_variables_metadata: Metadata (",length(spalten$Name_Neu),") and data (",length(variables),") do not contain the same amount of variables"))
    stop()
  }

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
    restore_uid <- get_latest_change(dataset_uid)

    tryCatch({
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

    }, error = function(e){
      tryCatch({
        lgr$error(paste0("edit_variables_metadata: Error for",spalten$Name_Neu[i],": ", e))
        res <- restore_change(dataset_uid=dataset_uid,restore_uid = restore_uid)
        lgr$info(paste0("edit_variables_metadata: Restored Change ",restore_uid," with status code ",res))
        stop("process aborted")
      }, error = function(cond){
        warning(paste0("Error for",spalten$Name_Neu[i],": ", e))
        res <- restore_change(dataset_uid=dataset_uid,restore_uid = restore_uid)
        warning(paste0("edit_variables_metadata: Restored Change ",restore_uid," with status code ",res))
        stop("process aborted")
      })


    })

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
