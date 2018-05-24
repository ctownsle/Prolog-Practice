
get_individual_spaces([A, B, C], Z) :-
    B > 0,
    B1 is B - 1,
    get_individual_spaces([A, B1, C], R),
    X is A + B,
    get_column_spaces(X, C, R2),
    append(R2, R, Z).

get_individual_spaces([_, 0, _], Z) :-
    Z = [].

obstacle_spaces([L|R], X) :-
    obstacle_spaces(R, Y), 
    get_individual_spaces(L, Res),
    append(Res,Y, Z),
    build_hooman([V]),
    append(V, Z, X).

obstacle_spaces(_, X) :-
    X = [].

get_column_spaces(A, B, R) :-
    B > 0,
    B1 is B - 1,
    get_column_spaces(A, B1, R1),
    B2 is 11 - B,
    R = [[A, B2]|R1].
get_column_spaces(_, 0, R) :-
    R = [].

get_laser_points(A, S, E) :-
    S = [1, A], 
    E = [12, A].

place_mirrors(A, B, R) :-
    get_laser_points(A, S, E),
    next_direction(S, B, A, 'RIGHT', 0, R).

next_direction([A, B], J, Q, 'RIGHT', Size, N) :-
    A1 is A + 1,
    State = 'RIGHT',
    A1 < 12, 
    not(check_position([A1, B], J)),
    next_direction([A1, B], J, Q, State, Size, Z),
    append(Z, [], N).

next_direction([A, B], J, Q, 'UP', Size, N) :-
    A1 is A + 1,
    State = 'RIGHT',
    A1 < 12,
    not(check_position([A1, B], J)),
    %place mirror
    R = [[A, B, '/']],
    Size1 is Size + 1,
    Size1 < 9, 
    %N = [A1, B],
    next_direction([A1, B], J, Q, State, Size1, Z),
    append(Z, R, N).

next_direction([A, B], J, Q, 'DOWN', Size, N) :-
    A1 is A + 1,
    State = 'RIGHT',
    A1 < 12,
    not(check_position([A1, B], J)),
    %place mirror
    R = [[A, B, '\\']],
    Size1 is Size + 1,
    Size1 < 9,
    next_direction([A1, B], J, Q, State, Size1, Z),
    append(Z, R, N).

next_direction([A,B], J, Q, 'UP', Size, N) :-
    % Up, down, right
    A < 11,
    B1 is B + 1,
    State = 'UP',
    B1 < 8,
    % check if position is in obstacle positions
    not(check_position([A, B1], J)),
    next_direction([A, B1], J, Q, State, Size, Z),
    append(Z, [], N).

next_direction([A,B], J, Q, 'RIGHT', Size, N) :-
    % Up, down, right
    A < 11,
    State = 'UP',
    B1 is B + 1,
    B1 < 8,
    % check if position is in obstacle positions
    not(check_position([A,B1], J)),
    %place mirror
    R = [[A, B, '/']],
    Size1 is Size + 1,
    Size1 < 9,
    next_direction([A, B1], J, Q, State, Size1, Z),
    append(Z, R, N).
    %N = [A, B1].

next_direction([A,B], J, Q, 'DOWN', Size, N) :-
    A < 11,
    B1 is B - 1,
    B1 > 0,
    State = 'DOWN',
    not(check_position([A, B1], J)),
    %N = [A, B1].
    next_direction([A, B1], J, Q, State, Size, Z),
    append(Z, [], N).

next_direction([A,B], J, Q, 'RIGHT', Size, N) :-
    A < 11,
    B1 is B - 1,
    State = 'DOWN',
    B1 > 0,
    not(check_position([A, B1], J)),
    %place mirror
    R = [[A, B, '\\']],
    Size1 is Size + 1,
    Size1 < 9,
    next_direction([A, B1], J, Q, State, Size1, Z),
    append(Z, R, N).

next_direction([11, B], J, Q, 'UP', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    nth0(0, T, Jeff),
    B == Jeff,
    %place mirror
    R = [[11, B, '/']],
    Size1 is Size + 1,
    Size1 < 9,
    append(R, [], N).
   % N = [12, B].

next_direction([11, B], J, Q, 'DOWN', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    nth0(0, T, Jeff),
    B == Jeff,
    %place mirror
    R = [[11, B, '\\']],
    Size1 is Size + 1,
    Size1 < 9,
    append(R, [], N).
    %N = [12, B].

next_direction([11, B], J, Q, 'RIGHT', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    nth0(0, T, Jeff),
    B == Jeff,
    N = [].

next_direction([11, B], J, Q, 'RIGHT', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    B < T,
    State = 'UP',
    B1 is B + 1,
    R = [[11, B, '/']],
    Size1 is Size + 1,
    Size1 < 9,
    next_direction([11, B1], J, Q, State, Size1, Z),
    append(Z, R, N).

next_direction([11, B], J, Q, 'UP', Size, N) :-
   get_laser_points(Q, _, [H|T]),
    B < T,
    State = 'UP',
    B1 is B + 1,
    next_direction([11, B1], J, Q, State, Size, Z),
    append(Z, [], N).

next_direction([11, B], J, Q, 'RIGHT', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    B > T, 
    State = 'DOWN',
    B1 is B - 1,
    R = [[11, B, '\\']],
    Size1 is Size + 1,
    Size1 < 9,
    next_direction([11, B1], J, Q, State, Size1, Z),
    append(Z, R, N).
next_direction([11, B], J, Q, 'DOWN', Size, N) :-
    get_laser_points(Q, _, [H|T]),
    B > T, 
    State = 'DOWN',
    B1 is B - 1,
    next_direction([11, B1], J, Q, State, Size, Z),
    append(Z, [], N).

check_position([A, B], J) :-
    obstacle_spaces(J, X), 
    member([A, B], X).
    
build_hooman([V]) :-
    V = [[3,1],[3,2], [3,3], [3,4], [3, 5], [3,6], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6]].
%build_hooman([V]) :-
%    V = [[4,1], [4,2], [4,3], [4,4], [4,5], [4,6], [5,1], [5,2], [5,3], [5,4], [5,5], [5,6]].
%build_hooman([V]) :-
%    V = [[5,1], [5,2], [5,3], [5,4], [5,5], [5,6], [6,1], [6,2], [6,3], [6,4], [6,5], [6,6]].
%build_hooman([V]) :-
%    V = [[6,1], [6,2], [6,3], [6,4], [6,5], [6,6], [7,1], [7,2], [7,3], [7,4], [7,5], [7,6]].
%build_hooman([V]) :-
%    V = [[7,1], [7,2], [7,3], [7,4], [7,5], [7,6], [8,1], [8,2], [8,3], [8,4], [8,5], [8,6]].
%build_hooman([V]) :-
%   V = [[8,1], [8,2], [8,3], [8,4], [8,5], [8,6], [9,1], [9,2], [9,3], [9,4], [9,5], [9,6]].
%build_hooman([V]) :-
%   V = [[9,1], [9,2], [9,3], [9,4], [9,5], [9,6], [10, 1], [10, 2], [10,3], [10,4], [10,5], [10,6]].