% This function generates an imbalanced bipartite graph.

% The first 3/4 of V1 is connected to all vertices in V2.
% The rest of V1 is connected to half of V2, and these vertices
% are determined by a random sampling.

% Input:
%   c: The cardinality of each vertex set (same for V1 and V2).
% Output:
%   mat: The adjacency matrix showing the edges between vertices.

function [mat] = generate_imbalanced(c)

Vsize = c; 
Asize = 3*Vsize/4;

mat = zeros(Vsize, Vsize);

% For first 3/4 of V1 (aka A), match every vertex in A to every vertex in
% V2.
for i = 1:Asize
    for j = 1:Vsize
        mat(i,j) = 1;
    end
end

% For the other vertices in V1, match every vertex to half of the vertices
% in V2, determined randomly.
for i = Asize:Vsize
    %r = randsample(Vsize, Vsize/2);
    r = randperm(Vsize);
    for j = 1:Vsize/2
        mat(i,r(j)) = 1;
    end
end
        