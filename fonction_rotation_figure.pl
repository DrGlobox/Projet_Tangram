%figure(?F) avec f : expression représentant une figure existante
figure(gros_triangle).
figure(moyen_triangle).
figure(petit_triangle).
figure(carre).
figure(parallelogramme).

%points_figure(+F,-L): avec f : expression représentant la figure 
%                          L : Liste des points composants la figure
points_figure(gros_triangle,   [[0,0] ,[100,0] ,[50,50]        ]).
points_figure(moyen_triangle,  [[0,0] ,[0,50]  ,[50, 0]        ]).
points_figure(petit_triangle,  [[0,0] ,[50,0]  ,[25,25]        ]).
points_figure(carre,           [[0,0] ,[25,0]  ,[25,25] ,[0,25]]).
points_figure(parallelogramme, [[0,0] ,[25,25] ,[25,75] ,[0,25]]).

%figures_tangram(-L): avec L : liste des figures disponible pour résoudre le tagram
%figures_tangram([gros_triangle,gros_triangle,parallelogramme,carre,moyen_triangle,petit_triangle,petit_triangle]).
figures_tangram([petit_triangle,petit_triangle,moyen_triangle,carre,parallelogramme,gros_triangle,gros_triangle]).


%dessin(?D) avec D : expression représentant les dessin existant
dessin(dessin_carre).
points_dessin(dessin_carre,  [[0,0] ,[100,0] ,[100,100] ,[0,100]]).


%pow(Nombre,Puissance,Resultat).
pow(_,0,1).
pow(X,Y,Z) :- 
    Y1 is Y - 1, pow(X,Y1,Z1), Z is Z1*X.

%distance(Point1,Point2,D) calcule la disance D entre 2 point 
distance([Xp,Yp],[Xo,Yo],D):-
    XoXp = Xo-Xp,pow(XoXp,2,XoXp2),
    YoYp = Yo-Yp,pow(YoYp,2,YoYp2),
    D is sqrt(XoXp2 + YoYp2),!.

%rotation_figure(Points, Origine, Angle, Points_tournes)
%                   avec Points liste de point et Angle entier en radian et Points_tournes
%                   le prédicat execute une rotation Angle sur la figures représenter par Point par
%                   rapport a son point Origine
rotation_figure([], _, _,[]):-!.

rotation_figure([Origine|Reste], Origine, Angle,[Origine|Retour]):- 
    !, rotation_figure(Reste,Origine,Angle,Retour).

rotation_figure([Point|Reste], Origine, Angle,[Point_tourne|Retour]):-
    rotation_figure(Reste,Origine,Angle,Retour),
    rotation_point(Point,Origine,Angle,Point_tourne).


%rotation_point(Point, Origine,Angle,Point_tourne)
%                   rotation du point Point d'angle Angle autour du centre Origin
rotation_point([Xp,Yp],[Xo,Yo],Angle,[Xr,Yr]):-
    distance([Xp,Yp],[Xo,Yo],D),
    CosAngle is cos(Angle), SinAngle is sin(Angle),
    Xr is (D*CosAngle+ Xo),
    Yr is (D*SinAngle+ Yo).
