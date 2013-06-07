% Exemples d'utilisation :
% Dessin = [[1,1],[102,2],[103,103],[4,104]],pointIsInFigure(10,10,Dessin,R).
% Dessin = [[1,1],[102,2],[103,103],[4,104]],pointIsInFigure(-10,10,Dessin,R).

% Exportation du prédicat pointIsInFigure
:- module(pointIsInFigure, [pointIsInFigure/4]).

% Prédicat pointIsInFigure(+Ax, +Ay, +L, ?R).
% Compte le nombre de points dans la liste L,
% Vérifie si le point A(Ax, Ay) est dans la figure dessinée par les points dans L
% Renvoie 1 ou 0 suivant si le point est dedans ou non
pointIsInFigure(Ax, Ay, Points, Result) :-
    nbPoint(Points, NbPoints),
    testPointInFigure(Ax, Ay, Points, NbPoints, 0, 0, FinalCross),
    Modulo is FinalCross mod 2,
    testModulo(Modulo, Result).

% Prédicat testPointInFigure
testPointInFigure(_, _, _, NbPoints, Ctrl, Cross, Cross) :-
    Ctrl >= NbPoints, !.
testPointInFigure(Ax, Ay, Points, NbPoints, Ctrl, Cross, NewCross) :-
    pointAt(Points, Ctrl, [Xl, Yl]),
    nextI(Ctrl, NbPoints, Ctrl1),
    pointAt(Points, Ctrl1, [Xr, Yr]),
    testIfMatched(Ax, Ay, Xl, Yl, Xr, Yr, Cross, Ctrl, TmpCross, NewCtrl),
    testPointInFigure(Ax, Ax, Points, NbPoints, NewCtrl, TmpCross, NewCross).

% Prédicat nextI(+I, +N, ?J).
% Permet d'avoir une incrémentation ou décrémentation de I selon N
% Si I++ < N alors J = I++
% Sinon J = N - I++
nextI(Ctrl,NbPoints,NewCtrl) :-
    Ctrl1 is Ctrl + 1, Ctrl1 < NbPoints, !, NewCtrl is Ctrl1.
nextI(Ctrl,NbPoints,NewCtrl) :-
    Ctrl1 is Ctrl + 1, NewCtrl is NbPoints - Ctrl1.

% Prédicat pointAt(+L, ?N, ?R).
% Sélectionne un point R à la position N dans la liste L
pointAt([Point|_], 0, Point) :- !.
pointAt([_|Rest], I, Point) :-
    I1 is I-1, pointAt(Rest, I1, Point).

% Prédicat testModulo(+A, ?B).
% B = 1 si A = 0, sinon B = 0
testModulo(0, 1) :-!.
testModulo(_, 0).

% Prédicat testIfMatched()
% On vérifie pendant plusieurs tests que le point A(Ax, Ay) n'est pas  
% aligné avec le point L(Xl, Yl) et le point R(Xr, Yr).
testIfMatched(Ax, Ay, Xl, Yl, Xr, Yr, Cross, Ctrl, NewCross, NewCtrl) :-
    test1(Ax, Xl, Xr, Ctrl, Ctrl1),
    test2(Ax, Xl, Xr, Ctrl1, Ctrl2),
    test3(Ay, Yl, Yr, Ctrl2, Ctrl3),
    test4(Ay, Ax, Xl, Yl, Xr, Yr, Ctrl3, Ctrl4, Cross, Cross4),
    test5(Xl, Yl, Xr, Yr, Xl5, Yl5, Xr5, Yr5),
    calculYc(Yl5, Xl5, Yr5, Xr5, Ax, Yc),
    test6(Ay, Yc, Cross4, NewCross),
    NewCtrl is Ctrl4+1.

% Prédicats test[1|2|3](+A, +L, +R, +I, ?J).
% Vérifient que L et R [<|>] A, dans quel cas J = I++
% Sinon J = I
test1(Ax, Xl, Xr, Ctrl, NewCtrl) :- 
    Xl < Ax, Xr < Ax, !, NewCtrl is Ctrl+1.
test1(_, _, _, Ctrl, Ctrl).

test2(Ax, Xl, Xr, Ctrl, NewCtrl) :- 
    Xl > Ax, Xr > Ax, !, NewCtrl is Ctrl+1.
test2(_, _, _, Ctrl, Ctrl).

test3(Ay, Yl, Yr, Ctrl, NewCtrl) :- 
    Yl < Ay, Yr < Ay, !, NewCtrl is Ctrl+1.
test3(_, _, _, Ctrl, Ctrl).

% Prédicat test4
% Semblable aux précédents, avec une condition en plus sur les X
test4(Ay, Ax, Xl, Yl, Xr, Yr, Ctrl, NewCtrl, Cross, NewCross) :-
    Yl > Ay, Yr > Ay, 
		((Xl > Ax);(Xr > Ax)), !,
    NewCtrl is Ctrl+1, NewCross is Cross+1.
test4(_, _, _, _, _, _, Ctrl, Ctrl, Cross, Cross).

% Prédicat test5
% Si Xl > Xr, on swap les points R et L
% Sinon pas de swap
% Permet de vérifier quel point est le plus à droite/gauche
test5(Xl, Yl, Xr, Yr, NewXl, NewYl, NewXr, NewYr) :- 
    Xl > Xr, !,
    NewXl is Xr, NewXr is Xl, 
		NewYl is Yr, NewYr is Yl. 
test5(Xl, Yl, Xr, Yr, Xl, Yl, Xr, Yr).

% Prédicat test6
test6(Ay, Yc, Cross, Cross1) :-
    Yc > Ay, !, Cross1 is Cross+1.
test6(_, _, Cross, Cross).

% Prédicat calculYc(+Yl, +Xl, +Yr, +Xr, +Ax, ?Yc).
% Calcule la valeur de Yc
calculYc(_, X, _, X, _, 99999):-!.
calculYc(Yl, Xl, Yr, Xr, Ax, Yc) :-
    Yc is Yl + (((Yr - Yl) / (Xr - Xl)) * (Ax - Xl)).

% Prédicat nbPoint(+L, ?N).
% Calcule le nombre de points N composant la liste L
nbPoint([], 0) :- !.
nbPoint([_|Rest], Result1) :-
    nbPoint(Rest, Result), 
    Result1 is Result+1.
