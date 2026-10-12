Class = require 'lib.class'

Jugador = Class{}
-- =================== INICIALIZACION ===================
function Jugador:init(x, y, v, mundo)
    self.sprite = love.graphics.newImage("img/Duende.png")
    self.x = x
    self.ancho = self.sprite:getWidth()
    self.alto  = self.sprite:getHeight()
    self.origen_x = self.ancho/2
    self.origen_y = self.alto/2
    self.x = x
    self.y = y
    self.hitbox_x =  self.x - self.origen_x
    self.hitbox_y =  self.y - self.origen_y
    self.velocidad = v * 2
    self.anterior_x = self.x
    self.anterior_y = self.y
    self.vidas = 5
    self.objetivo = 2
    self.derrotados = 0
    self.mundo = mundo
    self.mundo:add(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    self.inmune = false
    self.tiempoInmune = 1
end
-- =================== ACTUALIZAR ===================
function Jugador:Actualizar(dt)
local anchoMapa =   mapa.width * mapa.tilewidth
local altoMapa =    mapa.height * mapa.tileheight
    self.anterior_x = self.x
    self.anterior_y = self.y

    if love.keyboard.isDown("right") then
        print("right")
        self.x = self.x + (self.velocidad * dt)
    elseif love.keyboard.isDown("left") then
        self.x = self.x - (self.velocidad * dt)
    elseif love.keyboard.isDown("down") then
        print("down")
        self.y = self.y + (self.velocidad * dt)
    elseif love.keyboard.isDown("up") then
        print("up")
        self.y = self.y - (self.velocidad * dt)
    end

    self.hitbox_x = self.x - self.origen_x
    self.hitbox_y = self.y - self.origen_y
    self.mundo:update(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)

    if self.inmune then
    self.tiempoInmune =  self.tiempoInmune - dt
    end
    if self.tiempoInmune <= 0 then
        self.inmune = false
    end

    -- límite izquierdo
    if self.x < self.origen_x then
    self.x = self.origen_x
    end

    -- límite superior
    if self.y < self.origen_y then
    self.y = self.origen_y
    end

    -- límite derecho
    if self.x > (anchoMapa - self.origen_x) then
    self.x = anchoMapa - self.origen_x
    end

    -- límite inferior
    if self.y > (altoMapa - self.origen_y) then
    self.y = altoMapa - self.origen_y
    end
    --self:ActualizarHitbox()
end
-- =================== Colision ===================
function Jugador:Colision()
    local hitboxes, cantidad = self.mundo:queryRect(self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
    
    for i = 1, cantidad do
        local objeto = hitboxes[i]
        if objeto ~= self then
            if objeto.es_enemigo then
                return true
            elseif objeto.es_pared then
                print("Colision Pared",10,10)
                self.x = self.anterior_x
                self.y = self.anterior_y
                self.hitbox_x = self.x - self.origen_x
                self.hitbox_y = self.y - self.origen_y
                self.mundo:update(self, self.hitbox_x, self.hitbox_y, self.ancho, self.alto)
            end
        end
    end 
    return false
end
-- =================== RENDERIZADO ===================
function Jugador:Dibujar()
    love.graphics.draw(self.sprite,redondear(self.x),redondear(self.y),0,1,1, self.origen_x, self.origen_y)
end
function Jugador:ColisionCon(objetivo)

    return(
        self.hitbox_x < objetivo.hitbox_x + objetivo.ancho and
        self.hitbox_x + self.ancho > objetivo.hitbox_x and
        self.hitbox_y < objetivo.hitbox_y + objetivo.alto and
        self.hitbox_y + self.alto > objetivo.hitbox_y)

end
return Jugador