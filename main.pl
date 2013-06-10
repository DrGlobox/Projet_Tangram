%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Programme principal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-use_module(tools).
:-use_module(tangram).
:-use_module(placeFigure).
:-use_module(soustraction).

% Définition du dessin à résoudre
%dessin(?D) avec D : expression représentant les dessins existants
% 		Attention les dessins sont une liste de liste de figure 
dessin(carre).
points_dessin(carre, [[[0,0], [100,0], [100,100], [0,100]]]).

% Prédicat principal, pour chaque fait D de dessin, sauf s'il est précisé
% Ce prédicat fait office d'initialisation de l'algo
main(Dessin, PiecesRetenues) :-
	dessin(Dessin), points_dessin(Dessin, PointsDessin),
	figures_tangram(Pieces),
	essai_piece(Pieces, PointsDessin, PiecesRetenues, 5).

% Essai de chaque pièce dans la liste
% Pour ne pas faire d'itération inutile, on limite le compteur à 5
% Si la pièce n'est plaçable nul part, on la place à la fin
essai_piece([], [], _, _) :- !.
essai_piece(_, _, _, 0) :- !.
essai_piece([Piece|PiecesRestantes], Dessin, [Piece|PiecesRetenues], _) :-
	points_figure(Piece, PointsPiece),
	%write('Essai de la pièce '),
	%write(Piece),
	placeFigure(PointsPiece, Dessin, Placements),
	retirer_piece(PiecesRestantes, Dessin, Placements, PiecesRetenues).
essai_piece([PieceNonUtilisee|PiecesRestantes], Dessin, PiecesRetenues, N) :- 
	append(PiecesRestantes, [PieceNonUtilisee], Pieces), N1 is N-1,
	%write_ln(' -> la pièce est mise de côté pour le moment'),
	essai_piece(Pieces, Dessin, PiecesRetenues, N1).
	
% Retrait de la pièce si on a pu la placer au moins une fois
% Puis on réitère l'algo avec le nouveau dessin et les placements restants
retirer_piece(Pieces, [Dessin], Placements, PiecesRetenues) :-
	soustraction(Dessin, Placements, NouveauDessin),
	write_ln(' -> la pièce est placée avec succès, passage à la pièce suivante'),
	essai_piece(Pieces, [NouveauDessin], PiecesRetenues, 5).
