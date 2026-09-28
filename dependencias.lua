-- Incluye librería para manejar clase
Class = require 'lib.class'
STI = require 'lib.sti'
Camara = require 'lib.Camera'
Bump = require 'lib.bump'

-- Importar Clases
require "jugador"
require "enemigo"
require "moneda"
require "escenario"
require "animaciones"


-- Importar Estados
-- estados ( game states)son las distintas pantallas, fases o modos lógicos en los que se puede encontrar un juego
 require "estado"
 require "estadoJugar"
 require "estadoTitulo"
 require "estadoDerrota"
 require "maquinaEstado"