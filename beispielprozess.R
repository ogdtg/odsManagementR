# Beispielprozess OGD: ABB

# Stand
# Abklärung mit Amt hat stattgefunden
# Daten sind bei der OGD KS angekommen

# Aufgabe
# 1. Daten aufbereiten, variablennamen in Schema einpflegen, Schema zum Ausfüllen an Amt senden
# 2. Schema wird von Amt ausgefüllt, Schema einlesen, Datenvervollständigen, letzter Check, veröffentlichen


# Datenaufbereitung und Schema erstellen
# Aus datenaufbereitung_abb.R


#########################
### Daten aufbereiten ###
#########################

#############################################################
#############################################################

### Hier kann auch source() benutzt werden um Skript schlanker zu halten
# packages für Datenaufbereitung

library(dplyr)
library(readxl)
library(XLConnect)

# Working directory setzen
path <- "Y:/SK/SKStat/Internet/4_OGD_Daten/Exceltabellen_Word/Amt für Berufsbildung und Berufsberatung/Abschlüsse Berufliche Grundbildung/"

# Excel files listen
files_vec <- list.files(path = path,pattern = "*.xlsx")
files_vec <- files_vec[-grep("\\$",files_vec)]


data_list <- lapply(files_vec, function(x){
  tryCatch({
    temp <- readxl::read_excel(paste0(path,x),sheet = 1)
    names_amt <<- names(temp) #originalnamen
    names(temp) <- tolower(names(temp)) #Kleinbuchstaben für spaltennamen
    names(temp)[4] <- "efz_eba"
    temp$jahr <- stringr::str_extract(x,"\\d+")
    return(temp)
  },
  error = function(cond){
    print("Not possible")
    return(NULL)
  })

})


# Namen für bind_rows
names(data_list) <- paste0("Statistik Grundbildung ",2017:2021)

# zusammenführen zu einem Datensatz
df_full = data_list %>% bind_rows()

# Originale Namen zum besseren verständnis
original_names_df <- data.frame(Name_Original=names_amt)

# Neue Namen
new_names_df <- data.frame(Name_Neu=names(df_full))
# Sollten grössere Aufbereitungsschritte getätigt und neue Variablen eingefügt werden, müssen diese erklärt werden

# Daten als csv abspeichern
write_ogd(df_full,"Output Daten/lernende_api.csv")

#############################################################
#############################################################

# In Excel sheet schrieben


write_names_to_schema <- function(filepath,orginal_names_df,new_names_df) {
  wb <-  XLConnect::loadWorkbook(filepath,create=TRUE)
  XLConnect::setStyleAction(wb,XLC$"STYLE_ACTION.NONE")

  XLConnect::writeWorksheet(wb, original_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 1)
  XLConnect::writeWorksheet(wb, new_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 2)
  XLConnect::saveWorkbook(wb)
}

write_names_to_schema("schema_template - ABB.xlsx",orginal_names_df,new_names_df)

####################################################
# Schema wird nun an Amt gesendet und ausgefüllt  ##
# Nach Ausfüllen geht es weiter mit der Eintragung #
####################################################


#############################
### Metadaten aufbereiten ###
#############################




add_metadata_from_scheme <- function(filepath, harvesting = TRUE, zuschreibungen = NULL) {

  # Parameter check
  if (!is.logical(harvesting)){
    stop("harvesting Parameter muss entweder TRUE oder FALSE sein")
  }

  if (!is.null(zuschreibungen)){
    temp <- zuschreibungen %>% unlist() %>% is.character()
    if (!temp) {
      stop("zuschreibungen muss liste von character elementen sein")
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



add_data_to_dataset <- function(dataset_uid,schema,ogd_file,resource_title){

  # Upload zu ODS
  filename_ods <- upload_file_to_ods(ogd_file)

  # Hochegladenes File zu Datenquelle machen
  add_resource_to_data(filename_ods$file_id,dataset_uid = dataset_uid,title = resource_title)

  spalten <- read_excel(schema,sheet="Spaltenbeschreibungen")


  for (i in 1:nrow(spalten)){
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




























# Metadaten aus excel file einlesen
metadata_test <- read_excel("schema_template - ABB_amt.xlsx",sheet="Metadaten")
names(metadata_test)[1]<-"Metadata"
metadata_test["Beispiel"]<-NULL

#setUser zur Authentifizierung

# relevante Felder

template_names <- c("dcat","default","default","default","default","default","default","default","default","default","default")
meta_names <- c("creator","title","description","keyword","publisher","references","theme","theme","theme","theme","theme")
join_col <- c("Amt","Titel","Beschreibung","Schluesselwoerter","Amt","Referenz","Thema 1","Thema 2","Thema 3","Thema 4","Thema 5")

meta_template_df <- data.frame(template_names,meta_names,join_col)
#saveRDS(meta_template_df,"meta_template_df.rds")
# Template Datensatz kopieren (befüllt mit Standardmetadaten) und Titel + ID einfügen, dataset_uid speichern für weiterverarbeitung
# da_qwsbz2 = template datensatz mit Standardmetadaten befüllt

part_id <- metadata_test$Eintrag[which(metadata_test$Metadata=="Kennung")]
title_meta <- metadata_test$Eintrag[which(metadata_test$Metadata=="Titel")]

dataset_id <- create_new_dataset_id(part_id)

dataset_uid <- duplicate_dataset(copy_id = "da_qwsbz2",new_id = dataset_id,title = title_meta)

# Restliche Metadaten einpflegen

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

# Harvesting separat je nach Wunsch einfügen
set_metadata(dataset_id = dataset_uid,template="custom",meta_name="tags",meta_value = list("opendata.swiss"))

# Zuschreibungen separat je nach Wunsch einfügen
set_metadata(dataset_id = dataset_uid,template="default",meta_name="attributions",meta_value = list("link1","link2"))

####################################################################################
####################################################################################
# Metadaten sind eingepflegt
# siehe https://data.tg.ch/backoffice/catalog/datasets/dek-abb-2/#information


##############################
### DATENQUELLE HINZUFÜGEN ###
##############################

# Upload zu ODS
filename_ods <- upload_file_to_ods("Output Daten/lernende_api.csv")
ods_files <- list_ods_files()

# Hochegladenes File zu Datenquelle machen
add_resource_to_data(filename_ods$file_id,dataset_uid = dataset_uid,title = "API: Abschlüsse Berufliche Grundbildung seit 2017")
get_dataset_resource(dataset_uid)

#######################################
### SPALTENBESCHREIBUNGN HINZUFÜGEN ###
#######################################

spalten <- read_excel("schema_template - ABB_amt.xlsx",sheet="Spaltenbeschreibungen")


for (i in 1:nrow(spalten)){
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


add_datetime_precision(
  dataset_uid = dataset_uid,
  field_name = spalten$Name_Neu[17],
  annotation_args = list(spalten$precision[17])
)

fields <- get_field_processors(dataset_uid)


res <- add_type(dataset_uid = dataset_uid,field_name = "jahr","text")


# Funktioniert nicht wie gewünscht
add_datetime_precision <- function(dataset_uid,field_name,annotation_args){
  body <-
    create_fields_body(
      configuration_item = "annotate",
      edit_field_id = field_name,
      new_annotation = "timeserie_precision",
      annotation_args = annotation_args
    )
  res=add_field_config(body=body,dataset_id = dataset_uid)

  tryCatch({
    result <- res$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$processor_uid
  },
  error = function(cond){
    result <- res$status_code
  })

  return(res)

}






