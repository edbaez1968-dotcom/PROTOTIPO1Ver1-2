EstadoJugar = Class { __includes = Estado }

function EstadoJugar:init()
     love.graphics.setColor(1, 1, 1)
    -- 2. Creación del Jugador 
    self.jugador = Jugador(ventana.ancho / 2, ventana.alto / 2, 70)

    -- Sonidos
    musica = love.audio.newSource("sounds/musica.ogg", "stream")
    musica:setLooping(true)
    musica:setVolume(0.60)
    love.audio.play(musica)

    Sfx_ataque = love.audio.newSource("sounds/espada.wav", "static")
    Sfx_hit = love.audio.newSource("sounds/colision.wav", "static")
    svitoria = love.audio.newSource("sounds/victoria.wav", "static")
    clink = love.audio.newSource("sounds/moneda_oro.wav", "static")

    -- Creación de animaciones
    aura = CrearAnimacion("img/EnemigoGiro.png", 3, 16, 16, 12, false)
    aura.activado = false -- Desactivada por defecto

    ataque = CrearAnimacion("img/Giro2.png", 3, 16, 16, 12, false)
    ataque.activado = false

    -- 3. Creación del Enemigo
    enemigo = Enemigo(30, 30, "img/Ogro16x16.png", 30)
   -- 3. Creación del Enemigo
    moneda = Moneda(100, 60, "img/MonedaOro16x16.png", 10)

end
function EstadoJugar:ingresar() end
function EstadoJugar:salir() end
function EstadoJugar:actualizar(dt)
    atrapado = false

    -- Detener actualización si se ganó o perdió
    if derrota or victoria then
        love.graphics.print(" El juego finalizó  Vidas: " .. self.jugador.vidas.. "  Puntos: " ..self.jugador.derrotados, 5, 10)
        return
    end

    
    self.jugador:Actualizar(dt)

    -- Actualizar movimiento e hitboxes del enemigo y de la moneda
    enemigo:Actualizar(self.jugador.x, self.jugador.y, self.jugador.ancho, self.jugador.alto, dt)
    moneda:Actualizar(self.jugador.x, self.jugador.y, self.jugador.ancho, self.jugador.alto, dt)

    -- Actualizar animación de ataque
    if ataque.activado then
        ataque.indice = ataque.indice + (10 * dt)
        if ataque.indice >= #ataque.quads + 1 then
            ataque.indice = 1
            ataque.activado = false
        end   
    end

    -- Actualizar animación de aura
    if aura.activado then
        aura.indice = aura.indice + (7 * dt)
        if aura.indice >= #aura.quads + 1 then
            aura.indice = 1
            aura.activado = false
        end   
    end

    -- ================= COLISIÓN CON EL ENEMIGO =================
    atrapado = comprobarColision(
        self.jugador.hitbox_x, self.jugador.hitbox_y, self.jugador.ancho, self.jugador.alto,
        enemigo.hitbox_x, enemigo.hitbox_y, enemigo.ancho, enemigo.alto
    )

    if atrapado then
       if self.jugador.vidas <= 0 then
        MaquinaEstadoGlobal:cambiar('derrota')
      end
        enemigo.x = enemigo.inicial_x + math.random(1, 60)
        enemigo.y = enemigo.inicial_y + math.random(1, 80)

        if ataque.activado then
            love.audio.stop(Sfx_hit)
            self.jugador.derrotados = self.jugador.derrotados + 1
            if self.jugador.derrotados >= self.jugador.objetivo then
                victoria = true
                love.graphics.print("Vidas " .. self.jugador.vidas.." Ganador!!", 5, 10)
                love.audio.stop(musica) 
                love.audio.play(svitoria)
            end
        else
            love.audio.play(Sfx_hit)
            self.jugador.vidas = self.jugador.vidas - 1
            if self.jugador.vidas <= 0 then
                MaquinaEstadoGlobal:cambiar('derrota')
                love.graphics.print("Vidas " .. self.jugador.vidas.."  Perdió :-) ", 5, 10)
                -- derrota = true
                love.audio.stop(musica)
                
            end
        end
    end

    -- ================= COLISIÓN CON LA MONEDA =================
    local colisionMoneda = comprobarColision(
        self.jugador.hitbox_x, self.jugador.hitbox_y, self.jugador.ancho, self.jugador.alto,
        moneda.hitbox_x, moneda.hitbox_y, moneda.ancho, moneda.alto
    )

    if colisionMoneda then
        -- Reproducir sonido de moneda
        love.audio.stop(clink)
        love.audio.play(clink)

        -- Aumentar el contador de objetivos en 2
        self.jugador.derrotados = self.jugador.derrotados + 2

        -- Reubicar la moneda en una posición aleatoria
        moneda.x = 10 + math.random(1, 130)
        moneda.y = 20 + math.random(1, 140)

        -- Verificar si se completó el objetivo del juego
        if self.jugador.derrotados >= self.jugador.objetivo then
            victoria = true
            love.graphics.print("Vidas " .. self.jugador.vidas.." Ganador!!", 5, 10)
            love.audio.stop(musica)
            love.audio.play(svitoria)
        end
    end
 
   

end  -- de actualizar
function EstadoJugar:dibujar()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    -- 1. Escenario
    DibujarEscenario()

    -- 2. Dibujar Jugador
    self.jugador:Dibujar()
    
    if ataque.activado then
        local i = math.floor(ataque.indice)
        love.graphics.draw(ataque.spritesheet, ataque.quads[i], self.jugador.x, self.jugador.y, 0, 1, 1, self.jugador.origenX + 3, self.jugador.origenY + 3)  
    end

    -- 3. Dibujar Enemigo y su Aura
    enemigo:Dibujar()
    
    if aura.activado then
        local i = math.floor(aura.indice)
        love.graphics.draw(aura.spritesheet, aura.quads[i], enemigo.x, enemigo.y, 0, 1, 1, enemigo.origenX + 3, enemigo.origenY + 3)  
    end
    -- 4. Dibujar moneda
    moneda:Dibujar()
    -- UI
    love.graphics.setFont(miFuentePequena)  -- 
    if not derrota then
        love.graphics.print("Vidas " .. self.jugador.vidas, 5, 10) -- 
    end
    if not victoria then
        love.graphics.print("Objetivo " .. self.jugador.derrotados .. "/" .. self.jugador.objetivo, 5, 20) -- 
    end

    -- MODO DEBUG / DEPURACIÓN (Hitboxes y puntos de origen)
    if depurar then
        love.graphics.setColor(0, 1, 0) -- Verde para depuración

        -- Hitboxes del Jugador y Enemigo
        love.graphics.rectangle("line", self.jugador.hitbox_x, self.jugador.hitbox_y, self.jugador.ancho, self.jugador.alto)
        love.graphics.rectangle("line", enemigo.hitbox_x, enemigo.hitbox_y, enemigo.ancho, enemigo.alto)

        -- Puntos de origen (centros)
        love.graphics.circle("fill", self.jugador.x, self.jugador.y, 1)
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
end  -- de dibujar