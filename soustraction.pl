:-use_module(tools).
:-use_module(tangram).

%soustraction(Patterns, Forme, New_patterns) 
%avec   Patterns la liste des sous patterns contenant chacun 
%la liste des points qui les delimitent
%       Forme la liste des points qui delimitent la forme
%       New_patterns la nouvelle liste des sous patterns obtenue 
%par soustraction du deuxieme para au premier

%soustraction([],_,[]):- !.
%soustraction([[pt|restePat]],Forme,[[pt|resteNewPat]]):- not(member(pt, Forme)),soustraction([restePat], Forme, [resteNewPat]).
%soustraction([pat],[pt|resteForme],[[pt|resteNewPat]]):- not(member(pt, Forme)), soustraction([pat], Forme, [resteNewPat]).
%soustraction([[pt|restePat]], [pt|resteForme], [[pt|resteNewPat]]):-
