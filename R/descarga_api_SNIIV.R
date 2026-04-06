# =============================================================================
# Proyecto: Investigación de constructoras y mercado inmobiliario en Mérida, MX
# Fecha inicio:                         12/03/2026
# Script:      Descarga de datos de producción y financiamiento del SNIIV
# =============================================================================

#---- cargamos librerías ----
library(pacman)
p_load(tidyverse, httr2, jsonlite)

# ---- creamos una función para descargar datos de financiamiento ----
# primero creamos la petición que le haremos a la API

params_finan <- list(
  año = c(2015,2025),
  estado = 31,
  mun = "050",
  dims = c("anio","mes","estado",
           "municipio","zona","destino_credito",
           "organismo", "valor_vivienda", "rango_edad")
)


descargar_finan <- function(p){
  api_guide <- "https://sniiv.sedatu.gob.mx/api/CuboAPI/GetFinanciamiento/"
  años_str <- paste(p$año, collapse = ",")
  dims_str <- paste(p$dims, collapse = ",")
  endpoint <- paste0(api_guide,
                     años_str,
                     "/",
                     p$est,
                     "/",
                     p$mun,
                     "/",
                     dims_str)
  
  rest <- request(endpoint) %>%
    req_headers(
      "user-agent"= "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36") %>%
    req_retry(max_tries = 3) %>%
    req_perform()
  
  if(resp_status(rest) == 200){
    cat("Conexión exitosa :)", endpoint)
    json_raw <- resp_body_string(rest)
    yeizon <- fromJSON(json_raw)
    
    return(as.data.frame(yeizon))
  } else {
    cat("No se pudo establecer conexión :(", resp_status(rest))
  }
}

# ejecutamos la función que creamos 

finan_mid <- descargar_finan(params_finan)

# Quiero comprobar si es que el ultimo año seleccionado está completo

print(finan_mid %>% 
        filter(año == 2025) %>% 
        group_by(mes) %>%
        summarise(cantidad = n())
      )
# guardamos los datos como un objeto .rds

saveRDS(finan_mid, here("datos",
                        "financiamiento_mid.rds"))

# --- creamos una función para bajar datos de producción de vivienda ----
# es básicamente la misma función que la anterior, solo cambiamos el API y las
# dimensiones

params_prod <- list(
  año = c(2015,2025),
  est = 31,
  mun = "050",
  dims = c("anio","mes","estado","municipio","segmento","pcu",
           "tipo_vivienda", "segmento_uma", "superficie", "recamara")
)

descargar_prod <- function(p){
  api_guide <- "https://sniiv.sedatu.gob.mx/api/CuboAPI/GetProduccion/"
  años_str <- paste(p$año, collapse = ",")
  dims_str <- paste(p$dims, collapse = ",")
  endpoint <- paste0(api_guide,
                     años_str,
                     "/",
                     p$est,
                     "/",
                     p$mun,
                     "/",
                     dims_str)
  
  rest <- request(endpoint) %>%
    req_headers(
      "user-agent"= "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36") %>%
    req_retry(max_tries = 3) %>%
    req_perform()
  
  if(resp_status(rest) == 200){
    cat("Conexión exitosa :)", endpoint)
    json_raw <- resp_body_string(rest)
    yeizon <- fromJSON(json_raw)
    
    return(as.data.frame(yeizon))
  } else {
    cat("No se pudo establecer conexión :(", resp_status(rest))
  }
}

prod_mid <- descargar_prod(params_prod)

# volvemos a comprobar que los meses estén completos antes de guardar :)

print(prod_mid %>% 
        filter(año == 2025) %>% 
        group_by(mes) %>% 
        summarise(conteo = n()))


# guardamos los datos de producción como .rds

saveRDS(prod_mid, here("datos", "produccion_mid.rds"))







