#' set_metadata_from_df
#'
#' Funktion um Metadaten aus einem ODS Metadaten data.frame zu setzen
#'
#' @importFrom jsonlite fromJSON
#' @importFrom jsonlite toJSON
#' @importFrom httr PUT
#' @importFrom httr authenticate
#'
#' @param dataset_id dataset_uid
#' @param metas Metadaten als Dataframe
#' @param title Titel um Kennung als Titel zu überschreiben
#' @export
#'
set_metadata_from_df <- function(dataset_id,metas,title) {

  tryCatch({
    pw=getPassword()
    usr=getUsername()
    domain=getDomain()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password,domain) first.")

  })


  final_list <- list()
  for (i in 1:nrow(metas)) {

    if (metas$name[i] %in% c("modified","created","issued","geographic_reference_auto","theme_id","draft")) {
      next
    }

    if (is.null(metas$value[i][[1]])) {
      next
    }
    if (metas$template$name[i]%in% c("default","dcat","dcat_ap_ch","internal")) {

      if (metas$name[i]=="geographic_reference"){
        temp <- list(template_name = metas$template$name[i],metadata_name = metas$name[i], override_remote_value=TRUE, value =list(metas$value[i][[1]]) )

      } else {
        temp <- list(template_name = metas$template$name[i],metadata_name = metas$name[i], override_remote_value=TRUE, value =metas$value[i][[1]] )
      }

      final_list[[i]] <- temp
    } else {
      next
    }

  }
  final_list[sapply(final_list, is.null)] <- NULL

  new_values <- list(metas=final_list) %>% jsonlite::toJSON(auto_unbox = T)


  httr::PUT(url = paste0("https://",domain,"/api/management/v2/datasets/",dataset_id,"/metadata/"),
            httr::authenticate(usr, pw),
            body = new_values)

  set_title(title = title,dataset_id = dataset_id )

}
