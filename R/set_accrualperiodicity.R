#' Set accrual periodicity
#' Set a value on how often data will be updated
#'
#' @param dataset_uid dataset_uid
#' @param value character for example "Annual" if data is updated every year
#'
#' @export
#'
set_accrualperiodicity <- function(dataset_uid,value = NULL){

  if (!is.null(value)) {
    if (value %in% c("jährlich", "Jährlich", "jahr", "Jahr")) {
      value <- "Annual"
    }
    else if (value %in% c("halbjährlich", "Halbährlich")) {
      value <- "Biannual"
    }
    else if (value %in% c("monatlich", "Monatlich", "Monat")) {
      value = "monthly"
    }
    else if (value %in% c("alle 4 Jahre", "4 Jahre")) {
      value <- "all 4 years"
    }
    else if (value %in% c("monatlich (Mai bis August)")) {
      value <- "monthly (May to August)"
    }
    else if (value %in% c("wöchentlich","Wöchentlich")) {
      value <- "weekly"
    }
    else if (value %in% c("täglich","Täglich")) {
      value <- "daily"
    } else {
      value = ""
    }
  }

  set_metadata(
    dataset_id = dataset_uid,
    template = "dcat",
    meta_name = "accrualperiodicity",
    meta_value = value
  )

}
