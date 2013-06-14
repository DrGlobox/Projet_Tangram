:-module(soustraction, [soustraction/3]).
:-use_module(tools).
:-use_module(tangram).

%soustraction(Patterns, Piece, New_patterns) 
%avec   Patterns la liste des sous patterns contenant chacun 
%la liste des points qui les delimitent
%       Piece la liste des points qui delimitent la forme
%       New_patterns la nouvelle liste des sous patterns obtenue 
%par soustraction du deuxieme para au premier

<<<<<<< HEAD
soustraction([Patterns], Piece, [NewPatterns4]):-
	write_ln(Patterns), write_ln(Piece),
=======


soustraction([Patterns], Forme, [NewPatterns4]):-
>>>>>>> db0b81aad35827443c91928cb1596bc853988fe0
    tools:liste_all_couple_aretes(Patterns,CoupleAretePatterns),
    tools:liste_all_couple_aretes(Piece,CoupleAretePiece),
    search_commmon_arete(CoupleAretePatterns,CoupleAretePiece,Arete),
    search_sens_forme(CoupleAretePiece,Arete,Sens),
    retourne_forme(CoupleAretePiece,Sens,CoupleAretePiece1),
    mix_pattern_forme(CoupleAretePatterns,CoupleAretePiece1,Arete,Mixed),
    clean_double_arete(Mixed,CleanedMixed),
    arete_to_point(CleanedMixed,NewListPoint),
    clean_double_point(NewListPoint,NewPatterns1),
    clean_first_last_double_point(NewPatterns1,NewPatterns4).



retourne_forme(Piece,1,Piece):-!.
retourne_forme([],-1,[]):-!.
retourne_forme([[P1,P2]|Reste],-1,Result):-
    retourne_forme(Reste,-1,R),
    ajout_fin(R,[P2,P1],Result).


ajout_fin([],A,[A]):-!.
ajout_fin([T|Reste],A,[T|Result]):-
    ajout_fin(Reste,A,Result).

search_sens_forme([A|_],Arete,Sens):-
    teste_aretes_egales(A,Arete),
    get_sens(A,Arete,Sens),!.
search_sens_forme([_|Reste],Arete,Sens):-
    search_sens_forme(Reste,Arete,Sens).

get_sens([P2,P1],[P2,P1],1):-!.
get_sens([P1,P2],[P2,P1],-1):-!.
get_sens(_,_,0):-fail.




clean_double_vecteur(Patterns,NewPatterns):-
    clean_double_vecteur2(Patterns,NewPatterns1),
    clean_double_vecteur_premier(NewPatterns1,NewPatterns2),
    clean_double_vecteur_dernier(NewPatterns2,NewPatterns).



clean_double_vecteur_premier([P,PS|Reste],[PS|Reste]):-
    tools:dernier(Reste,D),
    test_point([D,P,PS],[D,PS]),!.
clean_double_vecteur_premier(Liste,Liste).

clean_double_vecteur_dernier([P|Reste],[P|R]):-
    tools:dernier(Reste,D),tools:avantDernier(Reste,AD),
    test_point([AD,D,P],[AD,P]),!,
    remove_last_point(Reste,R).
clean_double_vecteur_dernier(Liste,Liste).
    

clean_double_vecteur2([],[]):-!.
clean_double_vecteur2([P1,P2,P3],Result):-!,
    test_point([P1,P2,P3],Result).
clean_double_vecteur2([P1,P2,P3|Reste],[P1|Result]):-!,
    test_point([P1,P2,P3],[P1,P2,P3]),
    clean_double_vecteur2([P2,P3|Reste],Result).
clean_double_vecteur2([P1,P2,P3|Reste],Result):-!,
    test_point([P1,P2,P3],[P1,P3]),
    clean_double_vecteur2([P1,P3|Reste],Result).





test_point([P1,P2,P3],[P1,P3]):-
    calcul_vecteur(P1,P2,U12),
    calcul_vecteur(P2,P3,U23),
    test_colineaire(U12,U23),!.
test_point([P1,P2,P3],[P1,P2,P3]).

calcul_vecteur([[X1,Y1],[X2,Y2]],Vecteur):-
    calcul_vecteur([X1,Y1],[X2,Y2],Vecteur).
calcul_vecteur([X1,Y1],[X2,Y2],[Xu,Yu]):-
    Xu is X2 - X1, Yu  is Y2 - Y1.

test_colineaire([Ux,Uy],[Vx,Vy]):-
    UxVy is Ux * Vy,
    UyVx is Uy * Vx,
    UxVy == UyVx,!.

test_colineaire(_,_):-fail.


clean_first_last_double_point([A|Reste],Reste):-
    dernier(Reste,A),!.
clean_first_last_double_point(L,L).


arete_to_point([],[]):-!.
arete_to_point([[[Pt1,Pt2],A2]|Reste],[[Pt1,Pt2]|NewPatterns]):-
    arete_to_point2([[[Pt1,Pt2],A2]|Reste],NewPatterns).

arete_to_point2([[Pt1,Pt2],[Pt3,Pt4]],[[X,Y]]):-!,
    tools:find_common_point([Pt1,Pt2],[Pt3,Pt4],[X,Y]).
arete_to_point2([A1,A2|Reste],[[X,Y]|Result]):-
    tools:find_common_point(A1,A2,[X,Y]),
    arete_to_point2([A2|Reste],Result).


clean_double_point([],[]):-!.
clean_double_point([A,A|Rest],Result):-!,
    clean_double_point([A|Rest],Result).
clean_double_point([A|Rest],[A|Result]):-
    clean_double_point(Rest,Result).

clean_double_arete([],[]):-!.
clean_double_arete([A|Reste],ResteNew):-
    search_arete_in_forme(A,Reste),!,
    remove_arete_patterns(A,Reste,Reste1),
    clean_double_arete(Reste1,ResteNew).
clean_double_arete([A|Reste],[A|ResteNew]):-
    clean_double_arete(Reste,ResteNew).


remove_arete_patterns(_,[],[]):-!.
remove_arete_patterns(A,[A|Reste],Reste):-!.
remove_arete_patterns(A,[B|Reste],[B|Result]):-
    remove_arete_patterns(A,Reste,Result).


mix_pattern_forme([A|Reste],CouplePiece,A,[A|NewCouple]):-!,
        add_forme_patterns(CouplePiece,Reste,NewCouple).
mix_pattern_forme([APatterns|Reste],Piece,A,[APatterns|Retour]):-
    mix_pattern_forme(Reste,Piece,A,Retour).



add_forme_patterns([],Pattern,Pattern):-!.
add_forme_patterns([A|Reste],Pattern,[A|Result]):-
    add_forme_patterns(Reste,Pattern,Result).


search_commmon_arete([Arete|_],Piece,Arete):-
    search_arete_in_forme(Arete,Piece),!.

search_commmon_arete([_|Reste],Piece,Arete):-
    search_commmon_arete(Reste,Piece,Arete).

    
search_arete_in_forme(_,[]):-!,fail.
search_arete_in_forme(Arete,[APiece|_]):-
    teste_aretes_egales(Arete,APiece),!.
search_arete_in_forme(Arete,[_|RPiece]):-
    search_arete_in_forme(Arete,RPiece),!.

teste_aretes_egales([P2,P1],[P2,P1]):-!.
teste_aretes_egales([P1,P2],[P2,P1]):-!.
teste_aretes_egales(_,_):-fail.


