:-use_module(tools).
:-use_module(tangram).

%soustraction(Patterns, Forme, New_patterns) 
%avec   Patterns la liste des sous patterns contenant chacun 
%la liste des points qui les delimitent
%       Forme la liste des points qui delimitent la forme
%       New_patterns la nouvelle liste des sous patterns obtenue 
%par soustraction du deuxieme para au premier

soustraction([],[],_):- !.
soustraction([Pt|RPat],Forme,[Pt|RNewPat]):- not(member(Pt, Forme)), soustraction(RPat, Forme, RNewPat).
soustraction(Pat,[Pt|RForme],[Pt|RNewPat]):- not(member(Pt, Pat)), soustraction(Pat, RForme, RNewPat).
soustraction([Pt|RPat], [Pt|RForme], [Pt|RNewPat]):- soustraction(RPat, RForme, RNewPat).
