:- module(tools, [pow/3,distance/3,dernier/2,avantDernier/2,premier/2,
                remove_last_point/2,aretes/2,aretes_pattern/2,
                membre/2,translate_piece/3,rotate_piece/4,find_angle/3,
                symetrie_piece/3,liste_all_couple_aretes/2,retourne_forme/3,
                ajout_fin/3,search_sens_forme/3,search_commmon_arete/3,
                remove_arete_patterns/3
                ]).

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
% la fonction retourne le dernier element de le liste
dernier([Dernier],Dernier):-!.
dernier([_|Reste],Dernier):-dernier(Reste,Dernier).


%avantDernier(+List,-AvantDernier)
% la fonction retourne l'avantDernier element de le liste
avantDernier([X,_],X):-!.
avantDernier([_|Reste],AvantDernier):-avantDernier(Reste,AvantDernier).

%premier(+List,-Premier)
% la fonction retourne le premier element de le liste
premier([Premier|_],Premier).

%remove_last_point(+Liste,-NewListe):-
% la fonction retourne la liste dans le dernier point
remove_last_point([_],[]).
remove_last_point([P|Reste],[P|Result]):-remove_last_point(Reste,Result).


%aretes_piece(+Piece,-Arete)
%   La fonction retoure la liste des aretes d'une piece
aretes([_],[]):-!.
aretes([T1,T2|Reste],[[T1,T2]|Aretes]):-aretes([T2|Reste],Aretes).
aretes_piece([T|Reste],[[T,D]|Aretes]):-aretes([T|Reste],Aretes),dernier([T|Reste],D).

%aretes_pattern(+Pattern,-Arretes)
%   La fonction retourne la liste de toutes les pieces qui composent le pattern
aretes_pattern([],[]).
aretes_pattern([Pattern|Reste],[Aretes|Resutat]):-aretes_pattern(Reste,Resutat), aretes_piece(Pattern,Aretes).

%membre(+Element, -Liste)
%redéfinit le prédicat member
membre(X,[X|_]):-!.
membre(X,[_|R]):-membre(X,R).

%rotate_piece(Points, Origine, Angle, Points_tournes)
%   avec Points liste de point et Angle entier en radian et Points_tournes
rotate_piece([], _, _,[]):-!.
rotate_piece([Point|Reste], Origine, Angle,[Point_tourne|Retour]):-
    rotate_piece(Reste,Origine,Angle,Retour),
    rotate_point(Point,Origine,Angle,Point_tourne).

%rotate_point(Point, Origine,Angle,Point_tourne)
%   rotation du point Point d'angle Angle autour du centre Origin
rotate_point([Xp,Yp],[Xo,Yo],Angle,[Xr,Yr]):-
    Sin is sin(Angle),Cos is cos(Angle),
    X is Xp - Xo, Y is Yp - Yo,
    Xrr is X * Cos - Y * Sin, Xr is round(Xrr+Xo),
    Yrr is X * Sin + Y * Cos, Yr is round(Yrr+Yo).

%getAngleDegre(+Radian, -Degre)
getAngleDegre(Radian, Degre):-
    Degre is (180 * (Radian / pi)).

%find_angle(+Arete1,+Arete2,-Angle)
% reçoit deux arêtes et retourne l'angle entre les deux
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



%translate_piece(+Piece,+Vecteur,-NouvellePiece)
%   retourne les nouvelles coordonnées de la piece tranlaté par le vecteur
translate_piece([],_,[]).
translate_piece([[Pox,Poy]|Reste],[Ax,Ay],[[Ptx,Pty]|Resultat]):-
    translate_piece(Reste,[Ax,Ay],Resultat),
    Ptx is Pox + Ax, Pty is Poy + Ay.

%polaire(+coord_cartésienne, +origine_cart, -Téta_polaire, -Dist_polaire)
%retourne les coordonnées polaires d'un point donné dans un repère cartésien
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

%unpolaire(-coord_cart, -origine_cart, +Téta_polaire, +Dist_polaire)
%retourne les coordonnées cartésiennes en fonction des coordonnées polaires
unpolaire([X,Y],[Ox,Oy],Teta,D):-
    X is round(D * cos(Teta) + Ox),
    Y is round(D * sin(Teta) + Oy).

%goodTeta(+TetaB, +TetaC, -TetaNC)
%choisit le bon angle parmis deux
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

%symetrie_piece(Piece,Axe,NouvellePiece)
%   La méthode permet de retourné une piece par rapport à un axe
symetrie_piece([],_,[]).
symetrie_piece([[Px,Py]|Reste],[[Px,Py],[PBx,PBy]],[[Px,Py]|Resultat]):-
    symetrie_piece(Reste,[[Px,Py],[PBx,PBy]],Resultat),!.
symetrie_piece([[Px,Py]|Reste],[[PAx,PAy],[Px,Py]],[[Px,Py]|Resultat]):-
    symetrie_piece(Reste,[[PAx,PAy],[Px,Py]],Resultat),!.
symetrie_piece([[Px,Py]|Reste],[[PAx,PAy],[PBx,PBy]],[[Pnx,Pny]|Resultat]):-
    symetrie_piece(Reste,[[PAx,PAy],[PBx,PBy]],Resultat),
    symetrie([Px,Py],[[PAx,PAy],[PBx,PBy]],[Pnx,Pny]).


