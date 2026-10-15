require("dependencias")

ventana = {
    ancho = 160,
    alto = 144,
    escala = 4,

    camara_centro_x = 0,
    camara_centro_y = 0,

    mapa_ancho = 0,
    mapa_alto = 0
}

miFuentePequena = love.graphics.newFont(10)

ataque = nil
aura = nil

derrota = false
victoria = false
depurar = true

estado = nil
fuente = nil
mapa = nil
camara_principal = nil
mundo = nil
textoVida=" "
--[[
function debugUI()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    if atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
    end
    love.graphics.setColor(1, 1, 1)
end
]]
-- Busca esta función en main.lua y reemplázala por esta versión:
function debugHitboxes()
    love.graphics.setColor(1, 0, 0) -- Rojo para el jugador
    -- Ahora usamos self.x y self.y directamente
    love.graphics.rectangle("line", redondear(jugador.x), redondear(jugador.y), jugador.ancho, jugador.alto)
    
    -- Punto verde en el centro real del sprite (para referencia visual)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", redondear(jugador.x + jugador.ancho/2), redondear(jugador.y + jugador.alto/2), 2)
    
    love.graphics.setColor(0, 0, 1) -- Azul para enemigos
    for i, enemigo in ipairs(enemigos or {}) do
        if enemigo.x then -- Verificación de seguridad
            love.graphics.rectangle("line", redondear(enemigo.x), redondear(enemigo.y), enemigo.ancho, enemigo.alto)
        end
    end
    love.graphics.setColor(1, 1, 1) -- Restaurar color blanco
end

function love.load()
    -------------------------------------------------
    -- Ventana
    -------------------------------------------------
    love.window.setMode(
        ventana.ancho * ventana.escala,
        ventana.alto * ventana.escala
    )
    love.graphics.setDefaultFilter(    "nearest",  "nearest"  )
    -------------------------------------------------
    -- Mundo físico
    -------------------------------------------------
    world = love.physics.newWorld(0, 0, true)
    mapa = STI("mapa/bosque1.lua")
    mundo = Bump.newWorld(16)  --aqui decia 16
    
    -------------------------------------------------
    -- Colisiones del mapa
    -------------------------------------------------

    if mapa.layers["Colisiones"] then
    for _, obj in ipairs( mapa.layers["Colisiones"].objects  ) do
     obj.es_pared = true
        mundo:add(    obj,   obj.x,  obj.y,  obj.width, obj.height
        )
    end
    end
    function UIVidas(vidas)
       textoVida = "Vidas: " .. vidas
    end
   
   -- Registrar el evento personalizado
   love.handlers.actuaizarVidas = UIVidas


    -------------------------------------------------
    -- Escenario
    -------------------------------------------------
    CrearEscenario()

    -------------------------------------------------
    -- Canvas
    -------------------------------------------------
    canvas = love.graphics.newCanvas(
        ventana.ancho,
        ventana.alto
    )

    fuente = love.graphics.newFont(
        "fuente/SnackerComic_PerosnalUseOnly.ttf",
        40
    )

    depurar = true
    atrapado = false

    puntuacionListener =    OyentePuntuacion()
    vidaListener =   OyenteVida()
    audioListener =    OyenteAudio()
    gameOverListener =    OyenteGameOver()
    victoriaListener =    OyenteVictoria()
    -- function love.load()

    -- Crear observadores

    puntuacionListener =  OyentePuntuacion()

    vidaListener =    OyenteVida()

    audioListener =   OyenteAudio()

    gameOverListener =   OyenteGameOver()

    victoriaListener =  OyenteVictoria()

    -- Registrar suscripciones

    EventManager:suscribir(
        "MONEDA_RECOGIDA",
        puntuacionListener
    )

    EventManager:suscribir(
        "MONEDA_RECOGIDA",
        audioListener
    )

    EventManager:suscribir(
        "MONEDA_RECOGIDA",
        victoriaListener
    )

    EventManager:suscribir(
        "JUGADOR_DANADO",
        vidaListener
    )

    EventManager:suscribir(
        "JUGADOR_DANADO",
        audioListener
    )

    EventManager:suscribir(
        "JUGADOR_DANADO",
        gameOverListener
    )



    -------------------------------------------------
    -- Máquina de estados
    -------------------------------------------------

    MaquinaEstadoGlobal = MaquinaEstado{

        ['jugar'] = function()
            return EstadoJugar()
        end,

        ['titulo'] = function()
            return EstadoTitulo()
        end,
        ['victoria'] = function()
        return EstadoVictoria()
        end,
        ['derrota'] = function()
            return EstadoDerrota()
        end

    }

    MaquinaEstadoGlobal:cambiar(
        'titulo',
        {
            titulo = "Juego del Duende",
            subtitulo = "Atrapa Monedas",
            copyR = "Presione Enter"
        }
    )

    -------------------------------------------------
    -- Cámara
    -------------------------------------------------

    camara_principal = Camara()

    ventana.camara_centro_x =    ventana.ancho * 0.5
    ventana.camara_centro_y =    ventana.alto * 0.5
    ventana.mapa_ancho =       mapa.width * mapa.tilewidth
    ventana.mapa_alto =        mapa.height * mapa.tileheight
