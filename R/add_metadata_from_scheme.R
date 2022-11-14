#' add_metadata_from_scheme
#'
#' Funktion kann nur auf genau definiertes Schema angewendet werden.
#' Alle Metadaten im Schema werden auf das Portal gesladen.
#'
#' @param filepath Pfad zum ausgefüllten Schema
#' @param harvesting default ist TRUE; wenn kein Harvesting zu opendata.swiss gewünscht wird auf FALSE setzen
#' @param zuschreibungen character vevtor mit Zuschreibungen
#'
#' @return dataset_uid
#' @export
#'
add_metadata_from_scheme <- function(filepath, harvesting = TRUE, zuschreibungen = NULL) {

  # Parameter check
  if (!is.logical(harvesting)){
    stop("harvesting Parameter muss entweder TRUE oder FALSE sein")
  }

  if (!is.null(zuschreibungen)){
    temp <- zuschreibungen %>% unlist() %>% is.character()
    if (!temp) {
      stop("zuschreibungen muss Liste von character elementen sein")
    }
  }


  metadata_test <- read_excel(filepath,sheet="Metadaten") #read schema
  #names(metadata_test)[1]<-"Metadata"
  metadata_test["Beispiel"]<-NULL

  meta_template_df <- readRDS(meta_template_df) # Metadaten Schema laden um Loop durchführen zu können

  part_id <- metadata_test$Eintrag[which(metadata_test$Metadata=="Kennung")]
  title_meta <- metadata_test$Eintrag[which(metadata_test$Metadata=="Titel")]

  #neue Kennung erzeugen
  dataset_id <- create_new_dataset_id(part_id)

  #template Datensatz mit voreingestellten Metadaten kopieren und dataset_uid für weitere aktionen speichern in Variable
  dataset_uid <- duplicate_dataset(copy_id = "da_qwsbz2",new_id = dataset_id,title = title_meta)

  counter = 1
  theme_list = list()
  for (i in 1:nrow(meta_template_df)) {
    template = meta_template_df$template_names[i]
    meta_name = meta_template_df$meta_names[i]
    meta_value = metadata_test$Eintrag[which( metadata_test$Metadata==meta_template_df$join_col[i])]


    if (meta_name == "description") {
      meta_value =paste0(meta_value,"\n\nDatenquelle: ",metadata_test$Eintrag[which(metadata_test$Metadata=="Amt")])
    }

    if (meta_name == "keyword") {
      meta_value = gsub(" ","",meta_value)
      meta_value = strsplit(meta_value,",")
      meta_value = meta_value[[1]]
    }
    if (meta_name == "theme") {
      #print(meta_value)
      if (is.na(meta_value)){
        next
      }
      theme_list[[counter]] <- meta_value
      counter = counter + 1
      next
    }
    set_metadata(dataset_id = dataset_uid,template=template,meta_name=meta_name,meta_value = meta_value)


  }
  themes  <- theme_list %>% unlist()

  # Bis zu 5 Themen können hinzugefügt werden
  set_metadata(dataset_id = dataset_uid,template="default",meta_name="theme",meta_value = themes)

  if (harvesting) {
    # Harvesting separat je nach Wunsch einfügen
    set_metadata(dataset_id = dataset_uid,template="custom",meta_name="tags",meta_value = list("opendata.swiss"))
  }

  if (is.list(zuschreibungen)) {
    # Zuschreibungen separat je nach Wunsch einfügen
    tryCatch({
      set_metadata(dataset_id = dataset_uid,template="default",meta_name="attributions",meta_value = zuschreibungen)

    }, error = function(cond) {

    })

  }
  return(dataset_uid)
}
