parent(balbo,pansy).
parent(balbo,mungo).
parent(mungo,bungo).
parent(bungo,bilbo).
parent(mungo,belba).
parent(mungo,longo).
parent(camelia,otho).
parent(longo,otho).
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
