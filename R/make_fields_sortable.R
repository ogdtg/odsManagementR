#' make_fields_sortable
#'
#' Funktion um angegebene Felder sortierbar zu machen. Funktion betrifft nur Text Felder. Andere Felder bleiben unverändert.
#'
#' @param dataset_uid dataset_uid
#' @param fields Vektor mit Feldnamen
#'
#' @export
#'
make_fields_sortable <- function(dataset_uid, fields) {

  f<- lapply(fields, function(name) {
    body <-
      create_fields_body(
        configuration_item = "annotate",
        edit_field_id = name,
        new_annotation = "sortable",
        annotation_args = NULL
      )
    res <- add_field_config(dataset_id = dataset_uid, body = body)
  })
}
