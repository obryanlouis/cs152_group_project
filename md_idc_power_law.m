% This script runs the MD-IDC algorithm on the power law graph.

function [output_database] = md_idc_power_law(input_database, epsilon, num_nodes, queries, p, beta, delta)

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
        
        n = num_nodes ^2;
        cvx_begin
            variable x(n)
            %minimize( sum_square_abs (x) + sum_square_abs (current_output_database) - 2 * dot(x, current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            %minimize( square_pos(norm( x, p )) + square_pos(norm( current_output_database, p)) - 2 * dot(x, current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            %minimize( square_pos(norm(x, p)) - square_pos(norm(current_output_database, p)) - dot(2 * current_output_database, x - current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            minimize( group_norm(x, 2, p, num_nodes) - group_norm(x, 2, p, num_nodes) - dot(2 * current_output_database, x - current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            subject to
                norm(x) <= norm_of_real_database
        cvx_end
        
        current_output_database = x;
        
    end
    
end

output_database = current_output_database;
end



function [output]= group_norm(database, p, q, num_nodes) 

sum = 0;
for i=1:num_nodes
    sum = sum + pow_p(norm(database((i-1)*num_nodes + 1:i * num_nodes, 1), p), q);
end
output = sum^(1/q);

end