%liste_all_couple_aretes(+AretesPattern,-CouplesAretes)
%à partir des arêtes d'une forme, retourne des couples d'arêtes
%rq: fonctione aussi pour retourner des couples de points à partir d'une forme
liste_all_couple_aretes(AretesPattern,CouplesAretes):-
    getListeCoupleAretes(AretesPattern,CouplesAretes).

getListeCoupleAretes(AretesPattern,[[Dernier,Premier]|ListeReturn]):-
    getCoupleAretes(AretesPattern,ListeReturn),
    premier(AretesPattern,Premier),dernier(AretesPattern,Dernier).

getCoupleAretes([Arete1,Arete2],[[Arete1,Arete2]]):-!.
getCoupleAretes([Arete1,Arete2|Rest],[[Arete1,Arete2]|ListeReturn]):-
    getCoupleAretes([Arete2|Rest],ListeReturn).



%find_good_axe_rotation(+Aretes1_pieces, +Aretes2_pieces, +Aretes1_pattern ,+Aretes2_pattern, -Angle)
%retourne l'angle entre les arêtes du modèle et de la piece si ils sont égaux
find_good_axe_rotation([[PtF1A1,PtF2A1],[PtF1A2,PtF2A2]],[[PtD1A1,PtD2A1],[PtD1A2,PtD2A2]],Angle):-
    distance(PtF1A1,PtF2A1,DF1), distance(PtF1A2,PtF2A2,DF2),
    distance(PtD1A1,PtD2A1,DD1), distance(PtD1A2,PtD2A2,DD2),
    DF1 =< DD1, DF2 =< DD2,!,
    find_angle([PtF1A1,PtF2A1],[PtD1A1,PtD2A1],Angle).
find_good_axe_rotation([[PtF1A1,PtF2A1],[PtF1A2,PtF2A2]],[[PtD1A1,PtD2A1],[PtD1A2,PtD2A2]],Angle):-
    distance(PtF1A1,PtF2A1,DF1), distance(PtF1A2,PtF2A2,DF2),
    distance(PtD1A1,PtD2A1,DD1), distance(PtD1A2,PtD2A2,DD2),
    DF1 =< DD2, DF2 =< DD1,!,
    find_angle([PtF1A1,PtF2A1],[PtD1A2,PtD2A2],Angle).
find_good_axe_rotation(_,_,0).


%find_common_point(+Arete1, +Arete2, -Point)
%cherche un point commun entre deux arêtes et le retourne s'il existe
find_common_point([[X,Y],[_,_]],[[X,Y],[_,_]],[X,Y]):-!.
find_common_point([[X,Y],[_,_]],[[_,_],[X,Y]],[X,Y]):-!.
find_common_point([[_,_],[X,Y]],[[X,Y],[_,_]],[X,Y]):-!.
find_common_point([[_,_],[X,Y]],[[_,_],[X,Y]],[X,Y]):-!.
find_common_point(_,_,[0,0]).


%retourne_forme(+PieceARetourner, +Sens, -PieceRetournee)
%retourne le sens de lecture de la forme (les arêtes)
retourne_forme(Piece,1,Piece):-!.
retourne_forme([],-1,[]):-!.
retourne_forme([[P1,P2]|Reste],-1,Result):-
    retourne_forme(Reste,-1,R),
    ajout_fin(R,[P2,P1],Result).


%ajout_fin(+Liste, +Element, +NewListe)
% ajoute un élément à la fin d'une liste
ajout_fin([],A,[A]):-!.
ajout_fin([T|Reste],A,[T|Result]):-
    ajout_fin(Reste,A,Result).


%search_sens_forme(+Forme,+Arete,-Sens)
%vérifie si l'arête est lue dans le même sens que la forme
search_sens_forme([A|_],Arete,Sens):-
    teste_aretes_egales(A,Arete),
    get_sens(A,Arete,Sens),!.
search_sens_forme([_|Reste],Arete,Sens):-
    search_sens_forme(Reste,Arete,Sens).

get_sens([P2,P1],[P2,P1],1):-!.
get_sens([P1,P2],[P2,P1],-1):-!.
get_sens(_,_,0):-fail.


teste_aretes_egales([P2,P1],[P2,P1]):-!.
teste_aretes_egales([P1,P2],[P2,P1]):-!.
teste_aretes_egales(_,_):-fail.


%search_commmon_arete(+Pattern,+Piece,-Arete)
%retourne une arête commune si elle existe
search_commmon_arete([Arete|_],Piece,Arete):-
    search_arete_in_forme(Arete,Piece),!.

search_commmon_arete([_|Reste],Piece,Arete):-
    search_commmon_arete(Reste,Piece,Arete).

    
search_arete_in_forme(_,[]):-!,fail.
search_arete_in_forme(Arete,[APiece|_]):-
    teste_aretes_egales(Arete,APiece),!.
search_arete_in_forme(Arete,[_|RPiece]):-
    search_arete_in_forme(Arete,RPiece),!.


%remove_arete_patterns(+Forme,+Arete,-NewForme)
%supprime une arête d'une forme
remove_arete_patterns(_,[],[]):-!.
remove_arete_patterns(A,[A|Reste],Reste):-!.
remove_arete_patterns(A,[B|Reste],[B|Result]):-
    remove_arete_patterns(A,Reste,Result).


