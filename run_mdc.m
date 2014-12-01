
function [] = run_mdc() 



num_nodes = 10;
num_queries = num_nodes * 10;
gamma = 1;
beta = .025;
epsilon = .01;
p_beta = 1.25;
threshold = 1;
input_database = generate_power_law_graph(num_nodes, p_beta);
reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
queries = generate_some_queries(num_queries, num_nodes);
output_database = md_idc_power_law(input_database, epsilon, threshold, num_nodes, queries);
% Check the results by recording the error on a random query
index = round(num_queries * rand) + 1;
random_query = queries{index};
expected_output = evaluate_query(reshaped_input_database, random_query);
actual_output = evaluate_query(output_database, random_query);
error = abs(expected_output - actual_output);



end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end