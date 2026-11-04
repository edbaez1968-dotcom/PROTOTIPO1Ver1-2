EstadoJugar = Class { __includes = Estado }

function EstadoJugar:init()
    self.monedas = {}

    love.graphics.setColor(1,1,1)
-- Reiniciar condiciones de estado de juego
   
    self.derrota = false
    self.victoria = false
    ------------------------------------------------
    -- Jugador
    ------------------------------------------------
    ----- Por ejemplo, velocidad = 80 o 100 píxeles por segundo
    self.jugador = Jugador(ventana.ancho / 2, ventana.alto / 2, 70, mundo)
    self.UI =    UI(self.jugador)
-- Prueba posicionarlo en coordenadas seguras del mapa (ej. x = 40, y = 40)
-- self.jugador = Jugador(40, 40, 70, mundo)
    ------------------------------------------------
    -- Enemigo
    ------------------------------------------------
    self.enemigo = Enemigo(
        30,
        30,
        "img/Ogro16x16.png",
        10,
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
self.juegoActivo = false
self.textoInicio = ""
end

function EstadoJugar:ingresar()
end
function EstadoJugar:entrar()

    self.juegoActivo = false

    self:IniciarSpawner()

    self:CuentaRegresiva()

end
function EstadoJugar:salir()
end

function EstadoJugar:actualizar(dt)
-- print( "juegoActivo = ", self.juegoActivo)
    atrapado = false
    for _, moneda in ipairs(self.monedas) do

            moneda:Actualizar(dt)

    end

    if derrota or victoria then
        return
    end
    
    ------------------------------------------------
    -- Actualización de entidades
    ------------------------------------------------
    

    self.jugador:Actualizar(dt)

    self.enemigo:Actualizar( self.jugador,   dt )

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
    -- atrapado = self.jugador:Colision()
    if atrapado and not self.jugador.inmune  then
        print("Me atrapo Enemigo",10,60)
        love.audio.stop(Sfx_hit)
        love.audio.play(Sfx_hit)
        self.jugador.color={1,0,0,0.8}
        if self.jugador.vidas>0 then      
            Timer.after(2,function()  self.jugador.color={1,1,1,1} end)
            EventManager:notificar( "JUGADOR_DANADO",  { jugador = self.jugador, enemigo = self.enemigo, dano = 1 })
            self.enemigo.x = self.enemigo.inicial_x +   math.random(30,110)
            self.enemigo.y =self.enemigo.inicial_y +   math.random(50,120)
        end
        
    self.enemigo:ActualizarHitbox()
       

        if ataque.activado then
            love.audio.stop(Sfx_hit)

            self.jugador.derrotados =   self.jugador.derrotados + 1

        else
            love.audio.play(Sfx_hit)

        end

    end

    ------------------------------------------------
    -- Colisión moneda
    ------------------------------------------------
local tocaMoneda =    self.jugador:ColisionCon(   self.moneda    )
if tocaMoneda then
    EventManager:notificar(
        "MONEDA_RECOGIDA",
        {
            jugador = self.jugador,
            moneda = self.moneda
        }
    )

    self.moneda:Reubicar()
    if self.jugador.derrotados >= self.jugador.objetivo
        then
            victoria = true
            love.audio.stop(musica)
            love.audio.play(svitoria)
            MaquinaEstadoGlobal:cambiar(
            'titulo',
            {
                titulo = "GANADOOOOOR ! ! !",
                subtitulo = "Atrapo las Monedas",
                copyR = "Presione X"
            }
        )

        end

end


end

function EstadoJugar:dibujar()

    love.graphics.setCanvas(canvas)

    -- love.graphics.clear()
    love.graphics.clear(
    0.20,
    0.50,
    0.20,
    1
)
if self.textoInicio ~= "" then
    love.graphics.printf(
        self.textoInicio,
        0,
        ventana.alto / 2,
        ventana.ancho,
        "center"
    )

end
    camara_principal:attach(0, 0, ventana.ancho,  ventana.alto)
    mapa:drawLayer(mapa.layers["piso"]    )
    
    -- mapa:drawLayer( mapa.layers["Colisiones"]    )
    mapa:drawLayer( mapa.layers["Deco"]    )
    

    ------------------------------------------------
    -- Escenario
    ------------------------------------------------
if depurar then
    -- love.graphics.setFont(miFuentePequena)
    -- love.graphics.print("Jugador: x=" .. math.floor(self.jugador.x) .. ", y=" .. math.floor(self.jugador.y), self.jugador.x +10,self.jugador.y + 10)
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

        love.graphics.setColor(0,0.8,0)

        love.graphics.rectangle(
            "line",
            redondear(self.jugador.hitbox_x),
            redondear(self.jugador.hitbox_y),
            self.jugador.ancho,
            self.jugador.alto
        )

        love.graphics.rectangle(
        "line",
        redondear(self.enemigo.hitbox_x),
        redondear(self.enemigo.hitbox_y),
        self.enemigo.ancho,
        self.enemigo.alto  
        )

        love.graphics.setColor(1,1,1)
        -- love.graphics.setFont(miFuentePequena)
        love.graphics.print("x=" .. math.floor(self.jugador.x) .. ", y=" .. math.floor(self.jugador.y), self.jugador.x +8,self.jugador.y + 8)
    
        
    --[[]]
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
    self.UI:Dibujar()
    if victoria then

        love.graphics.print(
            "GANADOR",
            10,
            40
        )

    end

    if depurar then

        love.graphics.print(     "FPS: " ..    love.timer.getFPS(),    10,      45      )
        for _, obj in ipairs(mapa.layers["Colisiones"].objects) do
            -- love.graphics.setColor(1,0,0)

            love.graphics.rectangle( "line",   obj.x,   obj.y,  obj.width,  obj.height   )
        end

    end
    for _, moneda in ipairs(self.monedas) do
        moneda:Dibujar()
    end


end

------------------------------------------------
-- CORRUTINA  SPAWNER DE MONEDAS
------------------------------------------------

function EstadoJugar:IniciarSpawner()

    local co = coroutine.create(

        function()

            while true do

                local tiempo = 0

                while tiempo < 10 do

                    local dt =  coroutine.yield()

                    tiempo =   tiempo + dt

                end

                print(
                    "Nueva moneda"
                )

                local nuevaMoneda =   Moneda(
                    math.random(64,1500),
                    math.random(64,900),
                     "img/MonedaOro16x16.png")

                table.insert(
                    self.monedas,  nuevaMoneda
                )

            end

        end
    )

    CoroutineManager:Agregar(co)

end
function EstadoJugar:CuentaRegresiva()

    local co = coroutine.create(function()

        local tiempo = 0

        self.textoInicio = "3"

        while tiempo < 1 do
            tiempo = tiempo +
                coroutine.yield()
        end

        tiempo = 0
        self.textoInicio = "2"

        while tiempo < 1 do
            tiempo = tiempo +
                coroutine.yield()
        end

        tiempo = 0
        self.textoInicio = "1"

        while tiempo < 1 do
            tiempo = tiempo +
                coroutine.yield()
        end

        self.textoInicio = "GO!"

        tiempo = 0

        while tiempo < 1 do
            tiempo = tiempo +
                coroutine.yield()
        end

        self.textoInicio = ""

        self.juegoActivo = true

    end)

    CoroutineManager:Agregar(co)

end

function EstadoJugar:CinematicaVictoria()

    local co = coroutine.create(

        function()

            self.jugador.bloqueado =
                true

            self.textoVictoria =
                "¡VICTORIA!"

            local tiempo = 0

            while tiempo < 3 do

                local dt =
                    coroutine.yield()

                tiempo =
                    tiempo + dt

            end

            MaquinaEstadoGlobal:
                cambiar(
                    "victoria"
                )

        end
    )

    CoroutineManager:Agregar(co)

end
return EstadoJugar