:-use_module(tools).
:-use_module(tangram).

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
    

%Le predicat retour une liste composé de l'arete et du placement interessant
%points_figure(gros_triangle,Triangle),points_dessin(carre,Carre),teste_figure(Triangle,Carre,Placement).


%la méthode permet de tester toutes les possibilités de position pour une figure
teste_figure(Figure,Dessins,Placement):-
    iter_dessin(Figure,Dessins,Placement).


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
iter_figure([_|ResteFigure],AreteDessin,Placement):-
    iter_figure(ResteFigure,AreteDessin,Placement).
iter_figure([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.

