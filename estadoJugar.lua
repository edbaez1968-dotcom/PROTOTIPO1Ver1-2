EstadoJugar = Class { __includes = Estado }

function EstadoJugar:init()

    love.graphics.setColor(1,1,1)
-- Reiniciar condiciones de estado de juego
    derrota = false
    victoria = false

    ------------------------------------------------
    -- Jugador
    ------------------------------------------------
    ----- Por ejemplo, velocidad = 80 o 100 píxeles por segundo
self.jugador = Jugador(ventana.ancho / 2, ventana.alto / 2, 70, mundo)

    ------------------------------------------------
    -- Enemigo
    ------------------------------------------------
    self.enemigo = Enemigo(
        30,
        30,
        "img/Ogro16x16.png",
        30,
        mundo
    )

    ------------------------------------------------
    -- Moneda
    ------------------------------------------------
    self.moneda = Moneda(
        100,
        60,
        "img/MonedaOro16x16.png"
    )

    ------------------------------------------------
    -- Sonidos
    ------------------------------------------------
    musica = love.audio.newSource(
        "sounds/musica.ogg",
        "stream"
    )

    musica:setLooping(true)
    musica:setVolume(0.60)
    love.audio.play(musica)

    Sfx_ataque = love.audio.newSource(
        "sounds/espada.wav",
        "static"
    )

    Sfx_hit = love.audio.newSource(
        "sounds/colision.wav",
        "static"
    )

    svitoria = love.audio.newSource(
        "sounds/victoria.wav",
        "static"
    )

    clink = love.audio.newSource(
        "sounds/moneda_oro.wav",
        "static"
    )

    ------------------------------------------------
    -- Animaciones
    ------------------------------------------------
    aura = CrearAnimacion(
        "img/EnemigoGiro.png",
        3,
        16,
        16,
        12,
        false
    )

    aura.activado = false

    ataque = CrearAnimacion(
        "img/Giro2.png",
        3,
        16,
        16,
        12,
        false
    )

    ataque.activado = false

end

function EstadoJugar:ingresar()
end

function EstadoJugar:salir()
end

function EstadoJugar:actualizar(dt)

    atrapado = false

    if derrota or victoria then
        return
    end

    ------------------------------------------------
    -- Actualización de entidades
    ------------------------------------------------

    self.jugador:Actualizar(dt)

    self.enemigo:Actualizar(
        self.jugador,
        dt
    )

    self.moneda:Actualizar(dt)
camara_principal:lookAt(redondear(self.jugador.x), redondear(self.jugador.y))
    ------------------------------------------------
    -- Animación ataque
    ------------------------------------------------

    if ataque.activado then

        ataque.indice =
            ataque.indice + (10 * dt)

        if ataque.indice >= #ataque.quads + 1 then
            ataque.indice = 1
            ataque.activado = false
        end

    end

    ------------------------------------------------
    -- Animación aura
    ------------------------------------------------

    if aura.activado then

        aura.indice =
            aura.indice + (7 * dt)

        if aura.indice >= #aura.quads + 1 then
            aura.indice = 1
            aura.activado = false
        end

    end

    ------------------------------------------------
    -- Colisión enemigo
    ------------------------------------------------

    atrapado = self.jugador:ColisionCon(self.enemigo)

    if atrapado then

        self.enemigo.x =
            self.enemigo.inicial_x +
            math.random(1,60)

        self.enemigo.y =
            self.enemigo.inicial_y +
            math.random(1,80)

        self.enemigo:ActualizarHitbox()

        if ataque.activado then

            love.audio.stop(Sfx_hit)

            self.jugador.derrotados =
                self.jugador.derrotados + 1

            if self.jugador.derrotados >=
               self.jugador.objetivo
            then

                victoria = true

                love.audio.stop(musica)
                love.audio.play(svitoria)

            end

        else

            love.audio.play(Sfx_hit)

            self.jugador.vidas =
                self.jugador.vidas - 1

            if self.jugador.vidas <= 0 then

                love.audio.stop(musica)

                MaquinaEstadoGlobal:cambiar(
                    "derrota"
                )

            end

        end

    end

    ------------------------------------------------
    -- Colisión moneda
    ------------------------------------------------

    local colisionMoneda =
        self.jugador:ColisionCon( self.moneda )

    if colisionMoneda then

        love.audio.stop(clink)
        love.audio.play(clink)

        self.jugador.derrotados =
            self.jugador.derrotados + 2

        self.moneda:Reubicar()

        if self.jugador.derrotados >=
           self.jugador.objetivo
        then

            victoria = true

            love.audio.stop(musica)
            love.audio.play(svitoria)

        end

    end

