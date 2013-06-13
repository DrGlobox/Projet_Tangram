:-module(soustraction, [soustraction/3]).
:-use_module(tools).
:-use_module(tangram).

%soustraction(Patterns, Forme, New_patterns) 
%avec   Patterns la liste des sous patterns contenant chacun 
%la liste des points qui les delimitent
%       Forme la liste des points qui delimitent la forme
%       New_patterns la nouvelle liste des sous patterns obtenue 
%par soustraction du deuxieme para au premier



soustraction([Patterns], Forme, [NewPatterns4]):-
    tools:liste_all_couple_aretes(Patterns,CoupleAretePatterns),
    tools:liste_all_couple_aretes(Forme,CoupleAreteForme),
    search_commmon_arete(CoupleAretePatterns,CoupleAreteForme,Arete),
    mix_pattern_forme(CoupleAretePatterns,CoupleAreteForme,Arete,Mixed),
    clean_double_arete(Mixed,CleanedMixed),
    %clean_double_vecteur(CleanedMixed,CleanedMixedVecteur),
    %arete_to_point(CleanedMixedVecteur,NewListPoint),
    arete_to_point(CleanedMixed,NewListPoint),
    clean_double_point(NewListPoint,NewPatterns1),
    clean_first_last_double_point(NewPatterns1,NewPatterns3),
    clean_double_vecteur(NewPatterns3,NewPatterns4).





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


mix_pattern_forme([A|Reste],CoupleForme,A,[A|NewCouple]):-!,
        add_forme_patterns(CoupleForme,Reste,NewCouple).
mix_pattern_forme([APatterns|Reste],Forme,A,[APatterns|Retour]):-
    mix_pattern_forme(Reste,Forme,A,Retour).



add_forme_patterns([],Pattern,Pattern):-!.
add_forme_patterns([A|Reste],Pattern,[A|Result]):-
    add_forme_patterns(Reste,Pattern,Result).


search_commmon_arete([Arete|_],Forme,Arete):-
    search_arete_in_forme(Arete,Forme),!.

search_commmon_arete([_|Reste],Forme,Arete):-
    search_commmon_arete(Reste,Forme,Arete).

    
search_arete_in_forme(_,[]):-!,fail.
search_arete_in_forme(Arete,[AForme|_]):-
    teste_aretes_egales(Arete,AForme),!.
search_arete_in_forme(Arete,[_|RForme]):-
    search_arete_in_forme(Arete,RForme),!.

teste_aretes_egales([P2,P1],[P2,P1]):-!.
teste_aretes_egales([P1,P2],[P2,P1]):-!.
teste_aretes_egales(_,_):-fail.


