import Text.Show.Functions

type Nombre = String
type Jugadores = [String]
type Puntaje = Int 
type Club = String
type Puesto = String
type Cotizacion  = Int
type Puntos = [Int]
type Minutos = Int

data Participante = UnParticipante {
    nombreParticipante :: Nombre,
    jugadores :: Jugadores,
    puntajeEstimado :: Puntaje
} deriving Show

type Informacion = (Club, Puesto, Cotizacion)
data JugadorDeFutbol = UnJugador{
    nombreJugador :: Nombre,
    informacion :: Informacion
}

type PuntosYMinutos = (Puntos, Minutos)
data FechaJugada = UnaFecha {
    nombreJugadorDeLaFecha :: Nombre,
    puntosYMinutos :: PuntosYMinutos 
}

ana = UnParticipante "Ana" ["Orion","Schiavi","Trezeguet","Cubero" ] 20
jose = UnParticipante "Jose" ["Orion","Trezeguet" ] 30
juancho = UnParticipante "Jose" [ "Orion","Schiavi","Trezeguet","Cubero", "Silva", "Icardi" ] 10

listaAna = ["Orion","Schiavi","Trezeguet","Cubero" ]
listaJo = ["Orion","Trezeguet" ]
listaJu = ["Orion","Schiavi","Trezeguet","Cubero", "Silva", "Icardi"]

listaJugadores :: [JugadorDeFutbol]
listaJugadores = [ orion, schiavi, trezeguet, cubero, silva, icardi ]

orion = UnJugador "Orion" ("Boca", "Arquero", 50)
schiavi = UnJugador "Schiavi" ("Boca", "Defensor", 80)
trezeguet = UnJugador "Trezeguet" ("River", "Delantero", 25)
cubero = UnJugador "Cubero" ("Velez", "Volante", 85)
silva = UnJugador "Silva" ("Boca", "Delantero", 100)
icardi = UnJugador "Icardi" ("PSG", "Delantero", 300)

fechaUno :: [FechaJugada]
fechaUno = [ orionEnFecha, schiaviEnFecha, trezeguetEnFecha, cuberoEnFecha, silvaEnFecha, icardiEnFecha]

fechaDos :: [FechaJugada]
fechaDos = [orionEnFecha, schiaviEnFecha, trezeguetEnFecha, cuberoEnFecha]

orionEnFecha = UnaFecha "Orion" ( [8,7], 90 )
schiaviEnFecha = UnaFecha "Schiavi"  ( [], 0 ) 
trezeguetEnFecha = UnaFecha "Trezeguet" ([4,2,1,1], 90 )
cuberoEnFecha = UnaFecha "Cubero" ( [2,9], 45 )
silvaEnFecha = UnaFecha "Silva" ( [6,6,6], 90 )
icardiEnFecha = UnaFecha "Icardi" ([5,8,9], 90)

---------------------- PUNTO UNO ----------------------
buenPuntaje :: Participante -> [FechaJugada] -> Bool
buenPuntaje persona fecha  
    | (sumaDeLosPuntajes fecha persona >= (puntajeEstimado persona - 5) ) && (sumaDeLosPuntajes fecha persona <= (puntajeEstimado persona + 5)) = True
    | otherwise = False

sumaDeLosPuntajes :: [FechaJugada] -> Participante -> Int
sumaDeLosPuntajes fecha persona = sum (map (sumListaDePuntajes (jugadores persona)) fecha)

sumListaDePuntajes :: [String] -> FechaJugada -> Int
sumListaDePuntajes jugadoresParticipante fechaJugador = sum (map (obtenerPuntajePorJugador fechaJugador) jugadoresParticipante)

obtenerPuntajePorJugador :: FechaJugada -> String -> Int
obtenerPuntajePorJugador fechaJugador jugador  
    | esJugadorDeLaFecha jugador fechaJugador = sum ( fst ( puntosYMinutos fechaJugador ) )
    | otherwise = 0

