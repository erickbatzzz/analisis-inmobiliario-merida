
# Descripción -------------------------------------------------------------

# Vamos a utilizar este script para colocar funciones y temas específicos que 
# nos ayuden a los gráficos del proyecto, sin saturar el script de análisis



# ggplot2 themes ----------------------------------------------------------

# ---- Generamos temas predeterminados para gráficas ----
theme_regular <- function() {
  theme(plot.title = element_text(size = 15,
                                  hjust = 0.5),
        plot.subtitle = element_text(size = 9,
                                     hjust = 0.5),
        plot.title.position = "plot",
        plot.caption = element_text(size = 9,
                                    hjust = 1),
        plot.caption.position = "plot",
        legend.title = element_text(size = 11)
  )
}



# FUNCIÓN: cargar_datos() -------------------------------------------------
#
# Creamos esta función para cargar nuestros datos automáticamente, sin necesidad
# de sobrecargar nuestro script de análisis

datos <- list("datos_denue" = "DENUE_viv_yuca",
              "financiamiento_mid" = "financiamiento_mid",
              "produccion_mid" = "produccion_mid")

cargar_datos <- function(datos) {
  for (nombre in names(datos)){
    
    archivo <- datos[[nombre]]
    ruta <- here("datos", "processed",paste0(archivo,".rds"))
    
    if(file.exists(ruta)) {
      message(paste("cargando", archivo, "como objeto: ", nombre))
      data <- readRDS(ruta)
      assign(nombre, data, envir = .GlobalEnv)
    } else {
      print(paste("El archivo: ", archivo, "no existe"))
    }
  }
}

