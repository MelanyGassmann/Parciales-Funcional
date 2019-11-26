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
} deriving Show

type PuntosYMinutos = (Puntos, Minutos)
data FechaJugada = UnaFecha {
    nombreJugadorDeLaFecha :: Nombre,
    puntosYMinutos :: PuntosYMinutos 
} deriving Show

ana = UnParticipante "Ana" ["Orion","Schiavi","Trezeguet","Cubero" ] 20
jose = UnParticipante "Jose" ["Orion","Trezeguet" ] 20
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
buenPuntaje persona fecha = estaEnElRango (puntajeTotal fecha (jugadores persona)) (puntajeEstimado persona)
  
estaEnElRango :: Int -> Int -> Bool
estaEnElRango puntajeReal puntajeEstimado = puntajeReal >= puntajeEstimado-5 && puntajeReal <= puntajeEstimado +5

puntajeTotal :: [FechaJugada] -> [Nombre] -> Int
puntajeTotal fecha jugadoresParticipante = sum (listaDeLosPuntajes fecha jugadoresParticipante)

listaDeLosPuntajes :: [FechaJugada] -> [Nombre] -> [Int]
listaDeLosPuntajes fecha jugadoresParticipante = map (obtenerPuntajePorJugador) (jugadoresDeLaFecha fecha jugadoresParticipante)

jugadoresDeLaFecha :: [FechaJugada] -> [Nombre]->  [FechaJugada]
jugadoresDeLaFecha fecha jugadoresParticipante = filter (estaJugando jugadoresParticipante) fecha 

estaJugando :: [Nombre] -> FechaJugada -> Bool
estaJugando jugadoresParticipante fechaJugador = any (nombreJugadorDeLaFecha fechaJugador ==) jugadoresParticipante 

obtenerPuntajePorJugador ::  FechaJugada -> Int
obtenerPuntajePorJugador fechaJugador = sum (fst(puntosYMinutos fechaJugador))

---------- PUNTO A ----------
puntajeMasAlto :: [FechaJugada] -> Participante -> Int
puntajeMasAlto fecha persona = maximum (listaDeLosPuntajes fecha (jugadores persona))

promedioDePuntajes :: [FechaJugada] -> Participante -> Int
promedioDePuntajes fecha persona = div (puntajeTotal fecha (jugadores persona)) (length (jugadoresDeLaFecha fecha (jugadores persona)))

puntajeEstimadoMasAlto :: Participante -> Participante -> Bool
puntajeEstimadoMasAlto participante1 participante2 = puntajeEstimado participante1 > puntajeEstimado participante2 

---------- PUNTO B ----------
gananTodos :: Participante -> Participante -> [FechaJugada] -> Participante
gananTodos participante1 participante2 fecha 
    | puntajeTotal fecha (jugadores participante1)  > puntajeTotal fecha (jugadores participante2) =  participante1
    | puntajeMasAlto fecha participante1 > puntajeMasAlto fecha participante2 = participante1
    | promedioDePuntajes fecha participante1 > promedioDePuntajes fecha participante2 = participante1
    | puntajeEstimadoMasAlto participante1 participante2 = participante1
    | otherwise = error " el primer participante nunca es mejor "

---------------------- PUNTO DOS ----------------------
---------- PUNTO A ----------
minutosFaltantesDe :: Participante -> [FechaJugada] -> Minutos
minutosFaltantesDe participante fecha = 360 - (minutosTotales fecha (jugadores participante)) 

minutosTotales :: [FechaJugada] -> [Nombre] -> Minutos
minutosTotales fecha jugadoresParticipante = sum (listaDeLosMinutos fecha jugadoresParticipante)

listaDeLosMinutos :: [FechaJugada] -> [Nombre] -> [Minutos]
listaDeLosMinutos fecha jugadoresParticipante = map (obtenerMinutosPorJugador) (jugadoresDeLaFecha fecha jugadoresParticipante)

obtenerMinutosPorJugador ::  FechaJugada -> Minutos
obtenerMinutosPorJugador fechaJugador = snd (puntosYMinutos fechaJugador) 

---------- PUNTO B ----------
tieneEquipoCaro :: Participante -> [JugadorDeFutbol] -> Bool
tieneEquipoCaro persona listJugadores = (calcularCotizacionTotal listJugadores (jugadores persona)) > 500

calcularCotizacionTotal :: [JugadorDeFutbol] -> [Nombre] -> Int
calcularCotizacionTotal listJugadores jugadoresParticipante = sum (listaDeLasCotizaciones listJugadores jugadoresParticipante)

listaDeLasCotizaciones :: [JugadorDeFutbol] -> [Nombre] -> [Int]
listaDeLasCotizaciones listJugadores jugadoresParticipante = map (obtenerCotizacionPorJugador) (jugadoresDelEquipo listJugadores jugadoresParticipante)

jugadoresDelEquipo :: [JugadorDeFutbol] -> [Nombre]->  [JugadorDeFutbol]
jugadoresDelEquipo  listJugadores jugadoresParticipante = filter (esParteDelEquipo jugadoresParticipante) listJugadores 

esParteDelEquipo:: [Nombre] -> JugadorDeFutbol -> Bool
esParteDelEquipo jugadoresParticipante jugadorX = any (nombreJugador jugadorX ==) jugadoresParticipante 

obtenerCotizacionPorJugador ::  JugadorDeFutbol -> Int
obtenerCotizacionPorJugador jugadorX  = thrd (informacion jugadorX) 

thrd :: Informacion -> Cotizacion
thrd (_,_,cotizacion) = cotizacion

obtenerCotizacion :: JugadorDeFutbol -> Cotizacion
obtenerCotizacion jugadorX   = thrd (informacion jugadorX)