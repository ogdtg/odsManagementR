#' write_names_to_schema (funktioniert nur mit formatierter Schema Excel, keine API Funktion)
#'
#' @param filepath Pfad zum amtspezifischen Excel File
#' @param orginal_names_df Spaltennamen, die das Amt geliefert hat
#' @param new_names_df Neue Namen, konfrom mit OGD Leitlinien
#'
#' @importFrom XLConnect writeWorksheet
#' @importFrom XLConnect loadWorkbook
#' @importFrom XLConnect setStyleAction
#' @importFrom XLConnect saveWorkbook
#'
#' @export
#'
write_names_to_schema <- function(filepath,orginal_names_df,new_names_df) {
  wb <-  XLConnect::loadWorkbook(filepath,create=TRUE)
  XLConnect::setStyleAction(wb,XLC$"STYLE_ACTION.NONE")

  XLConnect::writeWorksheet(wb, original_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 1)
  XLConnect::writeWorksheet(wb, new_names_df, sheet = "Spaltenbeschreibungen", startRow = 1, startCol = 2)
  XLConnect::saveWorkbook(wb)
}