esJugadorDeLaFecha :: String -> FechaJugada -> Bool
esJugadorDeLaFecha jugador fechaJugador = nombreJugadorDeLaFecha fechaJugador == jugador 

---------- PUNTO A ----------
puntajeMasAlto :: [FechaJugada] -> Participante -> Int
puntajeMasAlto fecha persona = maximum (listaDeLosPuntajes fecha persona)

promedioDePuntajes :: [FechaJugada] -> Participante -> Int
promedioDePuntajes fecha persona = div (sum (listaDeLosPuntajes fecha persona) ) (length (listaDeLosPuntajes fecha persona))

puntajeEstimadoMasAlto :: Participante -> Participante -> Bool
puntajeEstimadoMasAlto participante1 participante2 = puntajeEstimado participante1 > puntajeEstimado participante2 

listaDeLosPuntajes :: [FechaJugada] -> Participante -> [Int]
listaDeLosPuntajes fecha persona = map (sumListaDePuntajes (jugadores persona)) fecha

listaDePuntajes :: [String] -> FechaJugada -> [Int]
listaDePuntajes jugadoresParticipante fechaJugador =  map (obtenerPuntajePorJugador fechaJugador) jugadoresParticipante

---------- PUNTO B ----------
gananTodos :: Participante -> Participante -> [FechaJugada] -> Participante
gananTodos participante1 participante2 fecha 
    | sumaDeLosPuntajes fecha participante1  > sumaDeLosPuntajes fecha participante2 = participante1
    | puntajeMasAlto fecha participante1 > puntajeMasAlto fecha participante2 = participante1
    | promedioDePuntajes fecha participante1 > promedioDePuntajes fecha participante2 = participante1
    | puntajeEstimadoMasAlto participante1 participante2 = participante1
    | otherwise = error " el primer participante nunca es mejor "

---------------------- PUNTO DOS ----------------------

---------- PUNTO A ----------
minutosFaltantesDe :: Participante -> [FechaJugada] -> Int
minutosFaltantesDe participante fecha = 360 - (sumaMinutos (jugadores participante) fecha) 

sumaMinutos :: [String] -> [FechaJugada] -> Int
sumaMinutos jugadoresParticipante fecha = sum (map (sumListaMinutos jugadoresParticipante ) fecha)

sumListaMinutos :: [String] -> FechaJugada -> Int
sumListaMinutos jugadoresParticipante fechaJugador = sum(map(obtenerMinutosJugados fechaJugador) jugadoresParticipante)

obtenerMinutosJugados :: FechaJugada -> String -> Int
obtenerMinutosJugados fechaJugador jugador  
    | esJugadorDeLaFecha jugador fechaJugador = snd ( puntosYMinutos fechaJugador )
    | otherwise = 0

---------- PUNTO B ----------
tieneEquipoCaro :: Participante -> [JugadorDeFutbol] -> Bool
tieneEquipoCaro persona listJugadores = (calcularCotizacion (jugadores persona) listJugadores) > 500

calcularCotizacion :: [String] -> [JugadorDeFutbol] -> Int
calcularCotizacion jugadoresParticipante listJugadores = sum (map (obtenerMontoTotal jugadoresParticipante) listJugadores)

obtenerMontoTotal :: [String] -> JugadorDeFutbol ->  Int
obtenerMontoTotal  jugadoresParticipante jugadorX
    | esParteDelEquipo jugadoresParticipante jugadorX =  obtenerCotizacion jugadorX 
    | otherwise = 0

obtenerCotizacion :: JugadorDeFutbol -> Int
obtenerCotizacion jugadorX   = thrd (informacion jugadorX)

thrd :: Informacion -> Int
thrd (_,_,cotizacion) = cotizacion

esParteDelEquipo:: [String] -> JugadorDeFutbol -> Bool
esParteDelEquipo jugadoresParticipante jugadorX = any (nombreJugador jugadorX ==) jugadoresParticipante 