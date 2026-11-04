OyenteVictoria = Class{}

function OyenteVictoria:onNotify(
    evento,
    datos
)

    if evento ~= "MONEDA_RECOGIDA" then
        return
    end

    if datos.jugador.derrotados >=
       datos.jugador.objetivo then

        MaquinaEstadoGlobal:cambiar(
            "victoria"
        )

    end

end

return OyenteVictoria