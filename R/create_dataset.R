create_dataset <- function(identifier,title) {
  
  if (identifier %in% metadata_catalog$dataset_uid) {
    temp_title <- metadata_catalog$metas$default$title[which(metadata_catalog$dataset_uid==identifier)]
    stop(paste0("Datensatz ID schon vergeben an ",temp_title,"."))
  }
  
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })
  
  res <- create_empty_dataset(identifier)
  dataset_id = res$content %>% rawToChar() %>% fromJSON %>% .$dataset_uid
  set_title(title,dataset_id)
  return(dataset_id)
}