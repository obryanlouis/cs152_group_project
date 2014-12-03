
function [queries] = generate_sized_queries(num_queries, num_nodes, cut_size)
queries = {};
for z=1:num_queries
    % Generate a new query
    perm1 = randperm(num_nodes);
    perm2 = randperm(num_nodes);
    query = zeros(num_nodes^2, 1);
    for i=1:cut_size
        index1 = perm1(i);
        for j=1:cut_size
            index2 = perm2(j);
            query((index1 - 1) * num_nodes + index2, 1) = 1;
        end
    end
    queries{z} = query;
end
end