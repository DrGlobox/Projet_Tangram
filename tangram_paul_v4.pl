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


%pow(+Nombre,+Puissance,?Resultat).
%   eleve un nombre a la puissance désiré
pow(_,0,1).
pow(X,Y,Z) :- 
    Y1 is Y - 1, pow(X,Y1,Z1), Z is Z1*X.

%distance(+Point1,+Point2,?D) 
%   calcule la disance D entre 2 point 
distance([Xp,Yp],[Xo,Yo],D):-
    XoXp = Xo-Xp,pow(XoXp,2,XoXp2),
    YoYp = Yo-Yp,pow(YoYp,2,YoYp2),
    D is sqrt(XoXp2 + YoYp2),!.

%dernier(+List,-Dernier)
% la fonction retour le dernier element de le liste
dernier([Dernier],Dernier):-!.
dernier([_|Reste],Dernier):-dernier(Reste,Dernier).

%premier(+List,-Premier)
% la fonction retour le premier element de le liste
premier([Premier|_],Premier).

%aretes_figure(+Figure,-Arete)
%   La fonction retoure la liste des aretes d'une figure
aretes([_],[]):-!.
aretes([T1,T2|Reste],[[T1,T2]|Aretes]):-aretes([T2|Reste],Aretes).
aretes_figure([T|Reste],[[T,D]|Aretes]):-aretes([T|Reste],Aretes),dernier([T|Reste],D).

%aretes_dessin(+Dessin,-Arretes)
%   La fonction retourne la liste de toutes les figures qui composent le dessin
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

%translation_figure(+Figure,+Vecteur,-NouvelleFigure)
%   retourne les nouvelles coordonnées de la figure tranlaté par le vecteur
%points_figure(gros_triangle,T),translation_figure(T,[1,1],N).
translation_figure([],_,[]).
translation_figure([[Pox,Poy]|Reste],[Ax,Ay],[[Ptx,Pty]|Resultat]):-
    translation_figure(Reste,[Ax,Ay],Resultat),
    Ptx is Pox + Ax, Pty is Poy + Ay.


%symetrie_figure(Figure,Axe,NouvelleFigure)
%   La méthode permet de retourné une figure par rapport à un axe
symetrie_figure([],_,[]).
symetrie_figure([[Px,Py]|Reste],[[PAx,PAy],[PBx,PBy]],[[Pnx,Pny]|Resultat]):-
    symetrie_figure(Reste,[[PAx,PAy],[PBx,PBy]],Resultat),
    POx = (PAx + PBx)/2.0, POy = (PAy + PBy)/2.0,
    Pnx =  POy - Py, Pny = POx - Px.
    



%La fonction sens placement retour le sens de la figure 
% -1 est le sens symétrique
%  1 est le sens normale 
sensPlacement([_],[],0):-!.
sensPlacement(Placement,[_|Reste],Result):-
    sensPlacement(Placement,Reste,Result), Result =\= 0,!.
sensPlacement([_,Arete],[Dessin|_],Result):-
    sensPlacement2(Arete,Dessin,Result),Result =\= 2,!.
sensPlacement([_,[_,Po]],[[Pn|_]|_],Result):-
    sensPlacement3(Po,Pn,Result).

sensPlacement2(_,[_],2):-!.
sensPlacement2([_,Po],[Po,Pn|_],Result):-!,
    sensPlacement3(Po,Pn,Result).
sensPlacement2(Arete,[_|Reste],Result):-
    sensPlacement2(Arete,Reste,Result).

sensPlacement3([X1,_],[X2,_],1):- X1 < X2,!.
sensPlacement3([X1,_],[X2,_],-1):- X1 > X2,!.
sensPlacement3([_,Y1],[_,Y2],1):- Y1 < Y2,!.
sensPlacement3([_,Y1],[_,Y2],-1):- Y1 > Y2,!.
     

%Le predicat retour une liste composé de l'arete et du placement interessant
%points_figure(gros_triangle,Triangle),points_dessin(carre,Carre),teste_figure(Triangle,Carre,Placement).


%la méthode permet de tester toutes les possibilités de position pour une figure
teste_figure(Figure,Dessins,Placement):-
    iter_dessin(Figure,Dessins,Placement).
    %points_dessin(Dessins,PointDessins),
    %sensPlacement(Placement,PointDessins,Sens),
    %place_figure(Figure,Placement,NewFigure).


%La méthode permet de placer une figure par rapport à un placement reçut
place_figure(PointFigure,[[[Pox,Poy],_],[[Pfx,Pfy],_]],NewPointFigure):-
    Ax is Pfx - Pox, Ay is Pfy - Poy,
    translation_figure(PointFigure,[Ax,Ay],NewPointFigure).


%iter_dessin permet d'iteré tous les figures qui compose le dessin
iter_dessin(_,[],_).
iter_dessin(Figure,[Dessin|_],Placement):- 
    aretes_figure(Dessin,AretesDessin), 
    iter_aretes_dessin(Figure,AretesDessin,Placement).
iter_dessin(Figure,[_|Reste],Placement):- 
    iter_dessin(Figure,Reste,Placement).
%iter_aretes_dessin permet pour chaque dessin d'itèré toutes les aretes 
iter_aretes_dessin(_,[],_).
iter_aretes_dessin(Figure,[Arete|_],Placement):-
    aretes_figure(Figure,AretesFigure),
    iter_figure(AretesFigure,Arete,Placement).
iter_aretes_dessin(Figure,[_|Reste],Placement):-
    iter_aretes_dessin(Figure,Reste,Placement).
%iter_figure permet pour chaque arete du dessin d'itèré toutes les aretes de la figure à tester
iter_figure([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.
iter_figure([_|ResteFigure],AreteDessin,Placement):-
    iter_figure(ResteFigure,AreteDessin,Placement).

