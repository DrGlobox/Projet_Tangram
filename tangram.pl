:- module(tangram, [piece/1, points_piece/2, pieces_tangram/1, pattern/1, points_pattern/2]).

%piece(?F, +N) avec f : expression représentant une piece existante
% et N la chaîne de caractères pour le nom affichable
piece(gros_triangle).
piece(moyen_triangle).
piece(petit_triangle).
piece(carre).
piece(parallelogramme).

%points_piece(+F,-L): avec f : expression représentant la piece 
%                          L : Liste des points composants la piece
points_piece(gros_triangle,   [[0,0] ,[100,0] ,[50,50]        ]).
points_piece(moyen_triangle,  [[0,0] ,[0,50]  ,[50, 0]        ]).
points_piece(petit_triangle,  [[0,0] ,[50,0]  ,[25,25]        ]).
points_piece(carre,           [[0,0] ,[25,0]  ,[25,25] ,[0,25]]).
points_piece(parallelogramme, [[0,0] ,[25,25] ,[25,75] ,[0,50]]).

%pieces_tangram(-L): avec L : liste des pieces disponibles pour résoudre le tangram
%		A noter que les pièces en double ne sont répétées qu'à la fin
%pieces_tangram([gros_triangle,gros_triangle,parallelogramme,carre,moyen_triangle,petit_triangle,petit_triangle]).
pieces_tangram([
	petit_triangle, gros_triangle,
	moyen_triangle, carre, parallelogramme,
	petit_triangle, gros_triangle]).

% Définition du pattern à résoudre
%pattern(?D) avec D : expression représentant les patterns existants
% 		Attention les patterns sont une liste de liste de piece 
pattern(triangle).
pattern(cube).
pattern(trapeze).
pattern(parallelogramme).
pattern(bizarre1).
pattern(bizarre2).
pattern(carre).
pattern(hexagone).
pattern(rectangle).
pattern(bizarre3).
pattern(maison).
pattern(grange).
pattern(brique).
pattern(pat_triangle).
pattern(piece_triangle).
<<<<<<< HEAD
pattern(teste).
=======
pattern(trois_triangle).
>>>>>>> db0b81aad35827443c91928cb1596bc853988fe0

points_pattern(triangle, [[[0,0], [200,0], [100,100]]]).
points_pattern(cube, [[[50,0], [100,50], [100,100], [50,150], [0,100], [0,50]]]).
points_pattern(trapeze, [[[0,0], [100,0], [150, 50], [150, 150]]]).
points_pattern(parallelogramme, [[[0,0], [100,0], [200,100], [100,100]]]).
points_pattern(bizarre1, [[[0,0], [100,0], [175,75], [125,125]]]).
points_pattern(bizarre2, [[[0,0], [150,0], [150,100], [100,100]]]).
points_pattern(carre, [[[0,0], [100,0], [100,100], [0,100]]]).
points_pattern(hexagone, [[[0,0], [50,0], [125,75], [125,125], [75,125], [0,50]]]).
points_pattern(rectangle, [[[50,0], [150,100], [100,150], [0,50]]]).
points_pattern(bizarre3, [[[25,0], [175,0], [100,75], [0,75], [0,25]]]).
points_pattern(maison, [[[0,0], [100,0], [125,25], [25,125], [0,100]]]).
points_pattern(grange, [[[25,0], [75,0], [125,50], [50,125], [0,75], [0,25]]]).
points_pattern(brique, [[[50,0], [150,0], [175,25], [125,75], [25,75], [0,50]]]).
points_pattern(pat_triangle, [[[0,0],[0,100],[100,0]]]).
points_pattern(piece_triangle, [[[0,0],[0,100],[50,50]]]).
<<<<<<< HEAD
points_pattern(teste, [[[0,0],[0,100],[50,50],[100,50],[100,0]]]).
=======
points_pattern(trois_triangle, [[[0,0], [100,0], [100,50], [75,75], [50,50]]]).
>>>>>>> db0b81aad35827443c91928cb1596bc853988fe0
