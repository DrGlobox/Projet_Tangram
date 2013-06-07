:- module(tools, [pow/3,distance/3,dernier/2,premier/2,aretes/2,aretes_dessin/2]).

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


