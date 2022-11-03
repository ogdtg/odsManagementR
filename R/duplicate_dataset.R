duplicate_dataset = function(copy_id,new_id,title) {
  
  tryCatch({
    pw=getPassword()
    usr=getUsername()
  },
  error = function(cond){
    stop("No User initialized. Please use setUser(username,password) first.")
  })
  
  
  tryCatch({
    metadata <- get_metadata(copy_id)
    new_uid <- create_dataset(identifier = new_id,title)
    metadata = metadata %>% 
      filter(!template$name %in% c("visualization")) %>% 
      filter(!name %in% c("created","modified","geographic_reference_auto","theme_id","draft"))
    
    set_metadata_from_df(new_uid,metas = metadata,title = title)
  }, error = function(cond){
    stop("Something went wrong")
  })
  
}