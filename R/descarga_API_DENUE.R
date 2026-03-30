# =============================================================================
# Proyecto:  Análisis del mercado inmobiliario - Mérida, Yucatán, México
#
# Fecha de inicio:                 29/03/2026
#
# Actividad:     Vamos a descargar los datos de las unidades económicas
#                encargadas de actividades de construcción de edificación
#                residencial en Mérida para hacer un análisis del mercado 
# =============================================================================

# 1. Cargamos librerías y preparamos environment ----
library(pacman)
p_load(here, tidyverse, janitor, rvest, usethis, httr2, jsonlite)

# Vamos a crear un objeto .renvion para colocar ahí nuestro token para descargar
# los datos del DENUE y que sea anónimo, este token es personal y se obtiene 
# en la página del INEGI.

edit_r_environ(scope = "project") # posteriormente, editamos el archivo 

# 2. Descargamos los datos que nos interesan del DENUE del INEGI ----
# 2.1 traemos nuestro token personal para consultar la API como objeto

token <- Sys.getenv("token_personal_DENUE")

# construimos el payload con los datos que nos interesa descargar
# importante: hay varias APIs que nos servirán para varias cosas, así que
#             hay que inspeccionar bien la página del INEGI

payload <- list(
  "entidad_federativa" = 31,
  "Municipio" = 0,
  "Localidad" = 0,
  "AGEB" = 0,
  "Manzana" = 0,
  "Sector" = 23,
  "Subsector" = 236,
  "Rama" = 2361,
  "Clase" = 0,
  "Nombre_del_establecimiento" = 0 ,
  "Registro_inicial" = 1,
  "Registro_final" = 1000,
  "Id" = 0
)

# Construimos la función para descargar la información que estamos buscando

descargar_denue <- function(payload, token){
  
  guia <- "https://www.inegi.org.mx/app/api/denue/v1/consulta/BuscarAreaAct/"
  
  parametros_path <- paste(
    payload$entidad_federativa,
    payload$Municipio,
    payload$Localidad,
    payload$AGEB,
    payload$Manzana,
    payload$Sector,
    payload$Subsector,
    payload$Rama,
    payload$Clase,
    payload$Nombre_del_establecimiento,
    payload$Registro_inicial,
    payload$Registro_final,
    payload$Id,
    token,
    sep = "/"
  )
  
  endpoint <- paste0(guia, parametros_path)
    
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
    cat("No se pudo establecer conexión :(", resp_status(rest), "en", url)
  }
   
}


data_denue<- descargar_denue(payload, token)

saveRDS(data_denue, 
        here("datos", "raw","denue_yuca_raw.rds"))

# 3. Vamos a limpiar un poquito esta base de datos:
#    ya que hay cosas que no nos interesan, vamos a eliminar unas variables
#    y vamos a separar la ubicación, que viene junta en una variable

vivienda_yucatan <- data_denue %>% 
  clean_names()

vivienda_yucatan <- vivienda_yucatan %>% 
  separate_wider_delim(cols = ubicacion,
                       delim = ",",
                       names = c("trash", "municipio", "estado")
                       ) %>%
  select(-trash, -clee, -id)


saveRDS(vivienda_yucatan, 
        here("datos", "DENUE_viv_yuca.rds"))





