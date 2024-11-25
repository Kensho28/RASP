function G = generateRASPDAG()
    % Define the number of possible states
    num_values = 3; % Three possible values for each register
    num_lines = 6; % Six lines in the RASP program
    num_states = num_values^3 * num_lines; % Total states
    
    % Initialize the transition matrix
    G = sparse(num_states, num_states);
    
    % Fill the transition matrix based on the RASP instructions
    for r1 = 1:num_values
        for r2 = 1:num_values
            for r3 = 1:num_values
                for line = 1:num_lines
                    current_state = stateIndex(r1, r2, r3, line, num_values);
                    switch line
                        case 1 % CMP R1, R2
                            if r1 <= r2
                                next_state = stateIndex(r1, r2, r3, 5, num_values);
                                G(current_state, next_state) = 1;
                            else
                                next_state = stateIndex(r1, r2, r3, 3, num_values);
                                G(current_state, next_state) = 1;
                            end
                        case 3 % SET R3, 1
                            next_state = stateIndex(r1, r2, 3, 4, num_values); % R3 set to 1 (third value in MATLAB is 3)
                            G(current_state, next_state) = 1;
                        case 4 % JMP 6
                            next_state = stateIndex(r1, r2, r3, 6, num_values);
                            G(current_state, next_state) = 1;
                        case 5 % SET R3, 0
                            next_state = stateIndex(r1, r2, 1, 6, num_values); % R3 set to 0 (third value in MATLAB is 1)
                            G(current_state, next_state) = 1;
                        case 6 % END
                            next_state = stateIndex(r1, r2, r3, 6, num_values);
                            G(current_state, next_state) = 1;
                    end
                end
            end
        end
    end
end

function index = stateIndex(r1, r2, r3, line, num_values)
    % Convert state (r1, r2, r3, line) to an index
    index = ((r1-1) * num_values^2 + (r2-1) * num_values + (r3-1)) * 6 + line;
end

