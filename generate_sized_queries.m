% This function generates linear cut queries of a given size. The
% 'cut_size' argument specifies how large each subset from each half of the
% bipartite graph should be (they are the same in our setup).

% Input:
%   num_queries: The number of queries to generate
%   num_nodes: The number of nodes in one half of the bipartite graph
%   cut_size: The size of the subsets from each half of the graph
% Output:
%   A list collection of cut queries, represented by vectors of 1's and 0's
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