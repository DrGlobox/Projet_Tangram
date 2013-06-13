:-module(placePiece,[placePiece/3]).
:-use_module(tools).
:-use_module(tangram).
:-use_module(pointIsInFigure).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Retourne les positions de la piece dans le Pattern
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

placePiece(Piece,Patterns,ReturnPiece):-
    test_placement_patterns_exact_match(Piece,Patterns,Placement),
    positionne(Piece,Placement,NewPiece),
    test_all_placement(NewPiece,Patterns,Placement,ReturnPiece).
placePiece(Piece,Patterns,ReturnPiece):-
    test_placement_patterns_angle_match(Piece,Patterns,Placement),
    positionne(Piece,Placement,[Axe1,Axe2],NewPiece),
    test_placement(NewPiece,Patterns,[Axe1,Axe2],ReturnPiece).

test_placement(NewPiece,Patterns,[Axe1,_],ReturnPiece):-
    test_all_placement(NewPiece,Patterns,[[],Axe1],ReturnPiece),!.
test_placement(NewPiece,Patterns,[_,Axe2],ReturnPiece):-
    test_all_placement(NewPiece,Patterns,[[],Axe2],ReturnPiece).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Essaye de trouver un placement par longueur exacte
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test_placement_patterns_exact_match permet d'iteré tous les pieces qui compose le pattern
test_placement_patterns_exact_match(_,[],_):-fail.
test_placement_patterns_exact_match(Piece,[Pattern|_],Placement):- 
    tools:aretes_piece(Pattern,AretesPattern), 
    test_aretes_pattern_exact_match(Piece,AretesPattern,Placement).
test_placement_patterns_exact_match(Piece,[_|Reste],Placement):- 
    test_placement_patterns_exact_match(Piece,Reste,Placement).

%test_aretes_pattern_exact_match permet pour chaque pattern d'itèré toutes les aretes 
test_aretes_pattern_exact_match(_,[],_):-fail.
test_aretes_pattern_exact_match(Piece,[Arete|_],Placement):-
    tools:aretes_piece(Piece,AretesPiece),
    test_piece_arete_pattern_exacte_match(AretesPiece,Arete,Placement).
test_aretes_pattern_exact_match(Piece,[_|Reste],Placement):-
    test_aretes_pattern_exact_match(Piece,Reste,Placement).

%test_piece_arete_pattern_exacte_match permet pour chaque arete du pattern d'itèré toutes les aretes de la piece à tester
test_piece_arete_pattern_exacte_match([],_,_):-fail.
test_piece_arete_pattern_exacte_match([_|RestePiece],AretePattern,Placement):-
    test_piece_arete_pattern_exacte_match(RestePiece,AretePattern,Placement).
test_piece_arete_pattern_exacte_match([[Pf1,Pf2]|_],[Pd1,Pd2],[[Pf1,Pf2],[Pd1,Pd2]]):-  
    distance(Pf1,Pf2,Df), distance(Pd1,Pd2,Dd), Df == Dd.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Essaye de trouver un placement par angle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%test_placement_patterns_exact_match permet d'iteré tous les pieces qui compose le pattern
test_placement_patterns_angle_match(_,[],_):-fail.
test_placement_patterns_angle_match(Piece,[Pattern|_],Placement):- 
    tools:aretes_piece(Pattern,AretesPattern), 
    tools:aretes_piece(Piece,AretesPiece), 
    tools:liste_all_couple_aretes(AretesPattern,CouplesAretesPattern),
    tools:liste_all_couple_aretes(AretesPiece,CouplesAretesPiece),
    test_aretes_pattern_angle_match(CouplesAretesPiece,CouplesAretesPattern,Placement).
test_placement_patterns_angle_match(Piece,[_|Reste],Placement):- 
    test_placement_patterns_angle_match(Piece,Reste,Placement).

test_aretes_pattern_angle_match(_,[],_):-fail.
test_aretes_pattern_angle_match(CouplesAretesPiece,[CoupleAretesPattern|_],Placement):-
    test_piece_arete_pattern_angle_match(CouplesAretesPiece,CoupleAretesPattern,Placement).
test_aretes_pattern_angle_match(CouplesAretesPiece,[_|ResteCouple],Placement):-
    test_aretes_pattern_angle_match(CouplesAretesPiece,ResteCouple,Placement).

test_piece_arete_pattern_angle_match([],_,_):-fail.
test_piece_arete_pattern_angle_match([CoupleAretesPiece|_],CoupleAretesPattern,Placement):-
    test_couple_angle_match(CoupleAretesPiece,CoupleAretesPattern,Placement).
test_piece_arete_pattern_angle_match([_|ResteCouple],CoupleAretesPattern,Placement):-
    test_piece_arete_pattern_angle_match(ResteCouple,CoupleAretesPattern,Placement).

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
%     Positionne la piece par rapport à l'arete trouvé
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


positionne(PointPiece,[
                        [[[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],%pt 1 et 2 de l arrete num 1 Piece
                        [[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]]],
                        [[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],%pt 1 et 2 de l arrete num 1 Pattern
                        [[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]]]
                       ],
                       [[[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]],[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]]],
                       NewPiece2):-!,
    tools:find_common_point([[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],
                        [[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]],
                        [PtCFx,PtCFy]),
    tools:find_common_point([[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],
                        [[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]],
                        [PtCDx,PtCDy]),
    Ax is PtCDx - PtCFx, Ay is PtCDy - PtCFy,
    translate_piece(PointPiece,[Ax,Ay],NewPiece),
    tools:find_good_axe_rotation([[[PtA1F1x,PtA1F1y],[PtA1F2x,PtA1F2y]],[[PtA2F1x,PtA2F1y],[PtA2F2x,PtA2F2y]]],
        [[[PtA1D1x,PtA1D1y],[PtA1D2x,PtA1D2y]],[[PtA2D1x,PtA2D1y],[PtA2D2x,PtA2D2y]]],Angle),
    rotate_piece(NewPiece,[PtCDx,PtCDy],Angle,NewPiece2).




positionne(PointPiece,[[[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewPiece2):-
    Ax is Pfx1 - Pox1, Ay is Pfy1 - Poy1,
    translate_piece(PointPiece,[Ax,Ay],NewPiece),
    find_angle([[Pox1,Poy1],[Pox2,Poy2]],[[Pfx1,Pfy1],[Pfx2,Pfy2]],Angle),
    rotate_piece(NewPiece,[Pfx1,Pfy1],Angle,NewPiece2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Vérifie si la piece est valide par rapport au pattern
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

test_all_placement(Piece,Patterns,_,Piece):-
    test_placement_patterns(Piece,Patterns),!.
test_all_placement(Piece,Patterns,[_,[[Pfx1,Pfy1],[Pfx2,Pfy2]]],NewPiece):-
    symetrie_piece(Piece,[[Pfx1,Pfy1],[Pfx2,Pfy2]],NewPiece),
    test_placement_patterns(NewPiece,Patterns),!.
test_all_placement(_,_,_,_):-fail.

test_placement_patterns(_,[]):-!.
test_placement_patterns(Piece,[Pattern|Reste]):-
    test_placement_patterns(Piece,Reste),
    test_placement_piece_pattern(Piece,Pattern),!.
test_placement_patterns(_,_):-fail.

test_placement_piece_pattern([],_):-!.
test_placement_piece_pattern([Point|Rest],Pattern):-
    test_placement_piece_pattern(Rest,Pattern),
    pointIsInFigure:pointIsInFigure(Point,Pattern,Result),
    Result == 1,!.
test_placement_piece_pattern(_,_):-fail,nl.


