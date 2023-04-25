#' create_fields_body
#'
#' Funktion um passenden JSON Body für API Request zu erstellen
#'
#' @param edit_field_id Feld das bearbeitet werden soll
#' @param new_name Neuer Name ("rename")
#' @param new_label Neues Label ("rename")
#' @param new_type Neuer Variablentyp ("type")
#' @param new_annotation Neue Annotation ("annotate")
#' @param annotation_args Argumente für Annotation ("annotate")
#' @param new_description Neue Beschreibung einer Variablen ("description)
#' @param new_order Neue Reihenfolge ("order")
#' @param configuration_item "rename", "type", "annotate", "description", "order" oder "delete"
#'
#' @importFrom jsonlite toJSON
#'
#' @return JSON Body für entsprechenden API request
#'
create_fields_body <- function(configuration_item,edit_field_id,new_name=NULL,new_label=NULL,new_type=NULL,new_annotation=NULL,annotation_args=NULL,new_description=NULL,new_order=NULL){

  if (configuration_item=="rename") {
    if (is.null(new_name)||is.null(new_label)){
      stop("Please provide character strings for new_name and new_label")
    }
    body = list(
      name = configuration_item,
      args = list(
        from_name = edit_field_id,
        to_name = new_name,
        label = new_label
      )
    )
  }

  if (configuration_item=="type") {
    if (is.null(new_type)){
      stop("Please provide valid type in character representation. See https://betahelp.opendatasoft.com/management-api/#type")
    }
    body = list(
      name = configuration_item,
      args = list(
        field = edit_field_id,
        type = new_type
      )
    )

  }

  if (configuration_item=="annotate") {
    if (is.null(new_annotation)){
      stop("Please provide valid annotation in character representation. See https://betahelp.opendatasoft.com/management-api/#annotate")
    }
    body = list(
      name = configuration_item,
      args = list(
        field = edit_field_id,
        annotation = new_annotation,
        args = list(annotation_args)
      )
    )
    if (is.null(body$args$args[[1]])) {
      # warning("No annotation_args given. Body might not be correct")
      body$args$args <- NULL
    }
  }

  if (configuration_item=="description") {
    if (is.null(new_description)){
      stop("Please provide valid description in character representation.")
    }
    body = list(
      name = configuration_item,
      args = list(
        field = edit_field_id,
        description = new_description
      )
    )

  }

  if (configuration_item=="order") {
    if (is.null(new_order)){
      stop("Please provide a list with the new order of variables.")
    }
    body = list(
      name = configuration_item,
      args = new_order
    )

  }
  if (configuration_item=="delete") {
    body = list(
      name = configuration_item,
      args = list(
        field = edit_field_id
      )
    )

  }
  result_body = jsonlite::toJSON(body,auto_unbox = T)
  return(result_body)

}
