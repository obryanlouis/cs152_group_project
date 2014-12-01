
function [queries] = generate_some_queries(num_queries, num_nodes)
queries = {};
for z=1:num_queries
    % Generate a new query
    subset1 = round(rand(1, num_nodes));
    subset2 = round(rand(1, num_nodes));
    query = zeros(num_nodes^2, 1);
    for i=1:num_nodes
        if subset1(i) == 1
            for j=1:num_nodes
                if subset2(j) == 1
                    query((i - 1) * num_nodes + j, 1) = 1;
                end
            end
        end
    end
    queries{z} = query;
end
end