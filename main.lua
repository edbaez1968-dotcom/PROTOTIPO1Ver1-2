
require("dependencias")
ventana = {
    ancho = 160,
    alto = 180,
    escala = 4
}

miFuentePequena = love.graphics.newFont(10)
ataque = nil
aura = nil

-- Estados del juego
derrota = false
victoria = false
estado = nil

function love.load()
    -- 1. Configuración del Escenario / Ventana
    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Inicializar mundo físico para el escenario
    world = love.physics.newWorld(0, 0, true)
    -- Crear las estructuras del escenario (definido en escenario.lua)
    CrearEscenario()
    -- Canvas para escalar todos los elementos manteniendo Pixel Art nítido
    canvas = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    
    -- Variables del Sistema de Depuración y Colisión
    depurar = false
    atrapado = false
    estado= EstadoJugar()
end

-- Función auxiliar para redondeo (Pixel Perfect)
function redondear(num)
    return math.floor(num + 0.5)
end

-- Detección de Colisiones AABB
function comprobarColision(aX, aY, aAncho, aAlto, bX, bY, bAncho, bAlto)
    return aX < bX + bAncho and
           bX < aX + aAncho and
           aY < bY + bAlto and
           bY < aY + aAlto
end

function love.keypressed(key)
    -- Activar / Desactivar modo Depuración con F1
    if key == "f1" then
        depurar = not depurar
    elseif (key == "space" or key == "space") and not ataque.activado then
        ataque.activado = true
        love.audio.play(Sfx_ataque)
    elseif key == "z" and not aura.activado then
        -- El aura solo se activa al presionar la tecla Z
        aura.activado = true
    end
end
function love.update(dt)
    -- Actualizar mundo físico y entidad del jugador
    world:update(dt)
   estado:actualizar(dt)

end
function love.draw()
    estado:dibujar()
end