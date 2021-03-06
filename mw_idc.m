function [answers] = mw_idc(epsilon, delta, beta, queries, input_database, num_nodes)

% Get the number of queries
num_queries = numel(queries);

% Store a list of answers to the queries
answers = zeros(num_queries, 1);

% Store a list of 0's and 1's to determine if the algorithm fails
w = zeros(num_queries, 1);

% Initialize the synthetic database
S = sum(sum(input_database));
current_output_database = (S/num_nodes^2) * ones(num_nodes^2, 1);

% Set the step size, threshold, and noise parameters
n = num_nodes^2;
M = 2 * num_nodes;
   % (We have M = 2 * num_nodes because
   % num_nodes is the number of nodes in each of the halves of the
   % bi-partite graph)
k = num_queries;
step_size = ((sqrt(log(M)) * log(k / beta) * log(1 / delta))/(epsilon * n))^(1/2);
sigma = 10 * step_size / log ( k / beta );
T = 40 * step_size;
% Set the failure bound
B = step_size^(-2) * log(2 * M); 


% In each round t <- 1,2...,k when receiving a linear query ft do the following:
for t=1:num_queries
   % Sample At <- Lap(?). Compute the noisy answer \hat{a}_t <- f_t(x) + A_t
   A_t = laplacernd(0, sigma, 1); 
   query = queries{t};
   a_t = dot(query, input_database) + A_t;
   % Compute the difference \hat{d}_t <- f_t(x_{t-1}) - \hat{a}_t
   current_output = dot(query, current_output_database);
   d_t = current_output - a_t;
   % If \hat{d}_t <= T then set wt <- 0, xt <- x_{t-1}, output f_t(x_{t-1}), and proceed to the next iteration.
   if abs(d_t) <= T
       w(t) = 0;
       answers(t) = current_output;
   else
       y = zeros(num_nodes^2, 1);
       % If \hat{d}_t > T then set wt <- 1 and:
       w(t) = 1;
       % for all i \in V , update
       for i=1:num_nodes^2
           % y_t[i] <- x_{t-1}[i] * exp(\eta * rt[i]),
           r = query(i);
           if d_t > 0
               r = 1 - query{i};
           end
           y(i)= current_output_database(i) * exp(- step_size * r);
       end
       % Normalize, xt[i] = yt[i] / sum_{i \in V} ( y_t[i] )
       normalization_factor = sum(y);
       current_output_database = y / normalization_factor;
       % If \sum_{j=1}^t w_j < step_size^{-2} * log(M) then abort and output
       % "failure". Otherwise, output the noisy answer \hat{a}_t and
       % proceed to the next iteration
       failure_sum = sum(w(1:t));
       
       if failure_sum > B
           ex = MException('IDC:multiplicativeWeights', 'Multiplicative Weights failed.');
           throw(ex);
       else
           answers(t) = a_t;
       end
   end
   
end


end