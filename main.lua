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
function debugHitboxes()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", redondear(jugador.hitbox_x) , redondear(jugador.hitbox_y), jugador.ancho, jugador.alto)
    love.graphics.circle("fill", redondear(jugador.x), redondear(jugador.y), 1)

    for i, enemigo in ipairs(enemigos) do
        enemigo:Debug()
    end
    love.graphics.setColor(1, 1, 1)
end

function love.load()

    -------------------------------------------------
    -- Ventana
    -------------------------------------------------

    love.window.setMode(
        ventana.ancho * ventana.escala,
        ventana.alto * ventana.escala
    )

    love.graphics.setDefaultFilter(
        "nearest",
        "nearest"
    )

    -------------------------------------------------
    -- Mundo físico
    -------------------------------------------------

    world = love.physics.newWorld(0, 0, true)

    mapa = STI("mapa/bosque1.lua")

    mundo = Bump.newWorld(16)  --aqui decia 16
    --- jugador= Jugador(ventana.ancho/2, ventana.alto/2, 72, mundo)

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
        depurar = not depurar
    end
    if (key == "X") or (key == "x") then
       -- exit
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

end
