OyenteVictoria = Class{}

function OyenteVictoria:onNotify(
    evento,
    datos
)

    if evento == "MONEDA_RECOGIDA" then

        if datos.jugador.derrotados >=
           datos.jugador.objetivo then

            MaquinaEstadoGlobal:cambiar(
                "victoria"
            )

        end

    end

end

return OyenteVictoria