# Beispielprozess OGD: ABB

# Stand
# Abklärung mit Amt hat stattgefunden
# Daten sind bei der OGD KS angekommen

# Aufgabe
# 1. Daten aufbereiten, variablennamen in Schema einpflegen, Schema zum Ausfüllen an Amt senden
# 2. Schema wird von Amt ausgefüllt, Schema einlesen, Datenvervollständigen, letzter Check, veröffentlichen


# Datenaufbereitung und Schema erstellen
# Aus datenaufbereitung_abb.R

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

### Daten aufbereiten

# Namen für bind_rows
names(data_list) <- paste0("Statistik Grundbildung ",2017:2021)

# zusammenführen zu einem Datensatz
df_full = data_list %>% bind_rows()

# Originale Namen zum besseren verständnis
original_names_df <- data.frame(Name_Original=names_amt)

# Neue Namen
new_names_df <- data.frame(Name_Neu=names(df_full))
# Sollten grössere Aufbereitungsschritte getätigt und neue Variablen eingefügt werden, müssen diese erklärt werden

#############################################################
#############################################################

# In Excel sheet schrieben
wb <- loadWorkbook("schema_template - ABB.xlsx",create=TRUE)
setStyleAction(wb,XLC$"STYLE_ACTION.NONE")

XLConnect::writeWorksheet(wb, original_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 1)
XLConnect::writeWorksheet(wb, new_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 2)
XLConnect::saveWorkbook(wb)


####################################################
# Schema wird nun an Amt gesendet und ausgefüllt  ##
# Nach Ausfüllen geht es weiter mit der Eintragung #
####################################################


# Metadaten aus excel file einlesen
metadata_test <- read_excel("schema_template - ABB_amt.xlsx",sheet="Metadaten")
names(metadata_test)[1]<-"Metadata"
metadata_test["Beispiel"]<-NULL

meta_template <- get_metadata("da_7xatt5")
# relevante Felder

theme_id = metadata_catalog$metas$internal$theme_id
theme = metadata_catalog$metas$default$theme



template_names <- c("dcat","default","default","default","default","default","default","default","default","default","default")
meta_names <- c("creator","title","description","keyword","publisher","references","theme","theme","theme","theme","theme")
join_col <- c("Amt","Titel","Beschreibung","Schluesselwoerter","Amt","Referenz","Thema 1","Thema 2","Thema 3","Thema 4","Thema 5")

meta_template_df <- data.frame(template_names,meta_names,join_col)

# Template Datensatz kopieren (befüllt mit Standardmetadaten) und Titel + ID einfügen, dataset_uid speichern für weiterverarbeitung
# da_qwsbz2 = template datensatz mit Standardmetadaten befüllt

part_id <- metadata_test$Eintrag[which(metadata_test$Metadata=="Kennung")]
title_meta <- metadata_test$Eintrag[which(metadata_test$Metadata=="Titel")]

dataset_id <- create_new_dataset_id(part_id)

dataset_uid <- duplicate_dataset(copy_id = "da_qwsbz2",new_id = dataset_id,title = title_meta)

# Restlichen Metadaten einpflegen

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
set_metadata(dataset_id = dataset_uid,template="default",meta_name="theme",meta_value = themes)


# Metadaten sind eingepflegt
