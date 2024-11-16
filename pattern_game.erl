-module(pattern_game).
-export([start/0]).

% Start the game
start() ->
    io:format("Welcome to the Pattern Matching Game!~n"),
    Pattern = [red, blue, green],  % Predefined pattern
    io:format("Try to guess the color pattern (e.g., [red, blue, green]).~n"),
    game_loop(Pattern, 0).

% Game loop
game_loop(Pattern, Attempts) ->
    io:format("Enter your guess: "),
    case catch io:fread("", "~w") of
        {ok, [Guess]} when is_list(Guess) ->
            validate_guess(Pattern, Guess, Attempts + 1);
        _ ->
            io:format("Invalid input. Please enter a list of colors.~n"),
            game_loop(Pattern, Attempts)
    end.

% Validate the player's guess
validate_guess(Pattern, Guess, Attempts) ->
    case Guess == Pattern of
        true ->
            io:format("Congratulations! You guessed the pattern in ~p attempts.~n", [Attempts]);
        false ->
            Clues = generate_clues(Pattern, Guess),
            io:format("Incorrect. Clues: ~p~n", [Clues]),
            game_loop(Pattern, Attempts)
    end.

% Generate clues for the player's guess
generate_clues(Pattern, Guess) ->
    lists:map(
        fun(X) ->
            case X of
                {Color, Color} -> correct;
                {_, _} -> wrong_position;
                _ -> not_in_pattern
            end
        end,
        zip_lists(Pattern, Guess)
    ).

% Helper: Zip two lists together
zip_lists([], []) -> [];
zip_lists([H1 | T1], [H2 | T2]) -> [{H1, H2} | zip_lists(T1, T2)];
zip_lists(_, _) -> [].

% Exception handling for invalid input
validate_guess(_, _, _) ->
    io:format("Error: Invalid input. Please guess using a list of colors.~n"),
    ok.
