:- module(tangram, [figure/1, points_figure/2, figures_tangram/1, dessin/1, points_dessin/2]).

%figure(?F, +N) avec f : expression représentant une figure existante
% et N la chaîne de caractères pour le nom affichable
figure(gros_triangle).
figure(moyen_triangle).
figure(petit_triangle).
figure(carre).
figure(parallelogramme).

%points_figure(+F,-L): avec f : expression représentant la figure 
%                          L : Liste des points composants la figure
points_figure(gros_triangle,   [[0,0] ,[100,0] ,[50,50]        ]).
points_figure(moyen_triangle,  [[0,0] ,[0,50]  ,[50, 0]        ]).
points_figure(petit_triangle,  [[0,0] ,[50,0]  ,[25,25]        ]).
points_figure(carre,           [[0,0] ,[25,0]  ,[25,25] ,[0,25]]).
points_figure(parallelogramme, [[0,0] ,[25,25] ,[25,75] ,[0,25]]).

%figures_tangram(-L): avec L : liste des figures disponibles pour résoudre le tangram
%		A noter que les pièces en double ne sont répétées qu'à la fin
%figures_tangram([gros_triangle,gros_triangle,parallelogramme,carre,moyen_triangle,petit_triangle,petit_triangle]).
figures_tangram([
	petit_triangle, gros_triangle,
	moyen_triangle, carre, parallelogramme,
	petit_triangle, gros_triangle]).

% Définition du dessin à résoudre
%dessin(?D) avec D : expression représentant les dessins existants
% 		Attention les dessins sont une liste de liste de figure 
dessin(triangle).
dessin(cube).
dessin(trapeze).
dessin(parallelogramme).
dessin(bizarre1).
dessin(bizarre2).
dessin(carre).
dessin(hexagone).
dessin(rectangle).
dessin(bizarre3).
dessin(maison).
dessin(grange).
dessin(brique).

points_dessin(triangle, [[[0,0], [200,0], [100,100]]]).
points_dessin(cube, [[[50,0], [100,50], [100,100], [50,150], [0,100], [0,50]]]).
points_dessin(trapeze, [[[0,0], [100,0], [150, 50], [150, 150]]]).
points_dessin(parallelogramme, [[[0,0], [100,0], [200,100], [100,100]]]).
points_dessin(bizarre1, [[[0,0], [100,0], [175,75], [125,125]]]).
points_dessin(bizarre2, [[[0,0], [150,0], [150,100], [100,100]]]).
points_dessin(carre, [[[0,0], [100,0], [100,100], [0,100]]]).
points_dessin(hexagone, [[[0,0], [50,0], [125,75], [125,125], [75,125], [0,50]]]).
points_dessin(rectangle, [[[50,0], [150,100], [100,150], [0,50]]]).
points_dessin(bizarre3, [[[25,0], [175,0], [100,75], [0,75], [0,25]]]).
points_dessin(maison, [[[0,0], [100,0], [125,25], [25,125], [0,100]]]).
points_dessin(grange, [[[25,0], [75,0], [125,50], [50,125], [0,75], [0,25]]]).
points_dessin(brique, [[[50,0], [150,0], [175,25], [125,75], [25,75], [0,50]]]).