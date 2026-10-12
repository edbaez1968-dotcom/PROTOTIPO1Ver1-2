Enemigo = Class{__includes = Entidad}

function Enemigo:init(x, y, img, v, mundo)
    self.x = x
    self.y = y
    self.sprite = love.graphics.newImage(img)
    self.ancho = self.sprite:getWidth()
    self.alto = self.sprite:getHeight()
    self.origenX = self.ancho/2
    self.origenY = self.alto/2
    self.hitbox_x = self.x- self.origenX
    self.hitbox_y = self.y- self.origenY
    self.velocidad = v
    self.inicial_x = x
    self.inicial_y = y
    self.mundo = mundo
    self.es_enemigo = true
    self.mundo:add(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)

    
end
function Enemigo:Actualizar(jugador, dt)
    local dx = jugador.x - self.x
    local dy = jugador.y - self.y
    local distancia = math.sqrt(dx * dx + dy * dy)

    if distancia > 0 then

        self.x = self.x + (dx / distancia) * self.velocidad * dt
        self.y = self.y + (dy / distancia) * self.velocidad * dt

    end
    self:ActualizarHitbox()
	if self.mundo then
    self.hitbox_x= self.x - self.origenX
    self.hitbox_y= self.y - self.origenY
    self.mundo:update(
        self,  self.hitbox_x,  self.hitbox_y,  self.ancho,  self.alto )

end


end

return Enemigo