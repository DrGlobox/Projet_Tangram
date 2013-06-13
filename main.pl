%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Programme principal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-use_module(tools).
:-use_module(tangram).
:-use_module(placePiece).
:-use_module(soustraction).

% Prédicat principal, pour chaque fait D de pattern, sauf s'il est précisé
% Ce prédicat fait office d'initialisation de l'algo
main(Pattern, PiecesRetenues) :-
	pattern(Pattern), points_pattern(Pattern, PointsPattern),
	pieces_tangram(Pieces),
	write_ln('\tProfondeur : 0'),
	essai_piece(Pieces, PointsPattern, PiecesRetenues, 5),
	nl, write_ln('------------------------\nTime to get some results\n------------------------'),
	affiche_resultat(PiecesRetenues).

% Essai de chaque pièce dans la liste
% Pour ne pas faire d'itération inutile, on limite le compteur à 5
% Si la pièce n'est plaçable nul part, on la place à la fin
essai_piece([], _, _, _) :- !.
essai_piece(_, _, _, 0) :- 
	write_ln('\tBout de la branche atteint'), !, fail.
essai_piece([Piece|PiecesRestantes], Pattern, [[Piece, Placements]|PiecesRetenues], _) :-
	points_piece(Piece, PointsPiece),
	write('Essai de la pièce '),
	write(Piece),
	placePiece(PointsPiece, Pattern, Placements),
	retirer_piece(PiecesRestantes, Pattern, Placements, PiecesRetenues).
essai_piece([PieceNonUtilisee|PiecesRestantes], Pattern, PiecesRetenues, N) :- 
	append(PiecesRestantes, [PieceNonUtilisee], Pieces), N1 is N-1,
	write_ln(' -> la pièce est mise de côté pour le moment'),
	essai_piece(Pieces, Pattern, PiecesRetenues, N1).
	
% Retrait de la pièce si on a pu la placer au moins une fois
% Puis on réitère l'algo avec le nouveau pattern et les placements restants
retirer_piece(Pieces, Pattern, Placements, PiecesRetenues) :-
	soustraction(Pattern, Placements, NouveauPattern),
	write_ln(' -> la pièce est placée avec succès, passage à la pièce suivante'),
	write('\tPlacement en '), write_ln(Placements),
	write('\tProfondeur : '), length(Pieces, N), P is 7-N, write_ln(P),
	essai_piece(Pieces, NouveauPattern, PiecesRetenues, 5).

% Affichage de la solution finale (la grande classe quoi)
affiche_resultat([]) :- !.
affiche_resultat([[Piece, Coordonnees]|Reste]) :-
	write(Piece), write(' \t-> \t'), write(Coordonnees), nl,
	affiche_resultat(Reste).
