import Text.Show.Functions

type Nombre = String
type Actitud = String
type Indice = Float
type Recuerdos = String 
data Alumno = UnAlumno {
    nombreAlumno :: Nombre, 
    actitudDestacada :: Actitud, 
    indiceDeMotivacion :: Indice, 
    recuerdoSignificativos :: [Recuerdos]  } deriving Show

--Ejemplo alumno
cachito = 
    UnAlumno{
        nombreAlumno = "Estanislao Pereira",
        actitudDestacada = "agresivo",
        indiceDeMotivacion = 15,
        recuerdoSignificativos = ["conoci la facultad", "aprobe mi primer examen", "hice un hola mundo que funcionaba", "conoci a julia"] 
    }

actitudesFrecuentes = ["buena onda", "predispuesto", "indiferente"]

---------------------- PRIMERA PARTE ----------------------
----------- PUNTO UNO -----------
tieneAlgunRecuerdo :: Alumno -> Bool
tieneAlgunRecuerdo alumno = any (recuerdoDeAprobacion) (recuerdoSignificativos alumno)

recuerdoDeAprobacion :: Recuerdos -> Bool
recuerdoDeAprobacion = (=="aprobe" ).head.words 

----------- PUNTO DOS -----------

{-
aumentoMotivacion :: Alumno -> Alumno
aumentoMotivacion alumno = alumno {indiceDeMotivacion = incrementarIndice alumno (*1.1)}

incrementarIndice :: Alumno -> (Indice -> Indice) -> Indice
incrementarIndice alumno incremento = incremento (indiceDeMotivacion alumno) 
-}
aumentoMotivacion :: Alumno -> Alumno
aumentoMotivacion alumno = incrementarIndice alumno (*1.1)

incrementarIndice :: Alumno -> (Indice -> Indice) -> Alumno
incrementarIndice alumno incremento = alumno {indiceDeMotivacion = incremento (indiceDeMotivacion alumno)}  

----------- PUNTO TRES -----------
cambioActitud :: Alumno -> Alumno
cambioActitud alumno = alumno { actitudDestacada = obtenerActitudSiguiente (actitudDestacada alumno) actitudesFrecuentes }

obtenerActitudSiguiente :: Actitud -> [Actitud] -> Actitud
obtenerActitudSiguiente actitudActual (x:xs)
        | not (elem actitudActual actitudesFrecuentes) = "No es una actitud frecuente"
        | (actitudActual == x ) && (length xs == 0) = actitudActual
        | (actitudActual == x ) && (length xs /= 0) = head xs
        | otherwise = obtenerActitudSiguiente actitudActual xs

----------- PUNTO CUATRO -----------
buenProfecional :: Alumno -> Bool 
buenProfecional alumno = (tieneAlgunRecuerdo alumno) && (indiceDeMotivacion alumno) > 10

----------- PUNTO CINCO -----------
crearNuevoRecuerdo :: Alumno -> [Recuerdos] -> Alumno
crearNuevoRecuerdo alumno nuevoRecuerdo = alumno {recuerdoSignificativos = (recuerdoSignificativos alumno) ++ nuevoRecuerdo}

experiencia :: [Recuerdos] -> (Indice -> Indice) -> Alumno -> Alumno
experiencia nuevoRecuerdo incremento alumno
        | (indiceDeMotivacion alumno == 0) || (actitudDestacada alumno == "indiferente") = alumno
        | otherwise = incrementarIndice (crearNuevoRecuerdo alumno nuevoRecuerdo) incremento
--(cambioActitud alumno) cambioActitud     

---------------------- SEGUNDA PARTE ----------------------
type Indicador = Float
type Situacion = String
type Contexto = [(Situacion, Indicador)]
contextoHipotetico = [("aumento salarial", 30.0), ("presupuesto", 2000.0), ("represion de la protesta social", 1.18), ("inflacion", 35.5)]

indicadorDelContexto :: Situacion -> Contexto -> Indicador
indicadorDelContexto situacion  = snd.head.filter ((==situacion).fst) 

---------------------- TERCERA PARTE ----------------------

----------- Docentes -----------
data Profesor = Profesor { 
    apellido :: String,
    apreciacion :: [(String, Float)]-> Bool, 
    accion :: (Alumno -> Alumno)} deriving Show

tito = 
     Profesor  { 
         apellido = "Perez",
         apreciacion = laInflacionEsMayorAlAumento,
         accion = paro }

luci =  
    Profesor { 
        apellido = "Garcia",
        apreciacion =  bajoPresupuesto,
        accion =  tomarParcialConProblemasDeActualidad }

indi = 
    Profesor { 
        apellido = "Gonzalez",
        apreciacion =  paseLoQuePase,
        accion = noHacerNada }

juan =
    Profesor {
        apellido = "Martinez",
        apreciacion = paseLoQuePase,
        accion = movilizacion "plaza de mayo" } 
    --OTRO (JUAN) … (que haga una movilizacion al ministerio de educacion)

carlos =
    Profesor {
        apellido = "Lopez",
        apreciacion = bajoPresupuesto,
        accion = clasePublica "economia actual" } 

matilda =
    Profesor {
        apellido = "Gutierrez",
        apreciacion = laInflacionEsMayorAlAumento,
        accion = claseNormal "saraza" }

----------- Apreciacion -----------
laInflacionEsMayorAlAumento contexto = (indicadorDelContexto "inflacion" contexto) > (indicadorDelContexto "aumento salarial" contexto)

bajoPresupuesto contexto = (indicadorDelContexto "presupuesto" contexto) < 500

paseLoQuePase _ = True

----------- Acciones -----------
paro alumno = experiencia ["paro"] (*0.3) alumno
movilizacion lugar alumno = experiencia ["movilizacion"] (*0.8) alumno 
claseNormal tema alumno = experiencia [] (+10) alumno
clasePublica tema alumno = ((experiencia ["clase publica"] (*1.5)).claseNormal tema) alumno
noHacerNada alumno = alumno
tomarParcialConProblemasDeActualidad  alumno = experiencia ["tomar parcial con poblemas de actualidad"] (*2) alumno


{- 
----------- PUNTO UNO -----------
unDiaEspecial :: Situacion -> [Alumno] -> Profesor 
unDiaEspecial contexto estudiantes docente 
        | (apreciacion docente) contexto =  map (accion docente) estudiantes
        | otherwise = estudiantes

-}