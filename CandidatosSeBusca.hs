type Nombre = String
type Imagen = Float
type Habilidades = [String]
type Partido = String

type Alianza = [String]

data Dirigente = UnDirigente {
    nombre :: Nombre,
    imagenPositiva :: Imagen,
    habilidades :: Habilidades,
    cargo :: Cargo,
    partido :: Partido
 }

data Cargo = Gobernador|Diputado|Senador|Vicepresidente|Presidente deriving (Ord,Eq)

--data Cargo = Presidente|Vicepresidente|Senador|Diputado|Gobernador deriving (Ord,Eq)

instance Show Dirigente where
    show (UnDirigente name _ _ _ part) = "Nombre " ++ name ++ ", pertence al partido: " ++ part

macri = UnDirigente  {nombre = "Mauricio Macri", imagenPositiva = 10, habilidades = ["Bailar","Cantar","Honestidad", "Charlatan","Trap del canio", "Pegarle a un poli"], cargo = Presidente, partido = "pro"} 
cristina = UnDirigente "Cristina Fernandez" 5 ["Dar discursos","Chamuyar"] Diputado "cc"
nico = UnDirigente  "Nicolas Del Canio" 21 ["Solidario"] Senador "ucr"

cambiemos = ["pro","ucr","cc"]
frenteDeIzquierda = ["po","pcr"]
todos = ["frente para la victoria", "juntos"]

listaCandidatos = [macri,cristina,nico]

type Formula = (Dirigente,Dirigente)
type Construccion = ([Dirigente] -> Dirigente)
type ModoDeConstruccion = (Construccion,Construccion)

formula :: Alianza->ModoDeConstruccion->[Dirigente]->Formula
formula alianza modoConstruccion dirigentes = crearFormula (candidatosPertenecenAlianza dirigentes alianza) modoConstruccion
candidatosPertenecenAlianza :: [Dirigente] -> Alianza -> [Dirigente]
candidatosPertenecenAlianza dirigentes alianza = filter (pertenceAlianza alianza) dirigentes  
pertenceAlianza :: Alianza -> Dirigente -> Bool
pertenceAlianza alianza dirigente = elem (partido dirigente) alianza   
crearFormula :: [Dirigente] -> ModoDeConstruccion -> Formula 
crearFormula candidatos modoConstruccion = (((fst modoConstruccion) candidatos) , ((snd modoConstruccion) candidatos))
{-
dirigenteMayorCargo :: [Dirigente] -> Dirigente
dirigenteMayorCargo listaCandidatos = foldl1 (mayorCargo) listaCandidatos 
mayorCargo :: Dirigente -> Dirigente -> Dirigente 
mayorCargo candidato1 candidato2 
    | cargo candidato1 > cargo candidato2 = candidato1
    | otherwise = candidato2

imagenMayorAVeinte :: [Dirigente] -> Dirigente
imagenMayorAVeinte listaCandidatos = head(filter (masDeVeinte) listaCandidatos)
masDeVeinte :: Dirigente -> Bool
masDeVeinte candidato = imagenPositiva candidato > 20

mayorImagenPostiva :: [Dirigente] -> Dirigente
mayorImagenPostiva listaCandidatos = foldl1 (mayorImagen) listaCandidatos
mayorImagen :: Dirigente -> Dirigente -> Dirigente
mayorImagen candidato1 candidato2
    | imagenPositiva candidato1 > imagenPositiva candidato2 = candidato1
    | otherwise = candidato2

candidatoHonesto :: [Dirigente] -> Dirigente
candidatoHonesto listaCandidatos  = head (filter (esGobernadorHonesto) listaCandidatos)
esGobernadorHonesto :: Dirigente -> Bool
esGobernadorHonesto candidato = (cargo candidato == Gobernador) && (esHonesto (habilidades candidato))
esHonesto :: Habilidades -> Bool
esHonesto habilidadesCandidato = elem "Honestidad" habilidadesCandidato

habilidoso :: [Dirigente] -> Dirigente
habilidoso listaCandidatos = foldl1 (mayorHabilidades) listaCandidatos
mayorHabilidades :: Dirigente -> Dirigente -> Dirigente
mayorHabilidades candidato1 candidato2 
    | length (habilidades candidato1) > length (habilidades candidato2) = candidato1
    | otherwise = candidato2

    
-}
modoUno = (dirigenteMayorA (mayorA (length.habilidades)), dirigenteEspecifico masDeVeinte)

dirigenteMayorA :: (Dirigente -> Dirigente -> Dirigente) -> [Dirigente] -> Dirigente 
dirigenteMayorA criterioComparacion listaCandidatos = foldl1 (criterioComparacion) listaCandidatos

mayorA :: Ord b => (Dirigente -> b) -> Dirigente -> Dirigente -> Dirigente
mayorA criterio candidato1 candidato2
    | criterio candidato1 > criterio candidato2 = candidato1
    | otherwise = candidato2

dirigenteEspecifico :: (Dirigente -> Bool) ->  [Dirigente] -> Dirigente
dirigenteEspecifico cualidades listaCandidatos =  head (filter (cualidades) listaCandidatos)

masDeVeinte :: Dirigente -> Bool
masDeVeinte candidato = imagenPositiva candidato > 20
esGobernadorHonesto :: Dirigente -> Bool
esGobernadorHonesto candidato = (cargo candidato == Gobernador) && (esHonesto (habilidades candidato))
esHonesto :: Habilidades -> Bool
esHonesto habilidadesCandidato = elem "Honestidad" habilidadesCandidato





