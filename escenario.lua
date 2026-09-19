-- Escenario: Bosque Encantado del Duende
Estructuras = {}
Estructuras.__index = Estructuras

local tag_arbol_izq = "ArbolIzquierdo"
local tag_arbol_der = "ArbolDerecho"
local tag_suelo = "SueloBosque"
local tag_rama = "RamaFlotante"
local tag_hongo = "HongoGigante"

function Estructuras:Nuevo(x, y, ruta, tag, escalax, escalay)
    local estructura = setmetatable({}, Estructuras)
    estructura.sprite = love.graphics.newImage(ruta)
    estructura.cuerpo = love.physics.newBody(world, x, y)
    estructura.escala_x = escalax
    estructura.escala_y = escalay
    estructura.forma = love.physics.newRectangleShape(
        estructura.sprite:getWidth() * estructura.escala_x,
        estructura.sprite:getHeight() * estructura.escala_y
    )
    estructura.acople = love.physics.newFixture(estructura.cuerpo, estructura.forma)
    estructura.acople:setUserData(tag)
    estructura.acople:setFriction(0.3)
    return estructura
end

function Estructuras:DibujarEstructura()
    love.graphics.draw(
        self.sprite,
        self.cuerpo:getX(),
        self.cuerpo:getY(),
        0,
        self.escala_x,
        self.escala_y,
        self.sprite:getWidth()/2,
        self.sprite:getHeight()/2
    )
end

function CrearEscenario()
    -- Semilla aleatoria para que cada ejecución genere posiciones diferentes
    math.randomseed(os.time())

    -- Dimensiones basadas en ventana (160x180)
    local ancho = ventana.ancho
    local alto = ventana.alto

    -- Estructuras de los bordes/límites
    arbol_izquierdo = Estructuras:Nuevo(6, alto / 2, "img/ArbolTronco.png", tag_arbol_izq, 0.75, 1.25)
    arbol_derecho = Estructuras:Nuevo(ancho - 6, alto / 2, "img/ArbolTronco.png", tag_arbol_der, 0.75, 1.25)
    suelo_bosque = Estructuras:Nuevo(ancho / 2, alto - 4, "img/SueloBosque.png", tag_suelo, 1, 1)

    -- Ramas Flotantes en posiciones aleatorias dentro de los límites jugables 0.30, 0.50
    rama_central = Estructuras:Nuevo(math.random(30, ancho - 30), math.random(30, alto - 40), "img/RamaFlotante.png", tag_rama,1,1 )
    rama_superior_izq = Estructuras:Nuevo(math.random(25, 60), math.random(25, 50), "img/RamaFlotante.png", tag_rama, 0.25, 0.50)
    rama_superior_der = Estructuras:Nuevo(math.random(100, 135), math.random(25, 50), "img/RamaFlotante.png", tag_rama, 0.50, 0.90)
    rama_inferior_izq = Estructuras:Nuevo(math.random(25, 60), math.random(110, 140), "img/RamaFlotante.png", tag_rama, 0.25, 0.50)
    rama_inferior_der = Estructuras:Nuevo(math.random(100, 135), math.random(110, 140), "img/RamaFlotante.png", tag_rama, 0.25, 0.50)

    -- Hongos Gigantes en posiciones aleatorias con el DOBLE de tamaño (0.40, 0.80)  doble: 0.40, 0.80
    hongo_izq = Estructuras:Nuevo(math.random(20, ancho / 2 - 10), math.random(30, alto - 50), "img/HongoGigante.png", tag_hongo, 1, 1)
    hongo_der = Estructuras:Nuevo(math.random(ancho / 2 + 10, ancho - 20), math.random(30, alto - 50), "img/HongoGigante.png", tag_hongo, 1, 1)
    -- Moneadas de plata y oro
    moneda_plata = Estructuras:Nuevo(math.random(50, ancho / 2 - 10), math.random(100, alto - 50), "img/monedaPlata16x16.png", tag_hongo,  0.45,  0.45)
    moneda_oro = Estructuras:Nuevo(math.random(ancho / 2 + 10, ancho - 20), math.random(70, alto - 30), "img/MonedaOro16x16.png", tag_hongo,0.45,  0.45)
end

function DibujarEscenario()
    arbol_izquierdo:DibujarEstructura()
    arbol_derecho:DibujarEstructura()
    suelo_bosque:DibujarEstructura()
    
    rama_central:DibujarEstructura()
    rama_superior_izq:DibujarEstructura()
    rama_superior_der:DibujarEstructura()
    rama_inferior_izq:DibujarEstructura()
    rama_inferior_der:DibujarEstructura()
    
    hongo_izq:DibujarEstructura()
    hongo_der:DibujarEstructura()

    moneda_plata:DibujarEstructura()
    moneda_oro:DibujarEstructura()
end