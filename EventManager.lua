EventManager = {}

EventManager.listeners = {}

function EventManager:suscribir(evento, oyente)

    if not self.listeners[evento] then
        self.listeners[evento] = {}
    end

    table.insert(
        self.listeners[evento],
        oyente
    )

end

function EventManager:notificar(
    evento,
    datos
)

    if not self.listeners[evento] then
        return
    end

    for _, oyente in ipairs(
        self.listeners[evento]
    ) do

        oyente:onNotify(
            evento,
            datos
        )

    end

end

return EventManager