#' write_ogd
#'
#' Funktion um Datensatz mit korrekten OGD Spezifikationen als csv zu speichern.
#'
#' @param data R Dataframe
#' @param file Pfad zum Speicherort (muss mit .csv enden)
#'
#' @export
#'
write_ogd <- function(data,file){
  write.table( #Write Table als basis funktion von write.csv, da Spezifikationen hier möglich sind
    data,
    file = file,
    quote = T, #Anfuehrungszeichen um Strings und Factors
    sep = ",", # Komma als Trennzeichen
    dec = ".", # Punkt als Dezimaltrenner
    row.names = F, #Keine Reihennamen
    fileEncoding = "UTF-8" #UTF-8 Encoding
  )
  message("Datensatz gespeichert als csv.")
}
