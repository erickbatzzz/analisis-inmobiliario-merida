# =============================================================================
# Proyecto: Investigación de constructoras y mercado inmobiliario en Mérida, MX
# Fecha inicio:                         12/03/2026
# Datos:          Directorio Estadístico Nacional de Unidades Económicas
#           y datos abiertos del Sistema Nacional de Indicadores de Vivienda
# ============================================================================

# Cargamos librerías

library(pacman)
p_load(here, tidyverse, janitor, wesanderson, jsonlite, httr2)

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

# ---- Cargamos nuestros datos usando una función ----
datos <- list("datos_denue" = "DENUE_viv_yuca",
              "nada" = "nada")

cargar_datos <- function(datos) {
  for (nombre in names(datos)){
    
    archivo <- datos[[nombre]]
    ruta <- here("datos",paste0(archivo,".rds"))
    
    if(file.exists(ruta)) {
      message(paste("cargando", archivo, "como objeto: ", nombre))
      data <- read_rds(ruta)
      assign(nombre, data, envir = .GlobalEnv)
    } else {
      print(paste("El archivo: ", archivo, "no existe"))
    }
  }
}

cargar_datos(datos)





