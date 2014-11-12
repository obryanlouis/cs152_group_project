% Generates a bi-partite graph, represented by its adjacency matrix according
% to a power law distribution for the first half of the graph.

% Input: 
%   n: number of nodes in each half of the graph
%   beta: exponent for the power law
% Output: adjacency matrix
function [mat] = generate_power_law_graph(n, beta)

% Initialize the adjacency matrix. The first n variables are for the
% first half of the graph, and the second n variables are for the second
% half.
mat = zeros(2*n, 2*n);

power_law_coefficients = zeros(1, n);
for k=1:n
    power_law_coefficients(1, k) = k^(-beta);
end

sum_coeff = sum(power_law_coefficients);
degrees = zeros(1, n);
for k=1:n
    degrees(1, k) = floor(power_law_coefficients(1, k) * n / sum_coeff);
end


% Keep track of the degrees of each node
node_degrees = zeros(1, n);

permutation = randperm(n);
ctr = 1;
for k=1:n
    deg = degrees(1, k);
    for l=1:deg
        node_degrees(1, permutation(ctr)) = k;
        ctr = ctr + 1;
    end
end





% Now randomly match up the two halves of the graph. We don't care if the
% second half doesn't follow a power law distribution, only the first half.
for k=1:n
   node_degree = node_degrees(1, k);
   nodes_to_match = randperm(n);
   for l=1:node_degree
       node_to_match = nodes_to_match(l) + n;
       mat(k, node_to_match) = 1;
       mat(node_to_match, k) = 1;
   end
end


end