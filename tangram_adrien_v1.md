## Algo pour la détection de la position des différentes pièces

### Etat initial
On a dans l'état initial la liste de pièces, ainsi que la forme à recouvrir. Chaque pièce (et la
forme) est représentée par un ensemble de points, par exemple 3 points pour un triangle. On les
note dans le premier quart d'un repère (donc x et y positif).

_Exemple :_ un grand triangle peut être composé des points (0, 0), (4, 0) et (2, 2). Le carré sera
représenté par (0, 0), (sqrt(2), 0), (sqrt(2), sqrt(2)) et (0, sqrt(2)).

### Début de l'algo
```
DEBUT BOUCLE
Boucle tant qu'il reste une pièce dans la liste

On sélectionne la première pièce de la liste, et on calcul la longueur de chacune de ses arêtes. On
effectue la même opération pour la forme à rechercher.

    DEBUT SI
    Si une arête de la pièce est de la même longueur qu'une arête de la forme__
    
        Alors on colle la pièce à cette arête, et on la tourne dans les 4 sens possibles pour voir s'il
        est possible de la caser dans la forme.

        DEBUT SI
        S'il est possible de la caser dans la forme __
        
            on enlève la pièce de la liste, et on calcule la nouvelle forme que l'on obtient. Puis on 
            va à la fin de la boucle.
    
        SINON
            on passe à une pièce suivante
        
        FIN SI

    SINON
        on passe à une pièce suivante
    
    FIN SI

FIN BOUCLE
```
### Note
Certains cas ne peuvent être résolu avec ces méthodes (par exemple le carré), il faudrait donc
insérer une méthode à la suite de la boucle pour compléter le restant de la forme. On peut également
dire que si l'on bloque à un moment donné, on remonte d'un branche dans l'arbre pour essayer de
placer la pièce autre part.
