-- enemigo.lua
-- Class =require 'class'
Enemigo = Class{}
-- Constructor function to create a nuevo 
function Enemigo:init(x, y,img, v, mundo)
    -- local self = setmetatable({}, Enemigo)
	self.sprite= love.graphics.newImage(img)
	--self.sprite= love.graphics.newImage("img/Ogro16x16.png")
    self.x = x
	self.y = y
	self.inicial_x = 120
    self.inicial_y = 120
	--self.sprite = love.graphics.newImage()
	self.ancho = self.sprite:getWidth()
	self.alto = self.sprite:getHeight()
	self.origenX = self.ancho/2
	self.origenY = self.alto/2
	self.hitbox_x = 0
	self.hitbox_y = 0
	self.velocidad = v
    self.mundo = mundo
    self.mundo:add(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    -- return self
end

function Enemigo:Actualizar(jugadorX, jugadorY, jugadorAncho, jugadorAlto, dt)
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

function Enemigo:Dibujar()
    love.graphics.draw(
        self.sprite,
        redondear(self.x),
        redondear(self.y),
        0, 1, 1,
        self.origenX,
        self.origenY
    )
end

return Enemigo
