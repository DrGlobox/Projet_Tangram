%
%Exemple de résultat possible
%FIGURES = [
%[[0,0] ,[50,0]   ,[25,25]          ] % PETIT TRIANGLE #1
%[[0,0] ,[50,0]   ,[25,25]          ] % PETIT TRIANGLE #2
%[[0,0] ,[25,0]   ,[25,25]  ,[0,25] ] % CARRE
%[[0,0] ,[0,50]   ,[50, 0]          ] % MOYEN TRIANGLE 
%[[0,0] ,[25,25]  ,[25,75]  ,[0,25] ] % TRAPEZE 
%[[0,0] ,[100,0]  ,[50,50]          ] % GROS TRIANGLE #1
%[[0,0] ,[100,0]  ,[50,50]          ] % GROS TRIANGLE #2
%]
%
%DESSINS = [
%   [[0,0],[100,0],[100,100],[0,100]]
%]
%
%RESULTAT = [
%[[100,0]  ,[75,25]  ,[100,50]          ] % PETIT TRIANGLE #1
%[[50,50]  ,[25,75]  ,[75, 75]          ] % PETIT TRIANGLE #2
%[[50,50]  ,[75,25]  ,[100,50]  ,[75,75]] % CARRE
%[[100,50] ,[50,100] ,[100,100]         ] % MOYEN TRIANGLE 
%[[0,100]  ,[50,100] ,[75,75]   ,[25,75]] % TRAPEZE 
%[[0,0]    ,[100,0]  ,[50,50]           ] % GROS TRIANGLE #1
%[[0,0]    ,[0,100]  ,[50,50]           ] % GROS TRIANGLE #2
%]
%




%tangram(+Figures, +Dessins, -Resultat)  avec Figures, Dessin et Resultat liste de Listes de points
%                                   Les figures sont trié (comme dans l'exemple) du moins complexe
%                                   au plus complexe à placer.
tangram([],_,[]).
tangram([Figure|Rest],Dessin,[FigurePosition|FiguresPositions]):- 
    tangram(Rest,Dessin,FiguresPositions),
    dessinsResultant(Dessin,FiguresPositions,DessinFiguresPositionnees),
    placeFigure(Figure,DessinFiguresPositionnees,FigurePosition).


%dessinsResultant(+Dessins,+FiguresPositions,-DessinResult): 
%                               avec Dessin,FiguresPositions,DessinResult liste de listes de points
%                               Le predicat est vrai si DessinResult est la figure formée a
%                               partir de Dessin sans les morceaux contenus dans FiguresPositions
dessinsResultant(Dessins,[],Dessins):-!.
dessinsResultant([],_,[]).
dessinsResultant([Dessin|Rest],FiguresPositions,DessinResult):-
    dessinsResultant(Rest,FiguresPositions,DessinResult).
    

%placeFigure(+Figure,+DessinFiguresPositionnees,-FigurePosition)
%                               avec Figure et FigurePosition listes de points
%                               et DessinFiguresPositionnees Liste de listes de points
%                               Le predicat est vrai si FigurePosition est une position acceptable
%                               de Figure dans DessinFiguresPositionnees.
placeFigure([],_,[]).
placeFigure(_,_,_).









