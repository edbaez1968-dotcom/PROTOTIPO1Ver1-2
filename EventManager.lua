EventManager = {

    listeners = {}

}

function EventManager:suscribir(
    evento,
    observador
)

    if self.listeners[evento] == nil then

        self.listeners[evento] = {}

    end

    table.insert(
        self.listeners[evento],
        observador
    )

end

function EventManager:desuscribir(
    evento,
    observador
)

    local lista =
        self.listeners[evento]

    if not lista then
        return
    end

    for i, obj in ipairs(lista) do

        if obj == observador then

            table.remove(
                lista,
                i
            )

            break

        end

    end

end

function EventManager:notificar(
    evento,
    datos
)

    local lista =
        self.listeners[evento]

    if not lista then
        return
    end

    for _, observador in ipairs(lista) do

        if observador.onNotify then

            observador:onNotify(
                evento,
                datos
            )

        end

    end

end

function EventManager:limpiar()

    self.listeners = {}

end

return EventManager