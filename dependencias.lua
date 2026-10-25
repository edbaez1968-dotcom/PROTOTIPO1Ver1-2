-- Incluye librería para manejar clase
Class = require 'lib.class'
STI = require 'lib.sti'
Camara = require 'lib.camera'
Bump = require 'lib.bump'
Timer = require 'lib.timer'

-- Importar Clases
require "Entidad"
require "jugador"
require "enemigo"
require "moneda"
require "escenario"
require "animaciones"
require "camara"
-- Importar Estados
-- estados ( game states)son las distintas pantallas, fases o modos lógicos en los que se puede encontrar un juego
 require "estado"
 require "estadoJugar"
 require "estadoTitulo"
 require "estadoDerrota"
 require "estadoVictoria"
 require "maquinaEstado"

 require "EventManager"
 require "OyentePuntuacion"
 require "OyenteVida"
 require "OyenteAudio"
 require "OyenteGameOver"
 require "OyenteVictoria"

 require "CoroutineManager"




