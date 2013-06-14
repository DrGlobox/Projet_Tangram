:-module(soustraction, [soustraction/3]).
:-use_module(tools).
:-use_module(tangram).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Soustraction d'une piece à un pattern
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%soustraction(+Patterns, +Piece, -New_patterns) 
%   avec : Patterns la liste des sous patterns contenant chacun 
%               la liste des points qui les delimitent
%          Piece la liste des points qui delimitent la forme
%          New_patterns la nouvelle liste des sous patterns obtenue 
%               par soustraction du deuxieme para au premier
soustraction([Patterns], Piece, [NewPatterns4]):-
    tools:liste_all_couple_aretes(Patterns,CoupleAretePatterns),
    tools:liste_all_couple_aretes(Piece,CoupleAretePiece),
    tools:search_commmon_arete(CoupleAretePatterns,CoupleAretePiece,Arete),
    tools:search_sens_forme(CoupleAretePiece,Arete,Sens),
    tools:retourne_forme(CoupleAretePiece,Sens,CoupleAretePiece1),
    mix_pattern_forme(CoupleAretePatterns,CoupleAretePiece1,Arete,Mixed),
    clean_double_arete(Mixed,CleanedMixed),
    arete_to_point(CleanedMixed,NewListPoint),
    clean_double_point(NewListPoint,NewPatterns1),
    clean_first_last_double_point(NewPatterns1,NewPatterns4).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Fonction de soustraction
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%mix_pattern_forme(+Pattern,+Piece,+Arete,NouveauPattern)
%   avec :  Pattern liste d'arete formant un pattern
%           Piece liste d'arete formant un pattern
%           Arete Arete commune entre la piece et le pattern 
%           NouveauPattern liste d'arete formant le nouveau pattern
%           avec la piece introduite au niveau de l'arete dans le pattern
mix_pattern_forme([A|Reste],CouplePiece,A,[A|NewCouple]):-!,
        add_forme_patterns(CouplePiece,Reste,NewCouple).
mix_pattern_forme([APatterns|Reste],Piece,A,[APatterns|Retour]):-
    mix_pattern_forme(Reste,Piece,A,Retour).

add_forme_patterns([],Pattern,Pattern):-!.
add_forme_patterns([A|Reste],Pattern,[A|Result]):-
    add_forme_patterns(Reste,Pattern,Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Fonction de nettoyage
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% clean_first_last_double_point(+Liste,-NouvelleListe)
%   avec : Liste une liste de point 
%          NouvelleListe Liste de point dans le premier élément si celui ci est
%          le même que le dernier.
clean_first_last_double_point([A|Reste],Reste):-
    dernier(Reste,A),!.
clean_first_last_double_point(L,L).


% arete_to_point(+Aretes,-Points)
%   avec : Aretes liste des aretes représentant une figure
%          Points liste des points représentant une figure
arete_to_point([],[]):-!.
arete_to_point([[[Pt1,Pt2],A2]|Reste],[[Pt1,Pt2]|NewPatterns]):-
    arete_to_point2([[[Pt1,Pt2],A2]|Reste],NewPatterns).

arete_to_point2([[Pt1,Pt2],[Pt3,Pt4]],[[X,Y]]):-!,
    tools:find_common_point([Pt1,Pt2],[Pt3,Pt4],[X,Y]).
arete_to_point2([A1,A2|Reste],[[X,Y]|Result]):-
    tools:find_common_point(A1,A2,[X,Y]),
    arete_to_point2([A2|Reste],Result).


%clean_double_point(+Points,-NouveauxPoints)
%   avec :  Points liste des points représentant une figure
%           NouveauxPoints liste des points sans ceux redondants
clean_double_point([],[]):-!.
clean_double_point([A,A|Rest],Result):-!,
    clean_double_point([A|Rest],Result).
clean_double_point([A|Rest],[A|Result]):-
    clean_double_point(Rest,Result).

%clean_double_arete(+Aretes,-NouvellesAretes)
%   avec :  Aretes liste des aretes représentant une figure
%           NouvellesAretes liste des aretes sans celles redondantes
clean_double_arete([],[]):-!.
clean_double_arete([A|Reste],ResteNew):-
    tools:search_arete_in_forme(A,Reste),!,
    tools:remove_arete_patterns(A,Reste,Reste1),
    clean_double_arete(Reste1,ResteNew).
clean_double_arete([A|Reste],[A|ResteNew]):-
    clean_double_arete(Reste,ResteNew).

