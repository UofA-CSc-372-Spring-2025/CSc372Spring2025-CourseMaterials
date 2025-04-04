% Constraints on various possible grades in 372.
/*
Example query:

?-  Goal=800, SAs=[15,15,15,15,5], LAs=[60],  ICAs=[80], MT1=50, MT2=110, Extra=0.
?- sum($SAs,SAtotal), sum($LAs,LAtotal), sum($ICAs,ICAtotal).
?- can_reach_goal($SAtotal, $LAtotal, $ICAtotal, $MT1, $MT2, $Extra, $Goal,
                InClassCurrPoints, OutClassCurrPoints, TotalCurrPoints,
                MoreInClassNeededForGoal, InClassPossible,
                MoreOutOfClassNeededForGoal, OutOfClassPossible).

Note: Make sure the remaining points are updated in the can_reach_goal predicate.
*/

% Calculates total points from a list
sum([], 0).
sum([H|T], Total) :- sum(T, Rest), Total is H + Rest.

% Determines whether a student has enough points to pass and/or reach a goal
can_reach_goal(SA, LA, ICA, MT1, MT2, Extra, Goal,
               InClassCurrPoints, OutClassCurrPoints, TotalCurrPoints,
               MoreInClassNeededForGoal, InClassPossible,
               MoreOutOfClassNeededForGoal, OutOfClassPossible) :-

    % Define point requirements
    InClassPassRequirement = 360,
    TotalPassRequirement = 600,
    
    % Define available remaining points.
    % Valid on March 26th after MT2 and LA2
    % Valid on April 4th after ICA10 and SA6
    SAleft = 30, LAleft = 40, FPleft = 200, ICAleft = 20, 
    FinalExamLeft = 200, ExtraMax = 40,

    % Calculate current points
    FP = 0, FinalExam = 0,
    total_points(SA, LA, ICA, MT1, Extra, MT2, FP, FinalExam,
                 InClassCurrPoints, OutClassCurrPoints, TotalCurrPoints),

    % Calculate needed points for passing
    MoreInClassNeededToPass is max(0, InClassPassRequirement - InClassCurrPoints),
    MoreOutOfClassNeededToPass is max(0, TotalPassRequirement
                                         - InClassPassRequirement
                                         - OutClassCurrPoints),

    % Max category limits
    SAmax = 100, LAmax = 100, ICAmax = 100,

    % Calculate possible points left
    ICA_Possible is min(0,min(ICAleft, ICAmax - ICA)),
    SA_Possible is min(0,min(SAleft, SAmax - SA)),
    LA_Possible is min(0,min(LAleft, LAmax - LA)),
    InClassPossible is ICA_Possible + FinalExamLeft,
    OutOfClassPossible is SA_Possible + LA_Possible + FPleft
                          + (ExtraMax - Extra),

    
    % Distribute needed more points across in-class and out-of-class.
    % Going to use up OutOfClassPossible first, then InClassPossible.
    MoreOutOfClassNeededForGoal is
        max(MoreOutOfClassNeededToPass,
            min(OutOfClassPossible,
                Goal-MoreInClassNeededToPass-TotalCurrPoints)),
    MoreInClassNeededForGoal is
        max(MoreInClassNeededToPass,
            Goal - MoreOutOfClassNeededForGoal - TotalCurrPoints),

    % Ensure the goal is achievable
    MoreInClassNeededForGoal =< InClassPossible,
    MoreOutOfClassNeededForGoal =< OutOfClassPossible.

% define totalPoints predicate that caps SAtotal, LAtotal, and ICAtotal to 100,
% Extra to 40, and calculates InClassPoints, OutClassPoints, and TotalPoints.
total_points(SAtotal, LAtotal, ICAtotal, MT1, Extra, MT2, FP, FinalExam,
             InClassPoints, OutClassPoints, TotalPoints) :-
    ICA_Capped is min(ICAtotal, 100),
    SA_Capped is min(SAtotal, 100),
    LA_Capped is min(LAtotal, 100),
    Extra_Capped is min(Extra, 40),
    InClassPoints is ICA_Capped + MT1 + MT2 + FinalExam,
    OutClassPoints is SA_Capped + LA_Capped + FP + Extra_Capped,
    TotalPoints is InClassPoints + OutClassPoints.
