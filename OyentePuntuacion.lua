OyentePuntuacion = Class{}

function OyentePuntuacion:init()

end

function OyentePuntuacion:onNotify(
    evento,
    datos
)

    if evento == "MONEDA_RECOGIDA" then

        datos.jugador.derrotados =
            datos.jugador.derrotados + 1

    end

end

return OyentePuntuacion