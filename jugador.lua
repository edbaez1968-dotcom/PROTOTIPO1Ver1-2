-- Jugador.lua
-- Class =require 'class'
-- Jugador = {}
-- Jugador.__index = Jugador
Jugador = Class{}
-- Constructor function to create a nuevo 
function Jugador:init(x, y, v)
    -- local self = setmetatable({}, Jugador)
	self.sprite= love.graphics.newImage("img/Duende.png")
	self.x = x
	self.y = y
	self.inicial_x = 120
    self.inicial_y = 50
	self.ancho = self.sprite:getWidth()
	self.alto = self.sprite:getHeight()
	self.origenX = self.ancho/2
	self.origenY = self.alto/2
	self.hitbox_x = 0
	self.hitbox_y = 0
	self.velocidad = v
	self.vidas=2
    self.objetivo= 5
    self.derrotados=0
	
    -- return self
end

-- 
function Jugador:Actualizar(dt)
    if love.keyboard.isDown("right") then
        self.x = self.x + (self.velocidad * dt)
    elseif love.keyboard.isDown("left") then
        self.x = self.x - (self.velocidad * dt)
    elseif love.keyboard.isDown("down") then
        self.y = self.y + (self.velocidad * dt)
    elseif love.keyboard.isDown("up") then
        self.y = self.y - (self.velocidad * dt)
    end

    self.hitbox_x = self.x - self.origenX
    self.hitbox_y = self.y - self.origenY
end

-- Draw the enemy on the screen  jugador.correr.quads[i],
function Jugador:Dibujar()
    love.graphics.draw(self.sprite ,redondear(self.x),redondear(self.y),0,1,1,self.origenX+3,self.origenY+3) 
end

return Jugador
