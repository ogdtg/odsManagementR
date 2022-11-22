#' invite_user_to_data
#'
#' Funktion um User via Email hinzuzufügen und Berechtigungen für bestimmten Datensatz zuzuteilen. Kann vor der Veröffentlichung von OGD
#'
#' @param dataset_uid Datensatz UID
#' @param email Email des Users
#' @param permission_list Liste von Berechtigungen. Default ist "explore_restricted_dataset"
#'
#' @export
#'
invite_user_to_data <- function(dataset_uid,email,permission_list = list("explore_restricted_dataset")) {

  if (!is.list(email)) {
    if (is.vector(email)) {
      email <- list(email)
    } else if (is.na(email) || is.null(email)) {
      stop("email cannot be NA or NULL")
    } else {
      email <- list(email)
    }
  }
  # User hinzufügen
  add_user(email)

  # Username extrahieren
  user_data <- get_users()
  user_data <- user_data$user_info
  username <- user_data$username[which(user_data$email==email)]

  # User zum Datensatz hinzufügen
  add_user_to_data(dataset_uid=dataset_uid,username = username,permission_list = permission_list)

  #publish_dataset(dataset_uid = dataset_uid)
}
