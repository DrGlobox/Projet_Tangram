
%figure(?F) avec f : expression représentant une figure existante
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

%figures_tangram(-L): avec L : liste des figures disponible pour résoudre le tagram
%figures_tangram([gros_triangle,gros_triangle,parallelogramme,carre,moyen_triangle,petit_triangle,petit_triangle]).
figures_tangram([petit_triangle,petit_triangle,moyen_triangle,carre,parallelogramme,gros_triangle,gros_triangle]).


%dessin(?D) avec D : expression représentant les dessin existant
%                   Attention les dessin sont une liste de liste de figure 
dessin(dessin_carre).
points_dessin(dessin_carre,  [[[0,0] ,[100,0] ,[100,100] ,[0,100]]]).


%solve_tangram
solve_tangram(Nom_Dessin,Result):- 
    points_dessin(Nom_Dessin,Points_dessin), % on récupère la figure du dessins
    figures_tangram(Figures),                % on récupère la liste des figures
    iter_figures(Figures,Points_dessin,Result,[]). % on lance l'iteration des figures

%iter_figures(Figures,Points_dessin,Result,Position_Essayee) avec Figures Liste de figures 
%                                                Points_dessin Liste de points
%                                                Result Liste de Liste de points
%                                                Position_Essayee Liste des position essayées
iter_figures([],_,[],[]).
%On itère sans problème jusqu'en bas de la liste et on essaye de placer chaque figure
iter_figures([Figure|Rest],Dessin,[Position|Result],[]):-!,
    iter_figures(Rest,Dessin,Result,[]), 
    place_figure(Figure,Dessin,Result,[]).

%Il y a un problème il n'y a pas de position possible pour la suite, 
% on revient en arrière en prévenant des position connu
iter_figures([Figure|Rest],Dessin,[Position|Result],[Position_Figures|Positions_Rest]).


%tente de placer la figure dans le dessin en ne reproduisant pas les Positions existante
place_figure(Figure,Dessin,Result,Positions).

