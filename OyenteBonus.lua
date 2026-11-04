OyenteBonus = Class{}

function OyenteBonus:onNotify(
    evento,
    datos
)

    if evento ~= "MONEDA_RECOGIDA" then
        return
    end

    local jugador =
        datos.jugador

    if jugador.derrotados % 5 ~= 0 then
        return
    end

    local co =
        coroutine.create(

        function()

            local velocidadOriginal =
                jugador.velocidad

            jugador.velocidad =
                velocidadOriginal * 2

            print(
                "BONUS ACTIVADO"
            )

            local tiempo = 0

            while tiempo < 10 do

                local dt =
                    coroutine.yield()

                tiempo =
                    tiempo + dt

            end

            jugador.velocidad =
                velocidadOriginal

            print(
                "BONUS FINALIZADO"
            )

        end
    )

    CoroutineManager:
        Agregar(co)

end

return OyenteBonus