end

function EstadoJugar:dibujar()

    love.graphics.setCanvas(canvas)

    love.graphics.clear()

    mapa:drawLayer(
        mapa.layers["piso"]
    )
    mapa:drawLayer( mapa.layers["Deco"]    )
    mapa:drawLayer( mapa.layers["Colisiones"]    )
    camara_principal:attach(
        0,
        0,
        ventana.ancho,
        ventana.alto
    )

    ------------------------------------------------
    -- Escenario
    ------------------------------------------------
if depurar then
    love.graphics.print("Jugador: x=" .. math.floor(self.jugador.x) .. ", y=" .. math.floor(self.jugador.y), 10, 70)
end

    -- DibujarEscenario()

    ------------------------------------------------
    -- Entidades
    ------------------------------------------------

    self.jugador:Dibujar()
    self.enemigo:Dibujar()
    self.moneda:Dibujar()

    ------------------------------------------------
    -- Ataque
    ------------------------------------------------

    if ataque.activado then

        local i =
            math.floor(
                ataque.indice
            )

        love.graphics.draw(
            ataque.spritesheet,
            ataque.quads[i],
            self.jugador.x,
            self.jugador.y,
            0,
            1,
            1,
            self.jugador.origenX,
            self.jugador.origenY
        )

    end

    ------------------------------------------------
    -- Aura
    ------------------------------------------------

    if aura.activado then

        local i =
            math.floor(
                aura.indice
            )

        love.graphics.draw(
            aura.spritesheet,
            aura.quads[i],
            self.enemigo.x,
            self.enemigo.y,
            0,
            1,
            1,
            self.enemigo.origenX,
            self.enemigo.origenY
        )

    end

    ------------------------------------------------
    -- Debug
    ------------------------------------------------

    if depurar then

        love.graphics.setColor(0,1,0)

        love.graphics.rectangle(
            "line",
            self.jugador.hitbox_x,
            self.jugador.hitbox_y,
            self.jugador.ancho,
            self.jugador.alto
        )

        love.graphics.rectangle(
            "line",
            self.enemigo.hitbox_x,
            self.enemigo.hitbox_y,
            self.enemigo.ancho,
            self.enemigo.alto
        )

        love.graphics.setColor(1,1,1)

    end

    ------------------------------------------------
    -- Finalizar cámara
    ------------------------------------------------

    camara_principal:detach()

    ------------------------------------------------
    -- Finalizar canvas
    ------------------------------------------------

    love.graphics.setCanvas()

    love.graphics.draw(
        canvas,
        0,
        0,
        0,
        ventana.escala,
        ventana.escala
    )

    ------------------------------------------------
    -- Interfaz
    ------------------------------------------------

    love.graphics.setFont(
        miFuentePequena
    )

    love.graphics.print(
        "Vidas: " ..
        self.jugador.vidas,
        10,
        10
    )

    love.graphics.print(
        "Objetivo: " ..
        self.jugador.derrotados ..
        "/" ..
        self.jugador.objetivo,
        10,
        25
    )

    if victoria then

        love.graphics.print(
            "GANADOR",
            10,
            40
        )

    end

    if depurar then

        love.graphics.print(
            "FPS: " ..
            love.timer.getFPS(),
            10,
            55
        )

    end

end

return EstadoJugar