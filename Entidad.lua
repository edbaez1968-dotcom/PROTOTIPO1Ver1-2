Entidad = Class{}

function Entidad:init(x, y, img, velocidad, mundo)

    self.sprite = love.graphics.newImage(img)

    self.x = x
    self.y = y

    self.inicial_x = x
    self.inicial_y = y

    self.ancho = self.sprite:getWidth()
    self.alto = self.sprite:getHeight()

    self.origenX = self.ancho / 2
    self.origenY = self.alto / 2

    self.hitbox_x = 0
    self.hitbox_y = 0

    self.velocidad = velocidad or 0

    self.mundo = mundo
	self:ActualizarHitbox()

	
    if self.mundo then
        self.mundo:add(
            self,
            self.hitbox_x,
            self.hitbox_y,
            self.ancho,
            self.alto
        )
    end
end

function Entidad:ActualizarHitbox()

    self.hitbox_x = self.x - self.origenX
    self.hitbox_y = self.y - self.origenY

end

function Entidad:Dibujar()

    love.graphics.draw(
        self.sprite,
        redondear(self.x),
        redondear(self.y),
        0,
        1,
        1,
        self.origenX,
        self.origenY
    )

end
function Entidad:Colisiona(otro)

    return self.hitbox_x < otro.hitbox_x + otro.ancho and
           otro.hitbox_x < self.hitbox_x + self.ancho and
           self.hitbox_y < otro.hitbox_y + otro.alto and
           otro.hitbox_y < self.hitbox_y + self.alto

end

return Entidad