-- Moneda.lua
Moneda = Class{__includes = Entidad}

function Moneda:init(x, y, img)

    Entidad.init(
        self,
        x,
        y,
        img,
        0,
        nil
    )

    self.recogida = false

end

function Moneda:Actualizar(dt)

    self:ActualizarHitbox()

end

function Moneda:Reubicar()
    self.x = 10 + math.random(1,100)
    self.y = 20 + math.random(1,90)
    self.recogida = false
    self:ActualizarHitbox()

end

function Moneda:Dibujar()

    if not self.recogida then
        Entidad.Dibujar(self)
    end

end


return Moneda
