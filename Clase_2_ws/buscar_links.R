obtener_links <- function(){
  
  palabra <<- readline("Ingrese la/s palabra/s clave/s: ")
  
  if(length(palabra > 1)){
    
    palabra <- gsub(" ", "-", palabra)
    
  }
  
  raiz <- "https://www.diariodepontevedra.es"
  
  busqueda <- paste0(raiz,"/tags/" ,palabra)
  
  #lectura <- read_html(busqueda)
  #  Busca la pagina más alta 
  max_pag <- 1
  
  repeat {
    
    pagina_actual <- paste0(busqueda,"?page=", max_pag)
    
    #pagina_base <- "https://www.diariodepontevedra.es/tags/buenos-aires?page="
    
    lectura <- tryCatch(read_html(pagina_actual), 
                        error = function(e) NULL)
    
    if (is.null(lectura) || length(lectura %>% 
                                   html_nodes(".pagination a") %>% 
                                   html_text() 
                                   %>% 
                                   as.numeric()) == 0) {
      max_pag <- max_pag - 1  # Última página válida
      
      break
    }
    
    max_pag <- max_pag + 1
  }
  
  ##
  
  
  buscar_links <- c()
  
  for( i in 1:max_pag){
    
    recolectar_links <- paste0(busqueda, "?page=",i)
    
    paginas <- read_html(recolectar_links) %>%
      html_elements("h2.title") %>% 
      html_elements("a") %>% 
      html_attr("href")
    
    paginas_completas <- str_c(raiz, paginas)
    
    buscar_links <- append(buscar_links, paginas_completas)
  }
  
  return(buscar_links)
  
}