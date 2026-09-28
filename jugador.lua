-- Jugador.lua
-- Class =require 'class'
-- Jugador = {}
-- Jugador.__index = Jugador
Jugador = Class{}
-- Constructor function to create a nuevo 
function Jugador:init(x, y, v,mundo)
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
	self.vidas=5
    self.objetivo= 10
    self.derrotados=0
    self.mundo = mundo
    self.mundo:add(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    self.anterior_x= self.x
    self.anterior_y= self.y
	
    -- return self
end

-- 
function Jugador:Actualizar(dt)
     self.anterior_x= self.x
    self.anterior_y= self.y
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
     self.mundo:update(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
end

function Jugador:Colision(otro_hitbox_x, otro_hitbox_y, otro_ancho, otro_alto)
    --[[
    return self.hitbox_x < otro_hitbox_x + otro_ancho and
           otro_hitbox_x < self.hitbox_x + self.ancho and
           self.hitbox_y < otro_hitbox_y + otro_alto and
           otro_hitbox_y < self.hitbox_y + self.alto
    ]]
    local hitboxes, cantidad = self.mundo:queryRect(self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    for i = 1, cantidad do
        local objeto = hitboxes[i]
        if objeto ~= self then
            if  objeto.es_enemigo then
                return true
            elseif objeto.es_pared then
                  self.x=self.anterior_x
                  self.y=self.anterior_y
                    self.hitbox_x = self.x - self.origenX
                    self.hitbox_y = self.y - self.origenY
                    self.mundo:update(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
            end
            
        end
    end
    return false
end

-- Draw the enemy on the screen  jugador.correr.quads[i],
function Jugador:Dibujar()
    love.graphics.draw(self.sprite ,redondear(self.x),redondear(self.y),0,1,1,self.origenX+3,self.origenY+3) 
    camara_principal:lookAt(redondear(self.x), redondear(self.y))
end

return Jugador
