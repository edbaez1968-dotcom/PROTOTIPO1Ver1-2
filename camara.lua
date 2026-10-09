Camara = Class{}

function Camara:init()
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
end

function Camara:lookAt(x, y)
    self.x = x
    self.y = y
end

function Camara:attach(x, y, w, h)
    self.w = w
    self.h = h
    love.graphics.push()
    love.graphics.translate(w / 2 - self.x, h / 2 - self.y)
end

function Camara:detach()
    love.graphics.pop()
end
  return Camara