% Prolog program which defines attributes of patients
% and creates rules which determine what conditions they have
% based on several factors and prescribes a certain treatment
% based on their conditions. A convenient looping predicate called
% getTreatments will allow the user to loop through a menu and try
% a limited number of queries and goals
%
%





% FACTS - Patient Specific

% define list of patients
patient('Eric').
patient('Nikomi').
patient('Pamela').
patient('Roger').
patient('Karissa').
patient('Joey').



% define the heights for patients

height('Eric', 65).
height('Nikomi', 63).
height('Pamela', 66).
height('Roger', 67).
height('Karissa', 42).
height('Joey', 35).



% define the ages for patients

age('Eric', 25).
age('Nikomi', 23).
age('Pamela', 60).
age('Roger', 72).
age('Karissa', 6).
age('Joey', 4).



% define cholesterol for patients

chol_ldl('Eric', 102).
chol_ldl('Nikomi', 114).
chol_ldl('Pamela', 132).
chol_ldl('Roger', 155).
chol_ldl('Karissa', 95).
chol_ldl('Joey', 87).



% define weights for patients

weight('Eric', 172).
weight('Nikomi', 132).
weight('Pamela', 152).
weight('Roger', 186).
weight('Karissa', 72).
weight('Joey', 45).



% define blood pressure for patients

bp('Eric', [108, 75]).
bp('Nikomi', [118, 77]).
bp('Pamela', [133, 83]).
bp('Roger', [140, 88]).
bp('Karissa', [98, 69]).
bp('Joey', [101, 72]).



% define symptoms of patients

hasSymptom('Eric', congestion).
hasSymptom('Eric', sorethroat).
hasSymptom('Eric', coughing).
hasSymptom('Eric', sneezing).
hasSymptom('Eric', pain).

hasSymptom('Nikomi', brokenBone).
hasSymptom('Nikomi', pain).

hasSymptom('Pamela', none).
hasSymptom('Roger', none).
hasSymptom('Karissa', none).
hasSymptom('Joey', none).



% FACTS - Medical Treatment/Conditions


% define treatments for certain conditions

treatment(preHeartDisease, antiplatelets).
treatment(overweight, exercise).
treatment(overweight, diet).
treatment(pain, painkillers).
treatment(brokenBone, cast).
treatment(brokenBone, resetBone).
treatment(flu, decongestant).
treatment(flu, antihistimines).
treatment(highLDL, statins).





% RULES

% define requirements for having the flu

hasFlu(X):-
    hasSymptom(X, congestion),
    hasSymptom(X, sorethroat),
    hasSymptom(X, coughing),
    hasSymptom(X, sneezing),nl,
    write('Patient has the flu'),nl.



% define requirements for having high cholesterol

hasHighChol(X):-
chol_ldl(X, Y),
Y > 129,nl,
write('Patient has high cholesterol'),nl.



% define what qualifies as an overweight patient using BMI

isOverweight(X):-
    weight(X, Y),
    height(X, Z),
    BMI is (Y*(703/(Z*Z))),
    BMI > 25.0,nl,
    write('Patient is overweight'),nl.



% define if the patient is in pain

hasPain(X):-
    hasSymptom(X, pain),nl,
    write('Patient is in pain'),nl.



% define the threshold of high blood pressure based on systolic and diastolic

hasHighBP(X):-
    bp(X, [H, T]),
    H > 129,
    bp(X, [H, T]),
    T > 79,nl,
    write('Patient has high bp'),nl.



% define requirements for being at risk of heart disease

riskHeartDisease(X):-
    isElderly(X),
    hasHighChol(X),
    hasHighBP(X),nl,
    write('Patient is at risk of heart disease'),nl.



% define requirements for a broken bone

hasBrokenBone(X):-
    hasSymptom(X, brokenBone),nl,
    write('Patient has a broken bone'),nl.



% define requirement for being elderly

isElderly(X):-
    age(X, Y),
    Y >= 65,nl,
    write('Patient is elderly'),nl.



% define a rule which checks to see if patient X needs treatment

needsTreatment(X, Y):-
    riskHeartDisease(X),
    treatment(preHeartDisease, Y);
    isOverweight(X),
    treatment(overweight, Y);
    hasPain(X),
    treatment(pain, Y);
    hasBrokenBone(X),
    treatment(brokenBone, Y);
    hasFlu(X),
    treatment(flu, Y);
    hasHighChol(X),
    treatment(highLDL, Y).



% iteratres through the treatments and prints them out

listTreatments:-
    treatment(X, Y), nl,
    format('~w treatment for condition: ~w', [Y, X]), nl.



% iterates through the patients and prints them out
listPatients:-
    patient(X),nl,
    write(X), nl.



% provides a menu for the user to do some simple queries and goals, loops recursively until sentinel value

getTreatments:-
    nl,nl,
    write('Menu'),nl,
    write('Enter 1. to print a list of patients'),nl,
    write('Enter 2. to query a particular patients treatment'),nl,
    write('Enter 3. to print the list of conditions and treatments'),nl,
    write('Enter 4. to verify which patients need a particular treatment'),nl,
    write('Enter 5. to end'),nl,
    read(Choice),nl,
    executeMenu(Choice),
    terminate(Choice);
    getTreatments.



% prints the list of patients currently defined

executeMenu(X):-
    X = 1,
    patient(PatientName),nl,
    write('Patient:'),nl,
    write(PatientName),nl,fail.



% allows the user to check what treatments the chosen patient should recieve

executeMenu(X):-
    X = 2,
    write('Enter the patients name'),nl,
    read(Name),nl,
    needsTreatment(Name, Treatment),
    write(Treatment),nl,fail.



% prints all of the treatments for the defined conditions

executeMenu(X):-
    X = 3,
    treatment(Condition, Treatment),
    format('Condition: ~w', [Condition]),nl,
    format('    Treatment: ~w', [Treatment]),nl,nl,fail.



% allows the user to check to see if a particular patient needs a particular treatment

executeMenu(X):-
    X = 4,
    write('Enter the patients name'),nl,
    read(Name),nl,
    write('Enter the treatment'),nl,
    read(Treatment),nl,
    needsTreatment(Name, Treatment),
    format('~w needs the treatment: ~w', [Name, Treatment]),nl,!;
    X = 4,
    write('The patient does not need that treatment'),nl,fail.



% allows the user to exit the loops

executeMenu(X):-
    X = 5.
terminate(X):-
    X = 5.
