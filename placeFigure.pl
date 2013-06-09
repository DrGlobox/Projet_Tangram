:-module(placeFigure,[placeFigure/3]).
:-use_module(tools).
:-use_module(tangram).
:-use_module(pointIsInFigure).



%rotation_figure(Points, Origine, Angle, Points_tournes)
%   avec Points liste de point et Angle entier en radian et Points_tournes
rotation_figure([], _, _,[]):-!.
rotation_figure([Point|Reste], Origine, Angle,[Point_tourne|Retour]):-
    rotation_figure(Reste,Origine,Angle,Retour),
    rotation_point(Point,Origine,Angle,Point_tourne).

%rotation_point(Point, Origine,Angle,Point_tourne)
%   rotation du point Point d'angle Angle autour du centre Origin
rotation_point([Xp,Yp],[Xo,Yo],Angle,[Xr,Yr]):-
    % tools:distance([Xp,Yp],[Xo,Yo],D),
    CosAngle is cos(Angle), SinAngle is sin(Angle),
    Xcos is ((Xp-Xo)*CosAngle),
    Xsin is ((Xp-Xo)*SinAngle),
    Ycos is ((Yp-Yo)*CosAngle),
    Ysin is ((Yp-Yo)*SinAngle),
    Xrr is  Xcos - Ysin + Xo,Xr is round(Xrr),
    Yrr is  Xsin - Ycos + Yo,Yr is round(Yrr).


angleDegre(Radian, Degre):-
    Degre is (180 * (Radian / pi)).

find_angle([[Ptx1,Pty1],[Ptx2,Pty2]],[[Ptx3,Pty3],[Ptx4,Pty4]],Angle):-
    Vx1 is Ptx2 - Ptx1,
    Vy1 is Pty2 - Pty1,
    Vx2 is Ptx4 - Ptx3,
    Vy2 is Pty4 - Pty3,
    Numerateur is (Vx1 * Vx2) + (Vy1 * Vy2),
    tools:pow(Vx1,2,Vx1_2),
    tools:pow(Vx2,2,Vx2_2),
    tools:pow(Vy1,2,Vy1_2),
    tools:pow(Vy2,2,Vy2_2),
    V1 is Vx1_2 + Vy1_2,
    V2 is Vx2_2 + Vy2_2,
    Denominateur is sqrt(V1) * sqrt(V2),
    Div is Numerateur / Denominateur,
    Angle is acos(Div),!.



%translation_figure(+Figure,+Vecteur,-NouvelleFigure)
%   retourne les nouvelles coordonnées de la figure tranlaté par le vecteur
translation_figure([],_,[]).
translation_figure([[Pox,Poy]|Reste],[Ax,Ay],[[Ptx,Pty]|Resultat]):-
    translation_figure(Reste,[Ax,Ay],Resultat),
    Ptx is Pox + Ax, Pty is Poy + Ay.

polaire([X,Y],[Ox,Y],Teta,D):-
    X > Ox,!, Teta is 0,
    tools:distance([X,Y],[Ox,Y],D).
polaire([X,Y],[Ox,Y],Teta,D):-
    X < Ox,!, Teta is pi,
    tools:distance([X,Y],[Ox,Y],D).
polaire([X,Y],[Ox,Oy],Teta,D):-
    tools:distance([X,Y],[Ox,Oy],D),
    Nx is X - Ox, Ny is Y - Oy,
    Tmp is (Nx  + sqrt( (Nx*Nx) + (Ny*Ny) )),
    Teta is 2 * atan( Ny / Tmp).

unpolaire([X,Y],[Ox,Oy],Teta,D):-
    X is round(D * cos(Teta) + Ox),
    Y is round(D * sin(Teta) + Oy).


goodTeta(TetaB,TetaC,TetaNC):-
    TetaB > TetaC,!,
    TetaBC is TetaB - TetaC,
    TetaNC is TetaBC + TetaB.
goodTeta(TetaB,TetaC,TetaNC):-
    TetaBC is TetaC - TetaB,
    TetaNC is TetaB - TetaBC.


