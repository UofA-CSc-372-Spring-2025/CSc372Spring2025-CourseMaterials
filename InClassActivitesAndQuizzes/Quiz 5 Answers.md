# Answers to Quiz 5

## Question 1:
    IF, y, {, z, =, 42, }

## Question 2:
                              start
				/  \
			     stmts   EOF   stmts: IF y { z = 42 }
			     /    \
			  stmt   stmts     stmt: IF y { z = 42}, stmts: eps
			  /	   |
                      ifStmt	  eps	   ifStmt: IF y { z = 42}
			/
                   IF id { stmts }	   id: y, stmts: z = 42
 			    /   \
                          stmt   stmts
			    |	    |
			 z = 42   eps
  
## Question 3: A  

## Question 4: B  

## Question 5: C (Note: D reverses order)  

## Question 6: A  

## Question 7: C  

## Question 8: val isEven = fn x => x mod 2 = 0  