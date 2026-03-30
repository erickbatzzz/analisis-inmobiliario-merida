# =============================================================================
# Proyecto:  Análisis del mercado inmobiliario - Mérida, Yucatán, México
# Fecha de inicio:                 29/03/2026
# =============================================================================

# 1. Cargamos librerías
library(pacman)
p_load(here, tidyverse, janitor, rvest, usethis)

# Vamos a crear un objeto .env para colocar ahí nuestro token para descargar
# los datos del DENUE y que sea anónimo, este token es personal y se obtiene 
# en la página del INEGI.

edit_r_environ(scope = "project")
# 2. Descargamos los datos que nos interesan del DENUE del INEGI
# 2.1 IMPORTANTE: Revisamos primero los datos que nos ofrece el API del DENUE