%symetrie(Point, Segment, NouveauPoint)
symetrie([Cx, Cy], [[Ax, Ay], [Bx, By]], [Nx, Ny]) :-
    polaire([Cx,Cy],[Ax,Ay],TetaC,AC),
    polaire([Bx,By],[Ax,Ay],TetaB,_),
    goodTeta(TetaB,TetaC,TetaNC),
    unpolaire([Nx,Ny],[Ax,Ay],TetaNC,AC).

%symetrie_figure(Figure,Axe,NouvelleFigure)
%   La méthode permet de retourné une figure par rapport à un axe
symetrie_figure([],_,[]).
symetrie_figure([[Px,Py]|Reste],[[Px,Py],[PBx,PBy]],[[Px,Py]|Resultat]):-
    symetrie_figure(Reste,[[Px,Py],[PBx,PBy]],Resultat),!.
symetrie_figure([[Px,Py]|Reste],[[PAx,PAy],[Px,Py]],[[Px,Py]|Resultat]):-
    symetrie_figure(Reste,[[PAx,PAy],[Px,Py]],Resultat),!.
symetrie_figure([[Px,Py]|Reste],[[PAx,PAy],[PBx,PBy]],[[Pnx,Pny]|Resultat]):-
    symetrie_figure(Reste,[[PAx,PAy],[PBx,PBy]],Resultat),
    symetrie([Px,Py],[[PAx,PAy],[PBx,PBy]],[Pnx,Pny]).

    

%la méthode permet de tester toutes les possibilités de position pour une figure
placeFigure(Figure,Dessins,ReturnFigure):-
    iter_dessin(Figure,Dessins,Placement),
    positionne(Figure,Placement,NewFigure),
    test_all_placement(NewFigure,Dessins,Placement,ReturnFigure).


test_all_placement(Figure,Dessins,_,Figure):-
    test_dessins(Figure,Dessins),!.
test_all_placement(Figure,Dessins,[_,[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewFigure):-
    symetrie_figure(Figure,[[Pfx1,Pfy1],[Pfx2,Pfy2]],NewFigure),
    test_dessins(NewFigure,Dessins),!.
test_all_placement(_,_,_,_):-fail.





positionne(PointFigure,[[[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewFigure2):-
    Ax is Pfx1 - Pox1, Ay is Pfy1 - Poy1,
    translation_figure(PointFigure,[Ax,Ay],NewFigure),
    find_angle([[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]],Angle),
    rotation_figure(NewFigure,[Pfx1,Pfy1],Angle,NewFigure2).

test_dessins(_,[]):-!.
test_dessins(Figure,[Dessin|Reste]):-
    test_dessins(Figure,Reste),
    test_point_figure(Figure,Dessin),!.
test_dessins(_,_):-fail.

test_point_figure([],_):-!.
test_point_figure([Point|Rest],Dessin):-
    test_point_figure(Rest,Dessin),
    pointIsInFigure:pointIsInFigure(Point,Dessin,Result),
    Result == 1,!.
test_point_figure(_,_):-fail.





%iter_dessin permet d'iteré tous les figures qui compose le dessin
iter_dessin(_,[],_):-fail.
iter_dessin(Figure,[Dessin|_],Placement):- 
    tools:aretes_figure(Dessin,AretesDessin), 
    iter_aretes_dessin(Figure,AretesDessin,Placement).
iter_dessin(Figure,[_|Reste],Placement):- 
    iter_dessin(Figure,Reste,Placement).

%iter_aretes_dessin permet pour chaque dessin d'itèré toutes les aretes 
iter_aretes_dessin(_,[],_):-fail.
iter_aretes_dessin(Figure,[Arete|_],Placement):-
    tools:aretes_figure(Figure,AretesFigure),
    iter_figure(AretesFigure,Arete,Placement).
iter_aretes_dessin(Figure,[_|Reste],Placement):-
    iter_aretes_dessin(Figure,Reste,Placement).

%iter_figure permet pour chaque arete du dessin d'itèré toutes les aretes de la figure à tester
iter_figure([],_,_):-fail.
iter_figure([_|ResteFigure],AreteDessin,Placement):-
    iter_figure(ResteFigure,AreteDessin,Placement).
iter_figure([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.


