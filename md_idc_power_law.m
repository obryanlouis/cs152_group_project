% This script runs the MD-IDC algorithm on the power law graph.
% Linear cut queries are randomly generated

function [output_database] = md_idc_power_law(input_database, epsilon, threshold, num_nodes, queries)

real_database = input_database;
real_database = reshape(real_database, [num_nodes^2, 1]);
norm_of_real_database = norm(real_database);
zeta = sum(sum(real_database));
zeta = zeta ^ (1 / 2);
step_size = (threshold / 2) / (4 * zeta ^ 2);
current_output_database = [];


num_queries = numel(queries);

for t=0:num_queries
    
    
    if t == 0
        current_output_database = zeros(num_nodes ^ 2, 1);
    else
        
        query = queries{t};
        
        noise = laplacernd(0, 1/epsilon, 1);
        display(size(query));
        display(size(real_database));
        display(size(current_output_database));
        noisy_difference = sign(dot(query, real_database) + noise - dot(query, current_output_database));
        sign_of_noisy_difference = sign(noisy_difference);
        
        n = num_nodes ^2;
        cvx_begin
            variable x(n)
            minimize( sum_square_abs (x) + sum_square_abs (current_output_database) - 2 * dot(x, current_output_database) - step_size * sign_of_noisy_difference * dot(query, x - current_output_database)  )
            subject to
                norm(x) <= norm_of_real_database
        cvx_end
        
        current_output_database = x;
        
    end
    
end

output_database = current_output_database;
end



