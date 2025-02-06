# Answers to Quiz 4

Note: Coding answers can have many variations.  It is impossible to provide all the possible answers
here.

## Question 1:
    fun sum [] = 0
    | sum (x::xs) =
      if x mod 2 = 0 then (x * x) + sum xs
    else sum xs;

    fun sum [] = 0
    | sum (x::xs) =
      case x mod 2 of
        0 => x * x + sum (xs)
      | 1 => sum (xs)

## Question 2:
    val sumOfSquaresOfEvens = foldl (fn (x, acc) => if x mod 2 = 0 then acc + (x * x) else acc) 0
    fun sumEvenSquares lst = foldl (fn (x, acc) => if x mod 2 = 0 then acc + (x * x) else acc) 0 lst
    fun sumEvenSquares lst = foldl (fn (x, acc) => 
      case (x mod 2 = 0) of
        true => acc + x * x
      | false => acc
      ) 0 lst
  
## Question 3: True  

## Question 4: Data typing, Base case, or Pattern matching  

## Question 5: B  

## Question 6: True  

## Question 7: D  

## Question 8: D  