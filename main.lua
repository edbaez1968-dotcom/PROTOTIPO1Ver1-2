function love.load()
    -- 1. Configuración del Escenario / Ventana
    ventana = {
        ancho = 160,
        alto = 200,
        escala = 4
    }

    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Canvas para escalar todos los elementos manteniendo Pixel Art nítido
    canvas = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    -- 2. Creación del Jugador (Tabla)
    jugador = {
        x = 0,
        y = 0,
        velocidad = 50,
        hitboxX = 0,
        hitboxY = 0,
        sprite = love.graphics.newImage("img/Duende.png")
    }
    jugador.ancho = jugador.sprite:getWidth()
    jugador.alto = jugador.sprite:getHeight()
    jugador.origenX = jugador.ancho / 2
    jugador.origenY = jugador.alto / 2

    -- Posicionar al jugador en el centro del escenario
    jugador.x = ventana.ancho / 2
    jugador.y = ventana.alto / 2

    -- 3. Creación del Enemigo (Tabla)
    enemigo = {
        x = 20,
        y = 20,
        velocidad = 30,
        hitboxX = 0,
        hitboxY = 0,
        sprite = love.graphics.newImage("img/M1_16x16.png")
    }
    enemigo.ancho = enemigo.sprite:getWidth()
    enemigo.alto = enemigo.sprite:getHeight()
    enemigo.origenX = enemigo.ancho / 2
    enemigo.origenY = enemigo.alto / 2

    -- Variables del Sistema de Depuración y Colisión
    depurar = false
    atrapado = false
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
    end
end

function love.update(dt)
    -- MOVIMIENTO DEL JUGADOR (Top-Down de 4 direcciones excluyentes)
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        jugador.x = jugador.x + jugador.velocidad * dt
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        jugador.x = jugador.x - jugador.velocidad * dt
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        jugador.y = jugador.y + jugador.velocidad * dt
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        jugador.y = jugador.y - jugador.velocidad * dt
    end

    -- INTELIGENCIA ARTIFICIAL DEL ENEMIGO (Persecución / Chasing)
    local distX = math.abs(enemigo.x - jugador.x)
    local distY = math.abs(enemigo.y - jugador.y)

    -- Selección entre persecución horizontal o vertical según la distancia
    if distX > distY then
        if enemigo.x < jugador.x and distX > jugador.ancho then
            enemigo.x = enemigo.x + enemigo.velocidad * dt
        elseif enemigo.x > jugador.x and distX > jugador.ancho then
            enemigo.x = enemigo.x - enemigo.velocidad * dt
        end
    else
        if enemigo.y < jugador.y and distY > jugador.alto then
            enemigo.y = enemigo.y + enemigo.velocidad * dt
        elseif enemigo.y > jugador.y and distY > jugador.alto then
            enemigo.y = enemigo.y - enemigo.velocidad * dt
        end
    end

    -- ACTUALIZACIÓN DE HITBOXES (Ajustados según el punto de origen)
    jugador.hitboxX = jugador.x - jugador.origenX
    jugador.hitboxY = jugador.y - jugador.origenY
    enemigo.hitboxX = enemigo.x - enemigo.origenX
    enemigo.hitboxY = enemigo.y - enemigo.origenY

    -- COMPROBACIÓN DE COLISIÓN
    atrapado = comprobarColision(
        jugador.hitboxX, jugador.hitboxY, jugador.ancho, jugador.alto,
        enemigo.hitboxX, enemigo.hitboxY, enemigo.ancho, enemigo.alto
    )
end

function love.draw()
    -- Renderizado dentro del Canvas (Lienzo del escenario escalado)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    -- Dibujar Jugador
    love.graphics.draw(
        jugador.sprite,
        redondear(jugador.x),
        redondear(jugador.y),
        0, 1, 1,
        jugador.origenX,
        jugador.origenY
    )

    -- Dibujar Enemigo
    love.graphics.draw(
        enemigo.sprite,
        redondear(enemigo.x),
        redondear(enemigo.y),
        0, 1, 1,
        enemigo.origenX,
        enemigo.origenY
    )

    -- MODO DEBUG / DEPURACIÓN (Hitboxes y puntos de origen)
    if depurar then
        love.graphics.setColor(0, 1, 0) -- Verde para depuración

        -- Hitboxes
        love.graphics.rectangle("line", jugador.hitboxX, jugador.hitboxY, jugador.ancho, jugador.alto)
        love.graphics.rectangle("line", enemigo.hitboxX, enemigo.hitboxY, enemigo.ancho, enemigo.alto)

        -- Puntos de origen (centros)
        love.graphics.circle("fill", jugador.x, jugador.y, 1)
        love.graphics.circle("fill", enemigo.x, enemigo.y, 1)

        love.graphics.setColor(1, 1, 1) -- Restaurar color blanco
    end

    love.graphics.setCanvas()

    -- Dibujar Canvas en pantalla con la escala de la ventana
    love.graphics.draw(canvas, 0, 0, 0, ventana.escala, ventana.escala)

    -- UI e Información fuera del Canvas (Resolución real)
    if depurar then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        if atrapado then
            love.graphics.print("ATRAPADO", 10, 30)
        end
        love.graphics.setColor(1, 1, 1)
    end
end