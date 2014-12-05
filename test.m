
function [output_database] = test(input_database, epsilon, num_nodes, queries, p, beta, delta)

num_queries = numel(queries);
real_database = input_database;
real_database = reshape(real_database, [num_nodes^2, 1]);
norm_of_real_database = norm(real_database, p);

maximal_query = ones(num_nodes^2, 1);
p_star = p / (p - 1);
zeta = group_norm(maximal_query, 2, p_star, num_nodes);

num_entries = num_nodes ^ 2;
threshold = 40 * sqrt((sqrt(num_nodes)* log(num_queries / beta) * log(1 / delta))/(epsilon * num_entries));
step_size = (threshold / 2) / (4 * zeta ^ 2);
current_output_database = [];




for t=0:num_queries
    
    
    if t == 0
        current_output_database = zeros(num_nodes ^ 2, 1);
    else
        
        query = queries{t};
        
        noise = laplacernd(0, 1/epsilon, 1);
        noisy_difference = dot(query, real_database) + noise - dot(query, current_output_database);
        sign_of_noisy_difference = sign(noisy_difference);
        
        
        % Yalmip
        % Define variables
        x = sdpvar(num_nodes^2,1);
        % Define constraints and objective
        Constraints = (norm(x) <= norm_of_real_database);
        Objective = group_norm(x, 2, p, num_nodes) + group_norm(x, 2, p, num_nodes) - dot(2 * current_output_database, x - current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database);
        % Set some options for YALMIP and solver
        options = sdpsettings('verbose', 1);
        % Solve the problem
        sol = optimize(Constraints,Objective,options);
        % Analyze error flags
        if sol.problem == 0
         % Extract and display value
         solution = value(x)
        else
         display('Hmm, something went wrong!');
         sol.info
         yalmiperror(sol.problem)
        end

        
        current_output_database = solution;
        
    end
    
end

output_database = current_output_database;
end


function [output] = group_norm(database, p, q, num_nodes) 

reshaped_database = reshape(database, [num_nodes, num_nodes]);
norms1 = sum_square_pos(reshaped_database');
%norms1 = norms(reshaped_database, p, 2);
output = norm(norms1, q);

end


