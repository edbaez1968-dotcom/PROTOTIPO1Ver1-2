-- Importar el módulo del escenario
require("escenario")
require("animaciones")
 
function love.load()
    
   
    ataque=nil
    aura=nil
    -- estados
    derrota= false
    victoria= false
    -- 1. Configuración del Escenario / Ventana
    ventana = {
        ancho = 160,
        alto = 180,
        escala = 4
    }

    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Inicializar mundo físico para el escenario
    world = love.physics.newWorld(0, 0, true)

    -- Crear las estructuras del escenario (definido en escenario.lua)
    CrearEscenario()

    -- Canvas para escalar todos los elementos manteniendo Pixel Art nítido
    canvas = love.graphics.newCanvas(ventana.ancho, ventana.alto)

    -- 2. Creación del Jugador (Tabla)
    jugador = {
        x = 0,
        y = 0,
        velocidad = 50,
        hitboxX = 0,
        hitboxY = 0,
        correr = nil,
        ancho = 16,
        alto = 16,
        origenX = 8,
        origenY = 8,
        vidas=3,
        objetivo= 2,
        derrotados=0
    }
    -- Sonidos
    musica=nil
    Sfx_ataque=nil
    Sfx_hit=nil
    musica= love.audio.newSource("sounds/musica.ogg","stream")
    musica:setLooping(true)
    musica:setVolume(0.60)
    Sfx_ataque= love.audio.newSource("sounds/espada.wav","static")
    love.audio.play(musica)
    Sfx_hit= love.audio.newSource("sounds/colision.wav","static")
    -- Creación de quads para la animación
    
   
    aura = CrearAnimacion("img/EnemigoGiro.png", 3, 16, 16, 12, false)
    jugador.correr = CrearAnimacion("img/spritesheet.png", 4, 17, 19, 12, true)
    ataque = CrearAnimacion("img/Giro2.png", 3, 16, 16, 12, false)
    -- Para obtener el ancho/alto de un fotograma individual de la animación (16x16):
    jugador.ancho = 16
    jugador.alto = 16
    jugador.origenX = jugador.ancho / 2
    jugador.origenY = jugador.alto / 2
    -- Posicionar al jugador en el centro del escenario
    jugador.x = ventana.ancho / 2
    jugador.y = ventana.alto / 2
    
    
    
    ataque.activado=false
    -- jugador.correr.activado = true
    -- ataque.quad= love.graphics.newQuad(0,0,16,16,ataque.spritesheet)
    -- aura.quad= love.graphics.newQuad(0,0,16,16,aura.spritesheet)
    
    
    
    -- 3. Creación del Enemigo (Tabla)
    enemigo = {
        inicial_x = 20,
        inicial_y = 20,
        x = 20,
        y = 20,
        velocidad = 30,
        hitboxX = 0,
        hitboxY = 0,
        sprite = love.graphics.newImage("img/Ogro16x16.png")
    }
    enemigo.ancho = enemigo.sprite:getWidth()
    enemigo.alto = enemigo.sprite:getHeight()
    enemigo.origenX = enemigo.ancho / 2
    enemigo.origenY = enemigo.alto / 2
    enemigo.x=enemigo.inicial_x+math.random(10,  50)
    enemigo.y=enemigo.inicial_y+math.random(10,  50)

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
    elseif key == "space" and not ataque.activado then
        ataque.activado= true
        love.audio.play(Sfx_ataque)
    end
end

function love.update(dt)
    -- detiene por victoria o derrota
    if derrota or victoria then
        return
    end
    -- Actualizar mundo físico (escenario)
    world:update(dt)

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
    -- Dibujo animación
    if ataque.activado then
     ataque.indice = ataque.indice +(10 * dt)
        if ataque.indice >= #ataque.quads + 1 then
            ataque.indice = 1
            ataque.activado= false
        end   
    end
    -- Dibujo animación enemigo
    if aura.activado then
     aura.indice = aura.indice +(7 * dt)
        if aura.indice >= #aura.quads + 1 then
            aura.indice = 1
            aura.activado= false
        end   
    end
    -- Dibujo animación correr duende
    if jugador.correr.activado then
     jugador.correr.indice = jugador.correr.indice +(7 * dt)
        if jugador.correr.indice >= #jugador.correr.quads + 1 then
            jugador.correr.indice = 1
            -- aura.activado= false
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
    -- Activar aura
    if atrapado then
        aura.activado=false
        -- enemigo.x=enemigo.inicial_x
        -- enemigo.y=enemigo.inicial_y
        enemigo.x=enemigo.inicial_x+math.random(1,  150)
        enemigo.y=enemigo.inicial_y+math.random(1,  100)
        if ataque.activado then
            love.audio.stop(Sfx_hit)
            jugador.derrotados=  jugador.derrotados +1
            if jugador.derrotados== jugador.objetivo then
                victoria=true
                love.audio.stop(musica)
            end
        else
            love.audio.play(Sfx_hit)
            jugador.vidas= jugador.vidas -1
            if jugador.vidas== 0 then
                derrota= true
                love.audio.stop(musica)
                
            end
        end
       else
        aura.activado=true
    end
end

function love.draw()
    -- Renderizado dentro del Canvas (Lienzo del escenario escalado)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    -- 1. Dibujar el Escenario (Estructuras de escenario.lua)
    DibujarEscenario()

    -- 2. Dibujar Jugador
    
    if jugador.correr.activado then
        local i= math.floor(jugador.correr.indice)
        love.graphics.draw(jugador.correr.spritesheet,jugador.correr.quads[i],jugador.x,jugador.y,0,1,1,jugador.origenX+3,jugador.origenY+3)  
    end
    
    if ataque.activado then
        local i =math.floor(ataque.indice)
        love.graphics.draw(ataque.spritesheet,ataque.quads[i],jugador.x,jugador.y,0,1,1,jugador.origenX+3,jugador.origenY+3)  
    end
    if aura.activado then
        local i =math.floor(aura.indice)
        love.graphics.draw(aura.spritesheet,aura.quads[i],enemigo.x,enemigo.y,0,1,1,enemigo.origenX+3,enemigo.origenY+3)  
    end
    if not derrota then
        love.graphics.print("Vidas "..jugador.vidas,5,5)
    end
    if not victoria then
        love.graphics.print("Objetivo "..jugador.derrotados.."/"..jugador.objetivo,50,5)
    end
    -- 3. Dibujar Enemigo
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

        -- Hitboxes del Jugador y Enemigo
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