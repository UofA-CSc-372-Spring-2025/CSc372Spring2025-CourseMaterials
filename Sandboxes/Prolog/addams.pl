parent(grandmama,pancho).
parent(grandmama,gomez).
parent(hester,morticia).
parent(hester,ophelia).
parent(unknown,hester).
parent(unknown,fester).
parent(gomez,pugsley).
parent(gomez,wednesday).
parent(morticia,pugsley).
parent(morticia,wednesday).

% grandparent(X,Y): X is a grandparent of Y
grandparent(X,Y) :- parent(X,P), parent(P,Y).

sibling(X,Y) :- parent(P,X), parent(P,Y), not(X=Y).
%sibling(X,Y) :- not(X=Y), parent(P,X), parent(P,Y).
