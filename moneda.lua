-- Moneda.lua
-- Class =require 'class'
Moneda = Class{}
-- Constructor function to create a nuevo 
function Moneda:init(x, y,img, v)
    -- local self = setmetatable({}, Moneda)
	self.sprite= love.graphics.newImage(img)
	--self.sprite= love.graphics.newImage("img/MonedaOro16x16.png")
    self.x = x
	self.y = y
	self.inicial_x = 10+ math.random(1, 80)
    self.inicial_y = 30+ math.random(1, 100)
	--self.sprite = love.graphics.newImage()
	self.ancho = self.sprite:getWidth()
	self.alto = self.sprite:getHeight()
	self.origenX = self.ancho/2
	self.origenY = self.alto/2
	self.hitbox_x = 0
	self.hitbox_y = 0
	self.velocidad = v
    -- return self
end

function Moneda:Actualizar(jugadorX, jugadorY, jugadorAncho, jugadorAlto, dt)
    -- Persecución simple hacia el jugador
    local distX = math.abs(self.x - jugadorX)
    local distY = math.abs(self.y - jugadorY)

    if distX > distY then
        if self.x < jugadorX and distX > jugadorAncho then
            self.x = self.x + self.velocidad * dt
        elseif self.x > jugadorX and distX > jugadorAncho then
            self.x = self.x - self.velocidad * dt
        end
    else
        if self.y < jugadorY and distY > jugadorAlto then
            self.y = self.y + self.velocidad * dt
        elseif self.y > jugadorY and distY > jugadorAlto then
            self.y = self.y - self.velocidad * dt
        end
    end

    -- Actualizar hitboxes
    self.hitbox_x = self.x - self.origenX
    self.hitbox_y = self.y - self.origenY
end

function Moneda:Dibujar()
    love.graphics.draw(
        self.sprite,
        redondear(self.x),
        redondear(self.y),
        0, 1, 1,
        self.origenX,
        self.origenY
    )
end

return Moneda
