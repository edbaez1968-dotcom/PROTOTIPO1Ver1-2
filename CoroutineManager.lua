CoroutineManager = {}

CoroutineManager.lista = {}

function CoroutineManager:Agregar(co)

    table.insert(
        self.lista,
        co
    )

end

function CoroutineManager:Actualizar(dt)

    for i = #self.lista, 1, -1 do

        local co = self.lista[i]

        if coroutine.status(co) == "dead" then

            table.remove(
                self.lista,
                i
            )

        else

            local ok, err =
                coroutine.resume(
                    co,
                    dt
                )

            if not ok then

                print(err)

                table.remove(
                    self.lista,
                    i
                )

            end

        end

    end

end

return CoroutineManager