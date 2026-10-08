Jugador = Class{__includes = Entidad}

function Jugador:init(x, y, velocidad, mundo)

    Entidad.init(
        self,
        x,
        y,
        "img/Duende.png",
        velocidad,
        mundo
    )

    self.vidas = 5
    self.objetivo = 10
    self.derrotados = 0

    self.anterior_x = x
    self.anterior_y = y
end
function Jugador:Actualizar(dt)

    self.anterior_x = self.x
    self.anterior_y = self.y

    local dx = 0
    local dy = 0

    if love.keyboard.isDown("right") then
        dx = self.velocidad * dt
    end

    if love.keyboard.isDown("left") then
        dx = -self.velocidad * dt
    end

    if love.keyboard.isDown("up") then
        dy = -self.velocidad * dt
    end

    if love.keyboard.isDown("down") then
        dy = self.velocidad * dt
    end

    self.x = self.x + dx
    self.y = self.y + dy

    self:ActualizarHitbox()

    self.mundo:update(
        self,
        self.hitbox_x,
        self.hitbox_y,
        self.ancho,
        self.alto
    )
end
function Jugador:Dibujar()

    Entidad.Dibujar(self)

    camara_principal:lookAt(   redondear(self.x),     redondear(self.y)    )
      -- Lógica de restricción de la cámara dentro de los límites del mapa
    if camara_principal.x < ventana.camara_centro_x then
        camara_principal.x = ventana.camara_centro_x
    end

    if camara_principal.y < ventana.camara_centro_y then
        camara_principal.y = ventana.camara_centro_y
    end

    if camara_principal.x > (ventana.mapa_ancho - ventana.camara_centro_x) then
        camara_principal.x = (ventana.mapa_ancho - ventana.camara_centro_x)
    end

    if camara_principal.y > (ventana.mapa_alto - ventana.camara_centro_y) then
        camara_principal.y = (ventana.mapa_alto - ventana.camara_centro_y)
    end
    
    
end

return Jugador
