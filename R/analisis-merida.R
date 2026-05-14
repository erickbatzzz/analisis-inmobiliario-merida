# =============================================================================
# Proyecto: Investigación de constructoras y mercado inmobiliario en Mérida, MX
# Fecha inicio:                         12/03/2026
# Datos:          Directorio Estadístico Nacional de Unidades Económicas
#           y datos abiertos del Sistema Nacional de Indicadores de Vivienda
# ============================================================================


# Carga de librerías ------------------------------------------------------

library(pacman)
p_load(here, tidyverse, janitor, wesanderson, skimr)


# Carga de datos ----------------------------------------------------------
# Correr antes: utils_general.R 

cargar_datos(datos)


# inspección de la base del DENUE ----------------------------------------

skim(datos_denue)
view(count(datos_denue, ))





