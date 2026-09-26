Estado = Class{}
-- Se ejecuta una sola vez al crear el juego o al instanciar el estado por primera vez.
function Estado:init() end
-- Se ejecuta justo en el momento en que el juego cambia a este estado .
function Estado:ingresar() end
--  Se ejecuta justo antes de abandonar este estado para ir a otro
function Estado:salir() end
-- Se ejecuta de forma continua, muchas veces por segundo (en cada fotograma)
function Estado:actualizar(dt) end
-- Se ejecuta en cada frame , inmediatamente después de actualizar.
function Estado:dibujar() end