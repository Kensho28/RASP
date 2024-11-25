function G = generateRASPDAG2()
%function G = generateRASPTransitionMatrix()
    % Define the number of possible states
    num_values = 3; % Three possible values for each register
    num_lines = 7; % Seven lines in the RASP program
    num_states = num_values^2 * num_lines; % Total states
    
    % Initialize the transition matrix
    G = sparse(num_states, num_states);
    
    % Fill the transition matrix based on the RASP instructions
    for r1 = 1:num_values
        for r2 = 1:num_values
            for line = 1:num_lines
                current_state = stateIndex(r1, r2, line, num_values);
                switch line
                    case 1 % LOAD x, R1
                        for x = 1:num_values
                            next_state = stateIndex(x, r2, 2, num_values);
                            G(current_state, next_state) = 1;
                        end
                    case 2 % LOAD c, R2
                        for c = 1:num_values
                            next_state = stateIndex(r1, c, 3, num_values);
                            G(current_state, next_state) = 1;
                        end
                    case 3 % CMP R1, R2
                        if r1 <= r2
                            next_state = stateIndex(r1, r2, 6, num_values);
                        else
                            next_state = stateIndex(r1, r2, 5, num_values);
                        end
                        G(current_state, next_state) = 1;
                    case 5 % SET R1, 1
                        next_state = stateIndex(3, r2, 7, num_values); % R1 set to 1 (third value in MATLAB is 3)
                        G(current_state, next_state) = 1;
                    case 6 % SET R1, 0
                        next_state = stateIndex(1, r2, 7, num_values); % R1 set to 0 (first value in MATLAB is 1)
                        G(current_state, next_state) = 1;
                    case 7 % END
                        next_state = stateIndex(r1, r2, 7, num_values);
                        G(current_state, next_state) = 1;
                end
            end
        end
    end
    
    % Normalize the transition matrix to ensure determinism
    for i = 1:size(G, 1)
        if nnz(G(i, :)) > 1
            non_zero_indices = find(G(i, :));
            G(i, :) = 0;
            G(i, non_zero_indices(1)) = 1;
        end
    end
end

function index = stateIndex(r1, r2, line, num_values)
    % Convert state (r1, r2, line) to an index
    index = ((r1-1) * num_values + (r2-1)) * 7 + line;
end

% Generate the transition matrix
%G = generateRASPTransitionMatrix();

% Check the out-degree of each state
%out_degrees = sum(G, 2);
%assert(all(out_degrees == 1), 'The transition matrix is not deterministic. Some states have more tha

