% This script runs the MD-IDC algorithm on a graph

function [answers] = md_idc(epsilon, delta, beta, queries, input_database, num_nodes)

% Set the norm parameter
p = 2;

% Get the number of queries
num_queries = numel(queries);

% Reshape the input database into a vector
real_database = reshape(input_database, [num_nodes^2, 1]);

% Record the norm of the real database
norm_of_real_database = norm(real_database, p);

% Store a list of answers to the queries
answers = zeros(num_queries, 1);

% Initialize the current output database
current_output_database = zeros(num_nodes^2, 1);

% Set the step size, threshold, and noise parameters
n = num_nodes^2;
M = 2 * num_nodes;
   % (We have M = 2 * num_nodes b/c
   % num_nodes is the number of nodes in each of the halves of the
   % bi-partite graph)
k = num_queries;
B = 9; % DEBUG
epsilon_0 = epsilon  / ( 100 * sqrt(B) * log ( 4 / delta ) );
T = 4 / epsilon_0 * log(2 * k / beta);
T = 10; % DEBUG
maximal_query = ones(num_nodes^2, 1);
zeta = norm(maximal_query, 2);
step_size = T / 8 / (zeta^2);
step_size = 2; % DEBUG


% Initialize a counter for the update bound
counter = 0;

for t=1:num_queries
    % Sample from Laplace noise
    A_t = laplacernd(0, epsilon_0, 1);
    % True response
    query = queries{t};
    a_t = dot(query, real_database);
    % Noisy response
    hat_a_t = a_t + A_t;
    % Current output
    current_output = dot(query, current_output_database);
    % Noisy response
    noisy_difference = hat_a_t - current_output;
    % If the absolute value of the noisy response exceeds the threshold
    if abs(noisy_difference) > T
        % Increment the counter
        counter = counter + 1;
        if counter > B
           ex = MException('IDC:mirrorDescent', 'Mirror Descent failed.');
           throw(ex);
        end
        % Update the database
        sign_of_noisy_difference = sign(noisy_difference);
        cvx_begin
            variable x(n)
            minimize( square_pos(norm(x, p)) - square_pos(norm(current_output_database, p)) - dot(2 * current_output_database, x - current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            subject to
                norm(x, p) <= norm_of_real_database
        cvx_end
        current_output_database = x;        
        
        % Output the noisy answer as the query response
        answers(t) = hat_a_t;
    else
       % No update to the current database
       answers(t) = current_output;
    end
end

end



function [output] = group_norm(database, p, q, num_nodes) 

reshaped_database = reshape(database, [num_nodes, num_nodes]);
norms1 = norms(reshaped_database, p, 2);
output = sum(norms1);

end
