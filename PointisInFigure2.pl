:- module(pointIsInFigure, [pointIsInFigure/3]).

%pointIsInFigure(Point,Points,FinalOdd):- 
%           Point = [X,Y]
%           Points = List of Point
%           FinalOdd = Boolean
pointIsInFigure(Point,Points,FinalOdd):- 
    nbPoint(Points,Nb),
    J is Nb-1,
    Odd is 0,
    iterate(0,Nb,J,Point,Points,Odd,FinalOdd)
    .


iterate(Nb,Nb,_,_,_,Odd,Odd):-!.
iterate(I,Nb,J,[X,Y],Points,Odd,FinalOdd):-
    pointAt(Points,I,Xi,Yi),
    pointAt(Points,J,Xj,Yj),
    test12(X,Y,Xi,Yi,Xj,Yj,Res),
    Res == 1,!,
    calculOdd(X,Y,Xi,Yi,Xj,Yj,Odd,NewOdd),
    J1 is I,
    I1 is I +1,
    iterate(I1,Nb,J1,[X,Y],Points,NewOdd,FinalOdd).
iterate(I,Nb,_,[X,Y],Points,Odd,FinalOdd):-
    J1 is I,
    I1 is I +1,
    iterate(I1,Nb,J1,[X,Y],Points,Odd,FinalOdd).


test12(X,Y,Xi,Yi,Xj,Yj,1):-
    test1(Y,Yi,Yj),
    test2(X,Xi,Xj),!.
test12(_,_,_,_,_,0).

test1(Y, Yi, Yj):- Yi < Y, Yj >= Y,!.
test1(Y, Yi, Yj):- Yj < Y, Yi >= Y.

test2(X, Xi, _):- Xi =< X,!.
test2(X, _, Xj):- Xj =< X.




calculOdd(X,Y,Xi,Yi,Xj,Yj,Odd,NewOdd):-
    calculTmp(X,Y,Xi,Yi,Xj,Yj,Tmp),
    calculBoolTmp(X,Tmp,BoolTmp),
    NewOdd is Odd xor BoolTmp.


calculTmp(_,Y,Xi,Yi,Xj,Yj,Tmp):-
    Tmp is Xi + (Y-Yi)/(Yj-Yi) * (Xj-Xi).

calculBoolTmp(X,Tmp,1):-
    Tmp < X,!.
calculBoolTmp(_,_,0).

pointAt([[X,Y]|_],0,X,Y):-!.
pointAt([_|Rest],M,X,Y):-
    M1 is M-1, pointAt(Rest,M1,X,Y).

nbPoint([], 0) :- !.
nbPoint([_|Rest], Result1) :-
    nbPoint(Rest, Result), 
    Result1 is Result+1.
