
require("dependencias")
ventana = { -- 192,208
    ancho = 160,
    alto = 144,
    escala = 4,
    camara_centro_x= 0,
    camara_centro_y= 0,
    mapa_ancho= 0,
    mapa_alto= 0
}

miFuentePequena = love.graphics.newFont(10)
ataque = nil
aura = nil

-- Estados del juego
derrota = false
victoria = false
estado = nil
fuente= nil
mapa = nil
camara_principal= nil
mundo= nil

function love.load()
    -- 1. Configuración del Escenario / Ventana
    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Inicializar mundo físico para el escenario
    world = love.physics.newWorld(0, 0, true)
    mapa = STI("mapa/bosque1.lua")
    mundo =Bump.newWorld(16)
    
    if mapa.layers["Colisiones"] then
    for _, obj in ipairs(mapa.layers["Colisiones"].objects) do
        obj.es_pared=true
        mundo:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end
    -- Crear las estructuras del escenario (definido en escenario.lua)
    CrearEscenario()
    -- Canvas para escalar todos los elementos manteniendo Pixel Art nítido
    canvas = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    fuente= love.graphics.newFont('fuente/SnackerComic_PerosnalUseOnly.ttf',40)
    -- Variables del Sistema de Depuración y Colisión
    depurar = false
    atrapado = false
    
    
    -- estado= EstadoTitulo("El duende")
    MaquinaEstadoGlobal= MaquinaEstado{
        ['jugar']= function() return EstadoJugar() end,
        ['titulo']= function() return EstadoTitulo() end,
        ['derrota']= function() return EstadoDerrota() end
       -- ['atrapado'] = function() return EstadoAtrapado() end -- Registrar aquí el nuevo estado 
         
    }
    MaquinaEstadoGlobal:cambiar('titulo', {titulo="Juego del Duende", subtitulo="Atrapa Monedas", copyR="Presione Enter"})
    
    camara_principal= Camara()
    ventana.camara_centro_x = ventana.ancho * 0.5
    ventana.camara_centro_y =  ventana.ancho * 0.5
    ventana.mapa_ancho = mapa.width * mapa.tilewidth
    ventana.mapa_alto = mapa.height * mapa.tileheight

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
    if key == "escape" then
        -- estado= EstadoTitulo("El duende")
        MaquinaEstadoGlobal:cambiar('titulo', {titulo="Juego del Duende", subtitulo="Atrapa Monedas", copyR="E.D.B"})

    end
    if key == "f1" then
        depurar = not depurar
    -- elseif (key == "space" or key == "space") and not ataque.activado then
       -- ataque.activado = true
       -- love.audio.play(Sfx_ataque)
    end
    if key == "z" and not aura.activado then
        -- El aura solo se activa al presionar la tecla Z
        aura.activado = true
    end
    if key == "return" then
       -- estado= EstadoJugar()
       MaquinaEstadoGlobal:cambiar('jugar')
    end
    
end
function love.update(dt)
    
if camara_principal.x < ventana.camara_centro_x then
    camara_principal.x = ventana.camara_centro_x
end

if camara_principal.y < ventana.camara_centro_y then
    camara_principal.y = ventana.camara_centro_y
end

if camara_principal.x > (ventana.mapa_alto - ventana.camara_centro_y) then
    camara_principal.x = (ventana.mapa_ancho - ventana.camara_centro_x)
end
if camara_principal.y > (ventana.mapa_alto - ventana.camara_centro_y)  then
    camara_principal.y = (ventana.mapa_alto- ventana.camara_centro_y)
end

    -- Actualizar mundo físico y entidad del jugador
    world:update(dt)
   -- estado:actualizar(dt)
   MaquinaEstadoGlobal:actualizar(dt)
   

end
function love.draw()
    --estado:dibujar()
    mapa:draw()
    MaquinaEstadoGlobal:dibujar(dt)
    
end