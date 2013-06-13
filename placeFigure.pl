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
write(Dessins), nl,
    test_placement_dessins_exact_match(Figure,Dessins,Placement),
    positionne(Figure,Placement,NewFigure),
    test_all_placement(NewFigure,Dessins,Placement,ReturnFigure).
placeFigure(Figure,Dessins,ReturnFigure):-
write(Dessins), nl,
    test_placement_dessins_angle_match(Figure,Dessins,Placement),
    positionne(Figure,Placement,[Axe1,Axe2],NewFigure),
    test_placement(NewFigure,Dessins,[Axe1,Axe2],ReturnFigure).

test_placement(NewFigure,Dessins,[Axe1,_],ReturnFigure):-
    test_all_placement(NewFigure,Dessins,[[],Axe1],ReturnFigure),!.
test_placement(NewFigure,Dessins,[_,Axe2],ReturnFigure):-
    test_all_placement(NewFigure,Dessins,[[],Axe2],ReturnFigure).


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
%     Essaye de trouver un placement par angle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test_placement_dessins_exact_match permet d'iteré tous les figures qui compose le dessin
test_placement_dessins_angle_match(_,[],_):-fail.
test_placement_dessins_angle_match(Figure,[Dessin|_],Placement):- 
    tools:aretes_figure(Dessin,AretesDessin), 
    tools:aretes_figure(Figure,AretesFigure), 
    tools:liste_all_couple_aretes(AretesDessin,CouplesAretesDessin),
    tools:liste_all_couple_aretes(AretesFigure,CouplesAretesFigure),
    test_aretes_dessin_angle_match(CouplesAretesFigure,CouplesAretesDessin,Placement).
test_placement_dessins_angle_match(Figure,[_|Reste],Placement):- 
    test_placement_dessins_angle_match(Figure,Reste,Placement).

test_aretes_dessin_angle_match(_,[],_):-fail.
test_aretes_dessin_angle_match(CouplesAretesFigure,[CoupleAretesDessin|_],Placement):-
    test_figure_arete_dessin_angle_match(CouplesAretesFigure,CoupleAretesDessin,Placement).
test_aretes_dessin_angle_match(CouplesAretesFigure,[_|ResteCouple],Placement):-
    test_aretes_dessin_angle_match(CouplesAretesFigure,ResteCouple,Placement).

test_figure_arete_dessin_angle_match([],_,_):-fail.
test_figure_arete_dessin_angle_match([CoupleAretesFigure|_],CoupleAretesDessin,Placement):-
    test_couple_angle_match(CoupleAretesFigure,CoupleAretesDessin,Placement).
test_figure_arete_dessin_angle_match([_|ResteCouple],CoupleAretesDessin,Placement):-
    test_figure_arete_dessin_angle_match(ResteCouple,CoupleAretesDessin,Placement).

test_couple_angle_match([AreteF1,AreteF2],[AreteD1,AreteD2],[[AreteF1,AreteF2],[AreteD1,AreteD2]]):-
    tools:find_angle(AreteF1,AreteF2,Angle),
    tools:find_angle(AreteD1,AreteD2,Angle),
    test_combinaison_placement([AreteF1,AreteF2],[AreteD1,AreteD2]),!.
test_couple_angle_match(_,_,_):-fail.

test_combinaison_placement([[PF1,PF2],[PF3,PF4]],[[PD1,PD2],[PD3,PD4]]):-
    tools:distance(PF1,PF2,DF1_2),
    tools:distance(PD1,PD2,DD1_2),
    tools:distance(PF3,PF4,DF3_4),
    tools:distance(PD3,PD4,DD3_4),
    (DF1_2 < DD1_2, DF3_4 < DD3_4 ;
     DF3_4 < DD1_2, DF1_2 < DD3_4 ),!.
test_combinaison_placement(_,_):-fail.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Positionne la figure par rapport à l'arete trouvé
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


positionne(PointFigure,[
                        [[[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],%pt 1 et 2 de l arrete num 1 Figure
                        [[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]]],
                        [[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],%pt 1 et 2 de l arrete num 1 Dessin
                        [[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]]]
                       ],
                       [[[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]],[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]]],
                       NewFigure2):-!,
    tools:find_common_point([[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],
                        [[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]],
                        [PtCFx,PtCFy]),
    tools:find_common_point([[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],
                        [[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]],
                        [PtCDx,PtCDy]),
    Ax is PtCDx - PtCFx, Ay is PtCDy - PtCFy,
    translate_figure(PointFigure,[Ax,Ay],NewFigure),
    tools:find_good_axe_rotation([[[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],[[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]]],
        [[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],[[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]]],Angle),
    rotate_figure(NewFigure,[PtCDx,PtCDy],Angle,NewFigure2).




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
test_placement_figure_dessin(_,_):-fail,nl.


