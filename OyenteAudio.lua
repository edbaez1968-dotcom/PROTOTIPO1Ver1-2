OyenteAudio = Class{}

function OyenteAudio:onNotify(
    evento,
    datos
)

    if evento == "MONEDA_RECOGIDA" then

        love.audio.stop(clink)
        love.audio.play(clink)

    end

    if evento == "JUGADOR_DANADO" then

        love.audio.stop(Sfx_hit)
        love.audio.play(Sfx_hit)

    end

end
return OyenteAudio