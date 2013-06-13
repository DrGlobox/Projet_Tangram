%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Programme principal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-use_module(tools).
:-use_module(tangram).
:-use_module(placeFigure).
:-use_module(soustraction).

% Prédicat principal, pour chaque fait D de dessin, sauf s'il est précisé
% Ce prédicat fait office d'initialisation de l'algo
main(Dessin, PiecesRetenues) :-
	dessin(Dessin), points_dessin(Dessin, PointsDessin),
	figures_tangram(Pieces),
	write_ln('\tProfondeur : 0'),
	essai_piece(Pieces, PointsDessin, PiecesRetenues, 5),
	nl, write_ln('------------------------\nTime to get some results\n------------------------'),
	affiche_resultat(PiecesRetenues).

% Essai de chaque pièce dans la liste
% Pour ne pas faire d'itération inutile, on limite le compteur à 5
% Si la pièce n'est plaçable nul part, on la place à la fin
essai_piece([], _, _, _) :- !.
essai_piece(_, [], Solution, _) :- !, 
	affiche_resultat(Solution).
essai_piece(_, _, _, 0) :- 
	write_ln('\tBout de la branche atteint'), !, fail.
essai_piece([Piece|PiecesRestantes], Dessin, [[Piece, Placements]|PiecesRetenues], _) :-
	points_figure(Piece, PointsPiece),
	write('Essai de la pièce '),
	write(Piece),
	placeFigure(PointsPiece, Dessin, Placements),
	retirer_piece(PiecesRestantes, Dessin, Placements, PiecesRetenues).
essai_piece([PieceNonUtilisee|PiecesRestantes], Dessin, PiecesRetenues, N) :- 
	append(PiecesRestantes, [PieceNonUtilisee], Pieces), N1 is N-1,
	write_ln(' -> la pièce est mise de côté pour le moment'),
	essai_piece(Pieces, Dessin, PiecesRetenues, N1).
	
% Retrait de la pièce si on a pu la placer au moins une fois
% Puis on réitère l'algo avec le nouveau dessin et les placements restants
retirer_piece(Pieces, Dessin, Placements, PiecesRetenues) :-
	soustraction(Dessin, Placements, NouveauDessin),
	write_ln(' -> la pièce est placée avec succès, passage à la pièce suivante'),
	write('\tPlacement en '), write_ln(Placements),
	write('\tProfondeur : '), length(Pieces, N), P is 7-N, write_ln(P),
	essai_piece(Pieces, NouveauDessin, PiecesRetenues, 5).

% Affichage de la solution finale (la grande classe quoi)
affiche_resultat([]) :- !.
affiche_resultat([[Piece, Coordonnees]|Reste]) :-
	write(Piece), write(' \t-> \t'), write(Coordonnees), nl,
	affiche_resultat(Reste).
