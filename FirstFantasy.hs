import Text.Show.Functions
{-
Vida = mide en puntos y nos indica que tan saludable esta un personaje 
    en un momento dado.
Resistencia = se utiliza para calcular ( DEFENSA = RESISTENCIA + VIDA)
Fuerza = PODERIO fisico de un personaje. 
ATAQUE = se calcula como la fuerza que tiene el personaje modificado por todos
    los poderes de los  objetos que el personaje tenga, aplicados en orden.
-}

data Personaje = 
    UnPersonaje {
        nombre :: String,
        vida :: Float,
        resistencia :: Float,
        fuerza :: Float,
        objetos :: [(Float -> Float)] } deriving (Show)

----------- Objetos -----------
espadaOxidada = (1.2*)
katanaFilosa  = (10+).(0.9*)
dagaLambdica cm = ((1+cm)/100*)
anilloParadigmatico = sqrt
baculoDuplicador x = x * 2
espadaMaldita = espadaOxidada.dagaLambdica 89


----------- Personajes -----------
aeris = UnPersonaje { 
    nombre = "aeris",
    vida = 500,
    resistencia = 500,
    fuerza = 2100,
    objetos = [baculoDuplicador]}

sephiroth = UnPersonaje {
    nombre = "sephiroth",
    vida = 2000,
    resistencia = 1000,
    fuerza = 2500,
    objetos = [espadaOxidada,katanaFilosa, (dagaLambdica 50)]}

----------- PUNTO UNO -----------
calculoAtaque personaje = foldr ($) (fuerza personaje) (objetos personaje) 
calculoDefensa personaje = (resistencia personaje) + (vida personaje) 

----------- PUNTO DOS -----------
calculoDanio atacante atacado = (calculoAtaque atacante) - (calculoDefensa atacado)
ataque atacante atacado 
    | (calculoDanio atacante atacado) >= 0 = atacado {vida = (vida atacado) - (calculoDanio atacante atacado)}
    | otherwise = atacado {vida = 0}
--(vida atacado) - ((calculoDanio atacante atacado)*(-1))

----------- PUNTO TRES -----------
robarObjetos personaje1 personaje2 = personaje1 {objetos = objetos personaje1 ++ objetos personaje2}
convienePelear personaje1 personaje2 = (calculoAtaque personaje1 ) < (calculoAtaque (robarObjetos personaje1 personaje2))

----------- PUNTO CUATRO -----------
batalla personaje1 personaje2 
    | vida personaje1 <= 0 = error "Sin vida no puede pelear"
    | vida personaje2 <= 0 = error "Sin vida no puede pelear"
    | vida (ataque personaje1 personaje2) <= 0 = robarObjetos personaje1 personaje2
    | otherwise = batalla (ataque personaje1 personaje2) personaje1 

----------- PUNTO CINCO -----------
aprendis personaje = personaje {objetos = combinarObjetos (objetos personaje)}
combinarObjetos objetos = [foldl1 (.) objetos]

maestroArtesano personaje anios = aprendis personaje {objetos = potenciarObjeto (objetos personaje) anios}
potenciarObjeto objetos anios = objetos ++ replicate anios (1.1*)

estafador persoanje = persoanje {objetos = [id]}

----------- PUNTO SEIS -----------
