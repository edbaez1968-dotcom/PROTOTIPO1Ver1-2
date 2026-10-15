OyenteVida = Class{}

function OyenteVida:init()

end

function OyenteVida:onNotify(
    evento,
    datos
)

    if evento ~= "JUGADOR_DANADO" then
        return
    end

    local jugador = datos.jugador

    -- Evitar daño continuo
    if jugador.inmune then
        return
    end

    jugador.vidas =
        jugador.vidas - (datos.dano or 1)

    jugador.inmune = true
    jugador.tiempoInmune = 1

    print(
        "Vidas restantes: "
        .. jugador.vidas
    )

end

return OyenteVida