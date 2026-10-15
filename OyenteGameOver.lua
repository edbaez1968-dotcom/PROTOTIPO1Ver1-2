OyenteGameOver = Class{}

function OyenteGameOver:onNotify(
    evento,
    datos
)

    if evento == "JUGADOR_DANADO" then

        if datos.jugador.vidas <= 0 then

            MaquinaEstadoGlobal:cambiar(
                "derrota"
            )

        end

    end

end
return OyenteGameOver