function [mat] = generate_imbalanced(c)

Vsize = c; 
Asize = 3*Vsize/4;
Bsize = Vsize/4;

mat = zeros(Vsize, Vsize);

for i = 1:Asize
    for j = 1:Vsize
        mat(i,j) = 1;
    end
end

for i = Asize:Vsize
    r = randsample(Vsize, Vsize/2);
    for j = 1:Vsize/2
        mat(i,r(j)) = 1;
    end
end
        