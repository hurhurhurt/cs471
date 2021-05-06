-module(lab6).

% this attribute exports all functions; meant for devel work, but
% we use in this project to avoid having the add our functions to
% an export list.
-compile(export_all).

perimeter({square, Side}) ->    
    4 * Side;
perimeter({circle, Radius}) ->
    2 * 3.14159 * Radius.

% Use this function to grab some test data: Shapes = lab6:shapes_data().
shapes_data() ->
  [ { square, 2 }, { circle, 1 }, { square, 1 },
    { square, 3 }, { circle, 2 }, { square, 4 }
  ].

% Use this function to grab some test data: Grades = lab6:grades_data().
grades_data() ->
  [ {bill, 82.0}, {sue, 95}, { john, 85},
    { joe, 73 }, { mary, 65}, { tom, 55}
  ].


%% Exercise 2
guard_perimeter({Type, L}) when Type =:= square ->
    4 * L;
guard_perimeter({Type, L}) when Type =:= circle ->
    2 * 3.14159 * L.

if_perimeter({Type, L}) ->
    if Type =:= square -> 4 * L;
       Type =:= circle -> 2 * 3.14159 * L
    end.

case_perimeter(Shape) ->
    case Shape of
        {square, Side} -> 4 * Side;
        {circle, Radius} -> 2 * 3.14159 * Radius
    end.

letter_grade(Points) when Points > 90 -> "A";
letter_grade(Points) when Points =< 90, Points > 80 -> "B";
letter_grade(Points) when Points =< 80, Points > 70 -> "C";
letter_grade(Points) when Points =< 70, Points > 60 -> "D";
letter_grade(Points) when Points < 60 -> "F".

if_letter_grade(Points) ->
    if Points > 90 -> "A";
       Points =< 90, Points > 80 -> "B"; 
       Points =< 80, Points > 70 -> "C";
       Points =< 70, Points > 60 -> "D";
       Points < 60 -> "F"
    end.
   
%% Exercise 3.
shape_types(Shapes) ->
    lists:map(fun({Type, _}) -> Type end, Shapes).

perimeters(Shapes) ->
    lists:map(fun perimeter/1, Shapes).

sum_perimeters(Shapes) ->
    Perims = perimeters(Shapes),
    lists:foldl(fun (P, Acc) -> P + Acc end, 0, Perims).

average_perimeter([]) -> 0;
average_perimeter([_|_]=Shapes) ->  sum_perimeters(Shapes) / length(Shapes).

grade_points(Points) ->
    lists:map(fun({_, Grade}) -> Grade end, Points).

names(Points) ->
    lists:map(fun({Name, _}) -> Name end, Points).

letter_grades(Points) ->
    points_list = grade_points(Points),
    names_list = names(Points),
    grade_list = lists:map(fun letter_grade/1, points_list),
    lists:map({names_list, grade_list}).

%% Exercise 4

data_server(Data) ->
    receive                  
    { ClientPid, Fn } ->
	    Result = Fn(Data),
	    ClientPid !  { self(), Result },
	    data_server(Data);
	stop ->                
	    true                 
    end. 

data_client(ServerPid, Fn) ->
    ServerPid ! { self(), Fn },
    receive
	{ _, Result } ->
	    Result    
    end. 

start_data_server(Data) ->
    spawn(lab6, data_server, [Data]).
stop_data_server(ServerPid) ->
    ServerPid ! stop.
