% Constraints on various possible grades in 372.
/*
Example query:
?- SAs=[15,0,15], LAs=[0],  ICAs=[20], MT1=50, Extra=0,
sum(SAs,SAtotal), sum(LAs,LAtotal), sum(ICAs,ICAtotal),
toPass(SAtotal, LAtotal, ICAtotal, MT1, Extra,
       InClassNeeded, InClassLeft, OutofClassNeeded, OutOfClassLeft).
SAs = [15, 0, 15],
LAs = [0],
ICAs = [20],
MT1 = 50,
Extra = LAtotal, LAtotal = 0,
SAtotal = 30,
ICAtotal = 20,
InClassNeeded = 290,
InClassLeft = 450,
OutofClassNeeded = 210,
OutOfClassLeft = 390.

?- SAs=[15,0,15], LAs=[0],  ICAs=[20], MT1=50, Extra=0, X=600,
sum(SAs,SAtotal), sum(LAs,LAtotal), sum(ICAs,ICAtotal),
toGetAtLeastXPoints(SAtotal, LAtotal, ICAtotal, MT1, Extra, X,
                    InClassPointsNeededToPass, PointsLeftNeededForX,
                    InClassPointsNeededForX, InClassPointsLeftPossible,
                    OutOfClassPointsNeededForX, OutOfClassPointsLeftPossible).
SAs = [15, 0, 15],
LAs = [0],
ICAs = [20],
MT1 = 50,
Extra = LAtotal, LAtotal = 0,
X = 600,
SAtotal = 30,
ICAtotal = 20,
InClassPointsNeededToPass = InClassPointsNeededForX, InClassPointsNeededForX = 290,
PointsLeftNeededForX = OutOfClassPointsNeededForX, OutOfClassPointsNeededForX = 210,
InClassPointsLeftPossible = 450,
OutOfClassPointsLeftPossible = 390.

?- SAs=[15,0,15], LAs=[0],  ICAs=[20], MT1=50, Extra=0, X=700,
sum(SAs,SAtotal), sum(LAs,LAtotal), sum(ICAs,ICAtotal),
toGetAtLeastXPoints(SAtotal, LAtotal, ICAtotal, MT1, Extra, X,
                    InClassPointsNeededToPass, PointsLeftNeededForX,
                    InClassPointsNeededForX, InClassPointsLeftPossible,
                    OutOfClassPointsNeededForX, OutOfClassPointsLeftPossible).
*/

toPass(SAcurrent, LAcurrent, ICAcurrent, MT1, Extra,
       InClassPointsNeeded, InClassPointsLeftPossible,
       OutOfClassPointsNeeded, OutOfClassPointsLeftPossible) :-
    SAleft=75, LAleft=80, FPleft=200, ICAleft=50, MT2left=200, FinalExamLeft=200,
    SAmax=100, LAmax=100, ICAmax=100, ExtraMax=40,
    InClassPointsNeeded is 360 - (min(ICAcurrent,100)+MT1),
    OutOfClassPointsNeeded is
        (600-360) - (min(SAcurrent,100)+min(LAcurrent,100)+Extra),
    SAcurrent>=0, LAcurrent>=0, ICAcurrent>=0,
    ICApossible is min(ICAleft, ICAmax-ICAcurrent),
    SApossible is min(SAleft, SAmax-SAcurrent),
    LApossible is min(LAleft, LAmax-LAcurrent),
    InClassPointsLeftPossible is ICApossible + MT2left + FinalExamLeft,
    OutOfClassPointsLeftPossible is SApossible + LApossible + FPleft + (ExtraMax-Extra),
    InClassPointsNeeded =< InClassPointsLeftPossible,
    OutOfClassPointsNeeded =< OutOfClassPointsLeftPossible.

toGetAtLeastXPoints(SAcurrent, LAcurrent, ICAcurrent, MT1, Extra,
                    X, InClassPointsNeededToPass, OutOfClassPointsNeededToPass,
                    InClassPointsNeededForX, InClassPointsLeftPossible,
                    OutOfClassPointsNeededForX, OutOfClassPointsLeftPossible) :-
    toPass(SAcurrent, LAcurrent, ICAcurrent, MT1, Extra,
           InClassPointsNeededToPass, InClassPointsLeftPossible,
           OutOfClassPointsNeededToPass, OutOfClassPointsLeftPossible),
    MorePointsNeededForX is max(0, X - 600),
    PointsLeftNeededForX is MorePointsNeededForX + InClassPointsNeededToPass 
                            + OutOfClassPointsNeededToPass,
    AdditionalInClassPointsNeededForX
      is max(0, MorePointsNeededForX
                - (OutOfClassPointsLeftPossible
                   -OutOfClassPointsNeededToPass)),
    InClassPointsNeededForX is AdditionalInClassPointsNeededForX
                               +InClassPointsNeededToPass,
    OutOfClassPointsNeededForX is PointsLeftNeededForX
                                  -InClassPointsNeededForX,
    InClassPointsNeededForX =< InClassPointsLeftPossible,
    OutOfClassPointsNeededForX =< OutOfClassPointsLeftPossible,
    PointsLeftNeededForX =< InClassPointsLeftPossible+OutOfClassPointsLeftPossible.

% define testsScore predicate that calculates the total score for tests
testsScore(ICAtotal, MT1, MT2, FinalExam, Tests) :-
    Tests is ICAtotal + MT1 + MT2 + FinalExam.

% define totalPoints predicate that limits SAtotal and LAtotal to 100
% and calculates Tests, Homework, and Extra categories.
totalPoints(SAtotal, LAtotal, ICAtotal, MT1, Extra, MT2, FP, FinalExam, Tests, Homework, TotalPoints) :-
    MaxSAtotal is min(SAtotal, 100),
    MaxLAtotal is min(LAtotal, 100),
    Homework is MaxSAtotal + MaxLAtotal + FP,
    testsScore(ICAtotal, MT1, MT2, FinalExam, Tests),
    TotalPoints is Tests + Homework + Extra.


%%% Helper routines for calculating grades.
% Given a list of grades, calculate the sum of the grades.
sum([], 0).
sum([H|T], S) :- sum(T, S1), S is S1 + H.
