UI = Class{}

function UI:init(jugador)

    self.jugador = jugador
    self.mensaje = ""

end

function UI:onNotify(
    evento,
    datos
)

    if evento == "MONEDA_RECOGIDA" then

        self.jugador.puntos =
            self.jugador.puntos + 1

        self.mensaje =
            "Moneda recogida"

        if self.jugador.puntos >=
           self.jugador.objetivo then

            EstadoJuegoActual:
                CinematicaVictoria()

        end

    end

    if evento == "JUGADOR_DANADO" then

        if not self.jugador.inmune then

            self.jugador.vidas =
                self.jugador.vidas - 1

            self.jugador:
                ActivarInvulnerabilidad()

            self.mensaje =
                "Daño recibido"

            if self.jugador.vidas <= 0 then

                MaquinaEstadoGlobal:
                    cambiar(
                        "derrota"
                    )

            end

        end

    end

end

function UI:Dibujar()

    love.graphics.print(
        "Vidas: "
        .. self.jugador.vidas,
        10,
        10
    )

    love.graphics.print(
    "Monedas: " ..
    self.jugador.derrotados,
    10,
    30
)
    love.graphics.print(
        self.mensaje,
        10,
        50
    )

end

return UI