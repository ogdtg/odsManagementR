#' update_attachements
#'
#' Funktion um Datensatz Anhänge zu löschen und neue hochzuladen
#'
#' @param dataset_uid dataset_uid,dataset_id oder Datensatz Titel können angegeben werden
#' @param directory Pfad zu Ordner welcher alle Anlagen enthält (Wenn nicht NULL, werden alle Inhalte des Ordners hochgeladen)
#' @param files eines oder mehrere Files die als Anlage hochgeladen werden
#'
#' @export
#'
update_attachements <- function(directory=NULL, files=NULL, dataset_uid) {
  delete_attachements(dataset_uid = dataset_uid)
  add_attachments(directory = directory, files = files, dataset_uid = dataset_uid)


}