end
function love.handlers.modoDebug()
     depurar = not depurar
end    
function redondear(num)
    return math.floor(num + 0.5)
end

function love.keypressed(key)
    if key == "escape" then
        MaquinaEstadoGlobal:cambiar(
            'titulo',
            {
                titulo = "Juego del Duende",
                subtitulo = "Atrapa Monedas",
                copyR = "E.D.B"
            }
        )

    end

    if key == "f1" then
        -- depurar = not depurar
        love.event.push('modoDebug')
    end
    if (key == "X") or (key == "x") then
       return
    end

    if aura and key == "z" then
        aura.activado = true
    end

    if key == "return" then
        MaquinaEstadoGlobal:cambiar("jugar")
    end
end

function love.update(dt)
    if camara_principal then
        if camara_principal.x < ventana.camara_centro_x then
            camara_principal.x = ventana.camara_centro_x
        end

        if camara_principal.y < ventana.camara_centro_y then
            camara_principal.y = ventana.camara_centro_y
        end

        -- Corrección de variables de ancho/alto horizontal
        if camara_principal.x > (ventana.mapa_ancho - ventana.camara_centro_x) then
            camara_principal.x = (ventana.mapa_ancho - ventana.camara_centro_x)
        end

        if camara_principal.y > (ventana.mapa_alto - ventana.camara_centro_y) then
            camara_principal.y = (ventana.mapa_alto - ventana.camara_centro_y)
        end
    end
 --- limites de camara_principal
    if camara_principal.x < ventana.ancho * 0.5 then
        camara_principal.x = ventana.ancho * 0.5
    end

    if camara_principal.y < ventana.alto * 0.5 then
        camara_principal.y = ventana.alto * 0.5
    end

    local mapa_ancho = mapa.width * mapa.tilewidth
    local mapa_alto  = mapa.height * mapa.tileheight

    if camara_principal.x > (mapa_ancho - ventana.ancho * 0.5) then
        camara_principal.x = (mapa_ancho - ventana.ancho * 0.5)
    end

    if camara_principal.y > (mapa_alto - ventana.alto * 0.5) then
        camara_principal.y = (mapa_alto - ventana.alto * 0.5)
    end
    world:update(dt)
    MaquinaEstadoGlobal:actualizar(dt)
end

function love.draw()
love.graphics.setFont(miFuentePequena)
    -- mapa:draw()

    MaquinaEstadoGlobal:dibujar()
    if (derrota == false) and  (victoria == false) then
        love.graphics.print(textoVida,300,10)
    else
        love.graphics.print("            ",300,10)
    end
    

end
