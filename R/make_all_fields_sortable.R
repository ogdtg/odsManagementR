#' make_all_fields_sortable
#'
#' Funktion um alle Felder sortierbar zu machen. Funktion wird der Einfachheit halber auf ALLE Felder angewendet. Allerdings werden nur Textfelder verändert. Andere Datentypen werden NICHT verändert.
#'
#' @param dataset_uid dataset_uid
#'
#' @export
#'
make_all_fields_sortable <- function(dataset_uid) {
  temp <- get_field_processors(dataset_uid)
  names <- unique(temp$args$field)

  f<- lapply(names, function(name) {
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
