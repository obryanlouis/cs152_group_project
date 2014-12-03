function [output_database] = multiplicative_weights(input_database, epsilon, queries, num_nodes, threshold)

num_queries = numel(queries);
real_database = input_database;
num_entries = num_nodes^2;
real_database = reshape(real_database, [num_entries, 1]);
output_database = ones(num_entries, 1) / (num_entries);
step_size = 1.65; % something

for t=1:num_queries
    query = queries{t};
    noise = laplacernd(0, 1/epsilon, 1); 
    display(size(query));
    display(size(real_database));
    display(size(output_database));
    noisy_difference = dot(query, real_database) + noise - dot(query, output_database);
    if abs(noisy_difference) > threshold
        rt = zeros(num_entries, 1);
        for j=1:(num_entries)
            if noisy_difference > 0
               rt(j) =  query(j);
            else
                rt(j) = 1 - query(j);
            end
        end
        for j=1:num_entries
           output_database(j) = output_database(j) * exp(-step_size * rt(j)); 
        end
        % Renormalize
        output_database = output_database / sum(output_database);
        
    else
        
    end
end


end