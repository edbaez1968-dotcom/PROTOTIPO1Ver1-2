EstadoVictoria = Class{  __includes = Estado}

function EstadoVictoria:init()

end

function EstadoVictoria:actualizar(dt)

end

function EstadoVictoria:dibujar()

    love.graphics.printf(
        "¡HAS GANADO!",
        0,
        100,
        love.graphics.getWidth(),
        "center"
    )

end