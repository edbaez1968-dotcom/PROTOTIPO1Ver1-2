-- Libreria Animaciones con Quads

-- Librería de Animaciones con Quads

function CrearAnimacion(
    imagen,
    limite,
    ancho,
    alto,
    velocidad,
    esVertical,
    columna,
    fila
)

    local animacion = {}

    animacion.spritesheet =
        love.graphics.newImage(imagen)

    animacion.indice = 1
    animacion.velocidad = velocidad or 10
    animacion.activado = true

    animacion.quads = {}

    -- Valores por defecto
    columna = columna or ancho
    fila = fila or 0

    local sw = animacion.spritesheet:getWidth()
    local sh = animacion.spritesheet:getHeight()

    if esVertical then

        for i = 0, limite - 1 do

            table.insert(
                animacion.quads,

                love.graphics.newQuad(
                    columna,
                    fila + (alto * i),
                    ancho,
                    alto,
                    sw,
                    sh
                )
            )

        end

    else

        for i = 0, limite - 1 do

            table.insert(
                animacion.quads,

                love.graphics.newQuad(
                    columna * i,
                    fila,
                    ancho,
                    alto,
                    sw,
                    sh
                )
            )

        end

    end

    return animacion

end

------------------------------------------------
-- Actualización
------------------------------------------------

function ActualizarAnimacion(
    animacion,
    dt,
    unaVez
)

    if not animacion.activado then
        return
    end

    animacion.indice =
        animacion.indice +
        animacion.velocidad * dt

    if animacion.indice >
        #animacion.quads
    then

        if unaVez then

            animacion.indice =
                #animacion.quads

            animacion.activado =
                false

        else

            animacion.indice = 1

        end
    end

end

------------------------------------------------
-- Dibujado
------------------------------------------------

function DibujarAnimacion(
    animacion,
    x,
    y,
    origen_x,
    origen_y
)

    if not animacion.activado then
        return
    end

    local i =
        math.max(
            1,
            math.floor(animacion.indice)
        )

    love.graphics.draw(
        animacion.spritesheet,
        animacion.quads[i],
        x,
        y,
        0,
        1,
        1,
        origen_x,
        origen_y
    )

end