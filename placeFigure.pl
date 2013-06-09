:-module(placeFigure,[placeFigure/3]).
:-use_module(tools).
:-use_module(tangram).
:-use_module(pointIsInFigure).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Retourne les positions de la figure dans le Dessin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

placeFigure(Figure,Dessins,ReturnFigure):-
    test_placement_dessins_exact_match(Figure,Dessins,Placement),
    positionne(Figure,Placement,NewFigure),
    test_all_placement(NewFigure,Dessins,Placement,ReturnFigure).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Essaye de trouver un placement par longueur exacte
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test_placement_dessins_exact_match permet d'iteré tous les figures qui compose le dessin
test_placement_dessins_exact_match(_,[],_):-fail.
test_placement_dessins_exact_match(Figure,[Dessin|_],Placement):- 
    tools:aretes_figure(Dessin,AretesDessin), 
    test_aretes_dessin_exact_match(Figure,AretesDessin,Placement).
test_placement_dessins_exact_match(Figure,[_|Reste],Placement):- 
    test_placement_dessins_exact_match(Figure,Reste,Placement).

%test_aretes_dessin_exact_match permet pour chaque dessin d'itèré toutes les aretes 
test_aretes_dessin_exact_match(_,[],_):-fail.
test_aretes_dessin_exact_match(Figure,[Arete|_],Placement):-
    tools:aretes_figure(Figure,AretesFigure),
    test_figure_arete_dessin_exacte_match(AretesFigure,Arete,Placement).
test_aretes_dessin_exact_match(Figure,[_|Reste],Placement):-
    test_aretes_dessin_exact_match(Figure,Reste,Placement).

%test_figure_arete_dessin_exacte_match permet pour chaque arete du dessin d'itèré toutes les aretes de la figure à tester
test_figure_arete_dessin_exacte_match([],_,_):-fail.
test_figure_arete_dessin_exacte_match([_|ResteFigure],AreteDessin,Placement):-
    test_figure_arete_dessin_exacte_match(ResteFigure,AreteDessin,Placement).
test_figure_arete_dessin_exacte_match([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Positionne la figure par rapport à l'arete trouvé
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

positionne(PointFigure,[[[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewFigure2):-
    Ax is Pfx1 - Pox1, Ay is Pfy1 - Poy1,
    translate_figure(PointFigure,[Ax,Ay],NewFigure),
    find_angle([[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]],Angle),
    rotate_figure(NewFigure,[Pfx1,Pfy1],Angle,NewFigure2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Vérifie si la figure est valide par rapport au dessin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

test_all_placement(Figure,Dessins,_,Figure):-
    test_placement_dessins(Figure,Dessins),!.
test_all_placement(Figure,Dessins,[_,[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewFigure):-
    symetrie_figure(Figure,[[Pfx1,Pfy1],[Pfx2,Pfy2]],NewFigure),
    test_placement_dessins(NewFigure,Dessins),!.
test_all_placement(_,_,_,_):-fail.

test_placement_dessins(_,[]):-!.
test_placement_dessins(Figure,[Dessin|Reste]):-
    test_placement_dessins(Figure,Reste),
    test_placement_figure_dessin(Figure,Dessin),!.
test_placement_dessins(_,_):-fail.

test_placement_figure_dessin([],_):-!.
test_placement_figure_dessin([Point|Rest],Dessin):-
    test_placement_figure_dessin(Rest,Dessin),
    pointIsInFigure:pointIsInFigure(Point,Dessin,Result),
    Result == 1,!.
test_placement_figure_dessin(_,_):-fail.


