Enemigo = Class{__includes = Entidad}

function Enemigo:init(x, y, img, velocidad, mundo)

    Entidad.init(
        self,
        x,
        y,
        img,
        velocidad,
        mundo
    )

    self.es_enemigo = true

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

    self.mundo:update(
        self,
        self.hitbox_x,
        self.hitbox_y,
        self.ancho,
        self.alto
    )

end

end

return Enemigo