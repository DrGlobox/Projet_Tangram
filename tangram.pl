%
%Exemple de résultat possible
%SHAPES = [
%[[0,0] ,[50,0]   ,[25,25]          ] % PETIT TRIANGLE #1
%[[0,0] ,[50,0]   ,[25,25]          ] % PETIT TRIANGLE #2
%[[0,0] ,[25,0]   ,[25,25]  ,[0,25] ] % CARRE
%[[0,0] ,[0,50]   ,[50, 0]          ] % MOYEN TRIANGLE 
%[[0,0] ,[25,25]  ,[25,75]  ,[0,25] ] % TRAPEZE 
%[[0,0] ,[100,0]  ,[50,50]          ] % GROS TRIANGLE #1
%[[0,0] ,[100,0]  ,[50,50]          ] % GROS TRIANGLE #2
%]
%
%DRAW = [
%   [[0,0],[100,0],[100,100],[0,100]]
%]
%
%RESULT = [
%[[100,0]  ,[75,25]  ,[100,50]          ] % PETIT TRIANGLE #1
%[[50,50]  ,[25,75]  ,[75, 75]          ] % PETIT TRIANGLE #2
%[[50,50]  ,[75,25]  ,[100,50]  ,[75,75]] % CARRE
%[[100,50] ,[50,100] ,[100,100]         ] % MOYEN TRIANGLE 
%[[0,100]  ,[50,100] ,[75,75]   ,[25,75]] % TRAPEZE 
%[[0,0]    ,[100,0]  ,[50,50]           ] % GROS TRIANGLE #1
%[[0,0]    ,[0,100]  ,[50,50]           ] % GROS TRIANGLE #2
%]
%




%tangram(+Shapes, +Draws, -Result)  avec Shapes, Draw et Result liste de Listes de points
%                                   Les figures sont trié (comme dans l'exemple) du moins complexe
%                                   au plus complexe à placer.
tangram([],_,[]).
tangram([Shape|Rest],Draw,NewResult):- 
    tangram(Rest,Draw,Result), 
    resultDraw(Draw,Result,DrawResult).


%resultDraw(+Draws,+Result,-DrawResult)  avec Draw,Result,DrawResult liste de listes de points
%                                       Le predicat est vrai dit DrawResult est la figure formée a
%                                       partir de Draw sans les morceaux contenus dans Result
resultDraw(Draws,[],Draws):-!.
resultDraw([],_,[]).
resultDraw([Draw|Rest],Result,DrawResult).
    

