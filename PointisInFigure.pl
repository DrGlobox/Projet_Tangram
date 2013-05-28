%exemple d'utilisation :
% Dessin = [[1,1],[102,2],[103,103],[4,104]],pointIsInFigure(10,10,Dessin,R).
% Dessin = [[1,1],[102,2],[103,103],[4,104]],pointIsInFigure(-10,10,Dessin,R).




pointIsInFigure(Ax,Ay,Points,Result):-
    nbPoint(Points,NbPoints),
    testPointInFigure(Ax,Ay,Points,NbPoints,0,0,FinalCross),
    Modulo is FinalCross mod 2,
    testModulo(Modulo,Result).

testPointInFigure(_,_,_,NbPoints,Ctrl,Cross,Cross):-
    Ctrl >= NbPoints,!.
testPointInFigure(Ax,Ay,Points,NbPoints,Ctrl,Cross,NewCross):-
    pointAt(Points,Ctrl,[Xl,Yl]),
    nextI(Ctrl,NbPoints,Ctrl1),
    pointAt(Points,Ctrl1,[Xr,Yr]),
    testIfMatched(Ax,Ay,Xl,Yl,Xr,Yr,Cross,Ctrl,TmpCross,NewCtrl),
    testPointInFigure(Ax,Ax,Points,NbPoints,NewCtrl,TmpCross,NewCross).
    

nextI(Ctrl,NbPoints,NewCtrl):-
    Ctrl1 is Ctrl + 1, Ctrl1 < NbPoints,!, NewCtrl is Ctrl1.
nextI(Ctrl,NbPoints,NewCtrl):-
    Ctrl1 is Ctrl + 1, NewCtrl is NbPoints - Ctrl1.


pointAt([Point|_],0,Point):-!.
pointAt([_|Rest],I,Point):-
    I1 is I-1, pointAt(Rest,I1,Point).

testModulo(0,1):-!.
testModulo(_,0).

testIfMatched(Ax,Ay,Xl,Yl,Xr,Yr,Cross,Ctrl,NewCross,NewCtrl):-
    test1(Ax,Xl,Xr,Ctrl,Ctrl1),
    test2(Ax,Xl,Xr,Ctrl1,Ctrl2),
    test3(Ay,Yl,Yr,Ctrl2,Ctrl3),
    test4(Ay,Ax,Xl,Yl,Xr,Yr,Ctrl3,Ctrl4,Cross,Cross4),
    test5(Xl,Yl,Xr,Yr,Xl5,Yl5,Xr5,Yr5),
    calculYc(Yl5,Xl5,Yr5,Xr5,Ax,Yc),
    test6(Ay,Yc,Cross4,NewCross),
    NewCtrl is Ctrl4+1.

test1(Ax,Xl,Xr,Ctrl,NewCtrl):- 
    Xl < Ax, Xr < Ax,!,NewCtrl is Ctrl+1.
test1(_,_,_,Ctrl,Ctrl).

test2(Ax,Xl,Xr,Ctrl,NewCtrl):- 
    Xl > Ax, Xr > Ax,!,NewCtrl is Ctrl+1.
test2(_,_,_,Ctrl,Ctrl).

test3(Ay,Yl,Yr,Ctrl,NewCtrl):- 
    Yl < Ay, Yr < Ay,!,NewCtrl is Ctrl+1.
test3(_,_,_,Ctrl,Ctrl).

test4(Ay,Ax,Xl,Yl,Xr,Yr,Ctrl,NewCtrl,Cross,NewCross):-
    Yl > Ay, Yr > Ay, ((Xl > Ax);(Xr > Ax)),!,
    NewCtrl is Ctrl+1,NewCross is Cross+1.
test4(_,_,_,_,_,_,Ctrl,Ctrl,Cross,Cross).

test5(Xl,Yl,Xr,Yr,NewXl,NewYl,NewXr,NewYr):- 
    Xl > Xr,!,
    NewXl is Xr, NewXr is Xl, NewYl is Yr, NewYr is Yl. 
test5(Xl,Yl,Xr,Yr,Xl,Yl,Xr,Yr).

test6(Ay,Yc,Cross,Cross1):-
    Yc > Ay,!, Cross1 is Cross+1.
test6(_,_,Cross,Cross).

calculYc(Yl,Xl,Yr,Xr,Ax,Yc):-
    Yc is Yl + (((Yr - Yl) / (Xr - Xl)) * (Ax - Xl)).

nbPoint([],0):-!.
nbPoint([_|Rest],Result1):-
    nbPoint(Rest,Result), 
    Result1 is Result+1.
