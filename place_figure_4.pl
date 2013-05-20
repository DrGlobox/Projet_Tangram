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

%rotation_figure(Points, Origine, Angle, Points_tournes)
%                   avec Points liste de point et Angle entier en radian et Points_tournes
%                   le prédicat execute une rotation Angle sur la figures représenter par Point par
%                   rapport a son point Origine
rotation_figure([], _, _,[]):-!.

rotation_figure([Origine|Reste], Origine, Angle,[Origine|Retour]):- 
    !, rotation_figure(Reste,Origine,Angle,Retour).

rotation_figure([Point|Reste], Origine, Angle,[Point_tourne|Retour]):-
    rotation_figure(Reste,Origine,Angle,Retour),
    rotation_point(Point,Origine,Angle,Point_tourne).


%rotation_point(Point, Origine,Angle,Point_tourne)
%                   rotation du point Point d'angle Angle autour du centre Origin
rotation_point([Xp,Yp],[Xo,Yo],Angle,[Xr,Yr]):-
    distance([Xp,Yp],[Xo,Yo],D),
    CosAngle is cos(Angle), SinAngle is sin(Angle),
    Xr is (D*CosAngle+ Xo),
    Yr is (D*SinAngle+ Yo).


%points_figure(gros_triangle,T),translation_figure(T,[1,1],N).
translation_figure([],_,[]).
translation_figure([[Pox,Poy]|Reste],[Ax,Ay],[[Ptx,Pty]|Resultat]):-
    translation_figure(Reste,[Ax,Ay],Resultat),
    Ptx is Pox + Ax, Pty is Poy + Ay.


%%%%A COMPLETER
symetrie_figure([],_,[]).
symetrie_figure([Po|Reste],[Po,Po2],[Po|Resultat]):-
    !,symetrie_figure(Reste,[Po,Po2],Resultat).
symetrie_figure([Po|Reste],[Po2,Po],[Po|Resultat]):-
    !,symetrie_figure(Reste,[Po2,Po],Resultat).
symetrie_figure([Point|Reste],[Po1,Po2],[Po|Resultat]).



%faire le cas avec une symétrie axiale
place_figure(PointFigure,[[[Pox,Poy],_],[[Pfx,Pfy],_]],NewPointFigure):-
    Ax is Pfx - Pox, Ay is Pfy - Poy,write(Ax),write(Ay),
    translation_figure(PointFigure,[Ax,Ay],NewPointFigure).

%place_figure([Po|Reste],[[[Pox,Poy],_],[[Pfx,Pfy],_]],NewPointFigure):-
%    Ax is Pfx - Pox, Ay is Pfy - Poy,
%    rotation_figure([Po|Reste],Po,pi,PointFigure),
%    translation_figure(PointFigure,[Ax,Ay],NewPointFigure).







%Le predicat retour une liste composé de l'arete et du placement interessant
%points_figure(gros_triangle,Triangle),points_dessin(carre,Carre),teste_figure(Triangle,Carre,Placement).
teste_figure(Figure,Dessins,Placement):-
    iter_dessin(Figure,Dessins,Placement).

iter_dessin(_,[],_).
iter_dessin(Figure,[Dessin|_],Placement):- 
    aretes_figure(Dessin,AretesDessin), 
    iter_aretes_dessin(Figure,AretesDessin,Placement).
iter_dessin(Figure,[_|Reste],Placement):- 
    iter_dessin(Figure,Reste,Placement).

iter_aretes_dessin(_,[],_).
iter_aretes_dessin(Figure,[Arete|_],Placement):-
    aretes_figure(Figure,AretesFigure),
    iter_figure(AretesFigure,Arete,Placement).
iter_aretes_dessin(Figure,[_|Reste],Placement):-
    iter_aretes_dessin(Figure,Reste,Placement).

iter_figure([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.
iter_figure([_|ResteFigure],AreteDessin,Placement):-
    iter_figure(ResteFigure,AreteDessin,Placement).
















