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
dessin(carre).
points_dessin(carre,  [[[0,0] ,[100,0] ,[100,100] ,[0,100]]]).


%pow(Nombre,Puissance,Resultat).
pow(_,0,1).
pow(X,Y,Z) :- 
    Y1 is Y - 1, pow(X,Y1,Z1), Z is Z1*X.

%distance(Point1,Point2,D) calcule la disance D entre 2 point 
distance([Xp,Yp],[Xo,Yo],D):-
    XoXp = Xo-Xp,pow(XoXp,2,XoXp2),
    YoYp = Yo-Yp,pow(YoYp,2,YoYp2),
    D is sqrt(XoXp2 + YoYp2),!.

%liste_aretes(Figure,Liste) retourne la liste des aretes de la figures
dernier([Dernier],Dernier):-!.
dernier([_|Reste],Dernier):-dernier(Reste,Dernier).

aretes([_],[]):-!.
aretes([T1,T2|Reste],[[T1,T2]|Aretes]):-aretes([T2|Reste],Aretes).
aretes_figure([T|Reste],[[T,D]|Aretes]):-aretes([T|Reste],Aretes),dernier([T|Reste],D).

aretes_dessin([],[]).
aretes_dessin([Dessin|Reste],[Aretes|Resutat]):-aretes_dessin(Reste,Resutat), aretes_figure(Dessin,Aretes).
