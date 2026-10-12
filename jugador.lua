Class = require 'lib.class'
Jugador = Class{}

-- =================== INICIALIZACION ===================
function Jugador:init(x, y, v, mundo)
    self.sprite = love.graphics.newImage("img/Duende.png")
    self.ancho = self.sprite:getWidth()
    self.alto  = self.sprite:getHeight()
    
    -- CORRECCIÓN CLAVE: x, y son la esquina superior izquierda de la hitbox
    self.x = x
    self.y = y

    self.origen_x = self.ancho/2
    self.origen_y = self.alto/2
    self.hitbox_x =  self.x - self.origen_x
    self.hitbox_y =  self.y - self.origen_y

    self.velocidad = v * 2
    self.vidas = 5
    self.objetivo = 2
    self.derrotados = 0
    self.mundo = mundo
    
    -- Agregamos al mundo usando x, y directamente (top-left)
    self.mundo:add(self, self.x, self.y, self.ancho, self.alto)
    
    self.inmune = false
    self.tiempoInmune = 1
end

-- =================== ACTUALIZAR ===================
function Jugador:Actualizar(dt)
    -- 1. Calcular cuánto queremos movernos (dx, dy)
    local dx, dy = 0, 0
    if love.keyboard.isDown("right") then dx =  self.velocidad * dt end
    if love.keyboard.isDown("left")  then dx = -self.velocidad * dt end
    if love.keyboard.isDown("down")  then dy =  self.velocidad * dt end
    if love.keyboard.isDown("up")    then dy = -self.velocidad * dt end

    -- 2. LA MAGIA DE BUMP: move() calcula la trayectoria y detiene al jugador si hay una pared
    local actualX, actualY, cols, len = self.mundo:move(self, self.x + dx, self.y + dy)
    
    -- 3. Actualizamos las coordenadas del jugador a la posición segura calculada por Bump
    self.x = actualX
    self.y = actualY

    -- 4. Límites del mapa (Corregido: mapa.tilewidth en lugar de tiewidth)
    local anchoMapa = mapa.width * mapa.tilewidth
    local altoMapa  = mapa.height * mapa.tileheight
    
    if self.x < 0 then self.x = 0 end
    if self.y < 0 then self.y = 0 end
    if self.x > (anchoMapa - self.ancho) then self.x = anchoMapa - self.ancho end
    if self.y > (altoMapa - self.alto)   then self.y = altoMapa - self.alto end
    
    -- Si los límites del mapa forzaron un cambio, sincronizamos con Bump
    self.mundo:update(self, self.x, self.y, self.ancho, self.alto)

    -- 5. Procesar colisiones detectadas durante el movimiento (Opcional, para efectos)
    for i = 1, len do
        local col = cols[i]
        if col.other.es_pared then
            -- El jugador chocó con una pared. Bump ya lo detuvo, 
            -- pero aquí podrías reproducir un sonido de "golpe" si quisieras.
        end
    end
  -- ¡IMPORTANTE! Recalcular hitbox DESPUÉS de los límites
    self.hitbox_x = self.x -- self.origen_x
    self.hitbox_y = self.y -- self.origen_y
    self.mundo:update(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    -- 6. Lógica de inmunidad
    if self.inmune then
        self.tiempoInmune = self.tiempoInmune - dt
        if self.tiempoInmune <= 0 then
            self.inmune = false
        end
    end
end

-- =================== RENDERIZADO ===================
function Jugador:Dibujar()
    -- Al ser x, y la esquina superior izquierda, no necesitamos origen_x/origen_y aquí
    love.graphics.draw(
        self.sprite, 
        redondear(self.x), 
        redondear(self.y)
    )
end

-- =================== COLISIONES DE LÓGICA DE JUEGO ===================
-- Esta función se usa para monedas y enemigos (no para paredes, eso lo hace Bump automáticamente)
function Jugador:ColisionCon(objetivo)
    return (
        self.x < objetivo.x + objetivo.ancho and
        self.x + self.ancho > objetivo.x and
        self.y < objetivo.y + objetivo.alto and
        self.y + self.alto > objetivo.y
    )
end

return Jugador