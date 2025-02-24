% Constraints on various possible grades in 372.
/*
Example query:

?-  Goal=800, SAs=[15,0,15], LAs=[0],  ICAs=[20], MT1=50, Extra=0.
?- sum($SAs,SAtotal), sum($LAs,LAtotal), sum($ICAs,ICAtotal),
can_reach_goal(SAtotal, LAtotal, ICAtotal, $MT1, $Extra, $Goal,
                InClassCurrPoints, TotalCurrPoints,
                InClassNeededToPass, InClassPossible,
                OutOfClassNeededToPass, OutOfClassPossible).
*/

% Calculates total points from a list
sum([], 0).
sum([H|T], Total) :- sum(T, Rest), Total is H + Rest.

% Determines whether a student has enough points to pass and/or reach a goal
can_reach_goal(SA, LA, ICA, MT1, Extra, Goal,
               InClassCurrPoints, TotalCurrPoints,
               InClassNeededForGoal, InClassPossible,
               OutOfClassNeededForGoal, OutOfClassPossible) :-

    % Define point requirements
    InClassPassRequirement = 360,
    TotalPassRequirement = 600,
    
    % Define available remaining points.
    % Valid on Feb 25, 2021.
    SAleft = 75, LAleft = 80, FPleft = 200, ICAleft = 50, 
    MT2left = 200, FinalExamLeft = 200, ExtraMax = 40,

    % Max category limits
    SAmax = 100, LAmax = 100, ICAmax = 100,

    % Calculate current points
    FP = 0, MT2 = 0, FinalExam = 0,
    total_points(SA, LA, ICA, MT1, Extra, MT2, FP, FinalExam,
                 InClassCurrPoints, OutClassCurrPoints, TotalCurrPoints),

    % Calculate needed points for passing
    InClassNeededToPass is max(0, InClassPassRequirement - InClassCurrPoints),
    OutOfClassNeededToPass is max(0, TotalPassRequirement
                                     - InClassPassRequirement
                                     - OutClassCurrPoints),

    % Calculate possible points left
    ICA_Possible is min(ICAleft, ICAmax - ICA),
    SA_Possible is min(SAleft, SAmax - SA),
    LA_Possible is min(LAleft, LAmax - LA),
    InClassPossible is ICA_Possible + MT2left + FinalExamLeft,
    OutOfClassPossible is SA_Possible + LA_Possible + FPleft
                          + (ExtraMax - Extra),

    % Additional points needed for the target goal.
    %DeltaOver600Needed is max(0, Goal - 600),
    
    % Distribute needed extra points across in-class and out-of-class.
    % Going to use up OutOfClassPossible first, then InClassPossible.
    OutOfClassNeededForGoal is max(OutOfClassNeededToPass,
                                   min(OutOfClassPossible, Goal-InClassNeededToPass)),
    InClassNeededForGoal is max(InClassNeededToPass,
                                Goal - OutOfClassNeededForGoal - TotalCurrPoints),

    % Ensure the goal is achievable
    InClassNeededForGoal =< InClassPossible,
    OutOfClassNeededForGoal =< OutOfClassPossible.

% define totalPoints predicate that caps SAtotal, LAtotal, and ICAtotal to 100,
% Extra to 40, and calculates InClassPoints, OutClassPoints, and TotalPoints.
total_points(SAtotal, LAtotal, ICAtotal, MT1, Extra, MT2, FP, FinalExam,
             InClassPoints, OutClassPoints, TotalPoints) :-
    ICA_Capped is min(ICAtotal, 100),
    SA_Capped is min(SAtotal, 100),
    LA_Capped is min(LAtotal, 100),
    Extra_Capped is min(Extra, 40),
    OutClassPoints is SA_Capped + LA_Capped + FP,
    InClassPoints is ICA_Capped + MT1 + MT2 + FinalExam + Extra_Capped,
    TotalPoints is InClassPoints + OutClassPoints.

