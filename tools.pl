:- module(tools, [pow/3,distance/3,dernier/2,premier/2,aretes/2,aretes_dessin/2,
                  membre/2,translate_figure/3,rotate_figure/4,find_angle/3,
                  symetrie_figure/3,liste_all_couple_aretes/2
                 ]
         ).

:- (   stream_property(user_output, tty(true))
   ->  load_files(library(ansi_term), [silent(true)])
   ;   true).

%pow(+Nombre,+Puissance,?Resultat).
%   eleve un nombre a la puissance désiré
pow(_,0,1):-!.
pow(X,Y,Z) :- 
    Y1 is Y - 1, pow(X,Y1,Z1), Z is Z1*X.

%distance(+Point1,+Point2,?D) 
%   calcule la distance D entre 2 point 
distance([Xp,Yp],[Xo,Yo],D):-
	D is sqrt( (Xo - Xp)**2 + (Yo - Yp)**2 ), !.

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

membre(X,[X|_]):-!.
membre(X,[_|R]):-membre(X,R).

%rotate_figure(Points, Origine, Angle, Points_tournes)
%   avec Points liste de point et Angle entier en radian et Points_tournes
rotate_figure([], _, _,[]):-!.
rotate_figure([Point|Reste], Origine, Angle,[Point_tourne|Retour]):-
    rotate_figure(Reste,Origine,Angle,Retour),
    rotate_point(Point,Origine,Angle,Point_tourne).

%rotate_point(Point, Origine,Angle,Point_tourne)
%   rotation du point Point d'angle Angle autour du centre Origin
rotate_point([Xp,Yp],[Xo,Yo],Angle,[Xr,Yr]):-
    CosAngle is cos(Angle), SinAngle is sin(Angle),
    Xcos is ((Xp-Xo)*CosAngle),
    Xsin is ((Xp-Xo)*SinAngle),
    Ycos is ((Yp-Yo)*CosAngle),
    Ysin is ((Yp-Yo)*SinAngle),
    Xrr is  Xcos - Ysin + Xo,Xr is round(Xrr),
    Yrr is  Xsin - Ycos + Yo,Yr is round(Yrr).


getAngleDegre(Radian, Degre):-
    Degre is (180 * (Radian / pi)).

find_angle([[Ptx1,Pty1],[Ptx2,Pty2]],[[Ptx3,Pty3],[Ptx4,Pty4]],Angle):-
    Vx1 is Ptx2 - Ptx1,
    Vy1 is Pty2 - Pty1,
    Vx2 is Ptx4 - Ptx3,
    Vy2 is Pty4 - Pty3,
    Numerateur is (Vx1 * Vx2) + (Vy1 * Vy2),
    pow(Vx1,2,Vx1_2),
    pow(Vx2,2,Vx2_2),
    pow(Vy1,2,Vy1_2),
    pow(Vy2,2,Vy2_2),
    V1 is Vx1_2 + Vy1_2,
    V2 is Vx2_2 + Vy2_2,
    Denominateur is sqrt(V1) * sqrt(V2),
    Div is Numerateur / Denominateur,
    Angle is acos(Div),!.



%translate_figure(+Figure,+Vecteur,-NouvelleFigure)
%   retourne les nouvelles coordonnées de la figure tranlaté par le vecteur
translate_figure([],_,[]).
translate_figure([[Pox,Poy]|Reste],[Ax,Ay],[[Ptx,Pty]|Resultat]):-
    translate_figure(Reste,[Ax,Ay],Resultat),
    Ptx is Pox + Ax, Pty is Poy + Ay.

polaire([X,Y],[Ox,Y],Teta,D):-
    X > Ox,!, Teta is 0,
    distance([X,Y],[Ox,Y],D).
polaire([X,Y],[Ox,Y],Teta,D):-
    X < Ox,!, Teta is pi,
    distance([X,Y],[Ox,Y],D).
polaire([X,Y],[Ox,Oy],Teta,D):-
    distance([X,Y],[Ox,Oy],D),
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





liste_all_couple_aretes(AretesDessin,CouplesAretes):-
    getListeCoupleAretes(AretesDessin,CouplesAretes).

getListeCoupleAretes(AretesDessin,[[Dernier,Premier]|ListeReturn]):-
    getCoupleAretes(AretesDessin,ListeReturn),
    premier(AretesDessin,Premier),dernier(AretesDessin,Dernier).

getCoupleAretes([Arete1,Arete2],[Arete1,Arete2]):-!.
getCoupleAretes([Arete1,Arete2|Rest],[[Arete1,Arete2]|ListeReturn]):-
    getCoupleAretes([Arete2|Rest],ListeReturn).


