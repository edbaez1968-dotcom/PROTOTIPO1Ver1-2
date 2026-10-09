Jugador = Class{}

-- Filtro para que el jugador solo choque físicamente con las paredes
local function filtroJugador(item, other)
    if other.es_pared or (type(other) == "table" and other.type == "pared") then
        return "slide"
    end
    return nil -- Ignorar enemigos y monedas para la física de movimiento
end
function Jugador:init(x, y, v, mundo)
    self.sprite = love.graphics.newImage("img/Duende.png")
    self.x = x
    self.y = y
    self.inicial_x = x
    self.inicial_y = y

    self.ancho = self.sprite:getWidth()
    self.alto = self.sprite:getHeight()
    self.origenX = self.ancho / 2
    self.origenY = self.alto / 2

    -- Hitbox correctamente posicionada respecto al centro del jugador
    self.hitbox_x = self.x - self.origenX
    self.hitbox_y = self.y - self.origenY

    self.velocidad = v
    self.vidas = 5
    self.objetivo = 10
    self.derrotados = 0
    self.mundo = mundo

    -- Registrar la hitbox real en Bump desde el primer momento
    if self.mundo then
        self.mundo:add(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    end
end

function Jugador:Actualizar(dt)
    local dx, dy = 0, 0

    -- Teclas de dirección (Flechas y WASD)
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        dx = dx + (self.velocidad * dt)
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        dx = dx - (self.velocidad * dt)
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        dy = dy + (self.velocidad * dt)
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        dy = dy - (self.velocidad * dt)
    end

    -- Si no se toca ninguna tecla, no se procesa movimiento
    if dx == 0 and dy == 0 then
        return
    end

    -- Calcular la nueva posición de la hitbox deseada
    local objetivo_x = self.hitbox_x + dx
    local objetivo_y = self.hitbox_y + dy

    if self.mundo then
        -- Mover la hitbox mediante Bump
        local actual_x, actual_y, colisiones, num = self.mundo:move(
            self,
            objetivo_x,
            objetivo_y,
            filtroJugador
        )

        -- Sincronizar las coordenadas de la hitbox y del sprite
        self.hitbox_x = actual_x
        self.hitbox_y = actual_y
        self.x = actual_x + self.origenX
        self.y = actual_y + self.origenY
    else
        -- Movimiento sin física si el mundo es nil
        self.hitbox_x = objetivo_x
        self.hitbox_y = objetivo_y
        self.x = self.hitbox_x + self.origenX
        self.y = self.hitbox_y + self.origenY
    end


local actual_x, actual_y, colisiones, num = self.mundo:move(
    self,
    objetivo_x,
    objetivo_y,
    filtroJugador
)
-- Sincronizar las coordenadas de la hitbox y del sprite
self.hitbox_x = actual_x
self.hitbox_y = actual_y
self.x = actual_x + self.origenX
self.y = actual_y + self.origenY



end
function Jugador:ColisionCon(objeto)
    if not self.mundo then return false end
    local hitboxes, cantidad = self.mundo:queryRect(
        self.hitbox_x, self.hitbox_y, self.ancho, self.alto
    )
    for i = 1, cantidad do
        if hitboxes[i] == objeto then
            return true
        end
    end
    return false
end

function Jugador:Dibujar()
    love.graphics.draw(
        self.sprite,
        redondear(self.x),
        redondear(self.y),
        0, 1, 1,
        self.origenX,
        self.origenY
    )
end

return Jugador