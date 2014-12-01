
function [] = run_mdc_queries() 

num_queries_for_plot = [];
errors_for_plot = [];
% Calculate the expected asymptotic accuracy to graph later
expected_asymptotic_accuracy = [];

for nn=1:20

    num_nodes = 20;
    %num_queries = num_nodes * 10;
    num_queries = nn;
    gamma = 1;
    beta = .025;
    epsilon = .01;
    p_beta = 1.25;
    threshold = 1;
    
    delta = 0.1; % A privacy parameter that we set arbitrarily. Higher values mean lower privacy but higher accuracy.
    input_database = generate_power_law_graph(num_nodes, p_beta);
    reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
    queries = generate_some_queries(num_queries, num_nodes);
    output_database = md_idc_power_law(input_database, epsilon, threshold, num_nodes, queries);
    % Check the results by recording the error on a random query
    index = randi(num_queries, 1, 1);
    random_query = queries{index};
    expected_output = evaluate_query(reshaped_input_database, random_query);
    actual_output = evaluate_query(output_database, random_query);
    error = abs(expected_output - actual_output);
    
    zeta = num_nodes ^ 2;
    max_potentia = sum(sum(input_database));
    
    num_queries_for_plot = [num_queries_for_plot, num_queries];
    errors_for_plot = [errors_for_plot, error];
    s = 2;
    factor_1 = log(num_queries / beta)^(2 / (s + 2));
    factor_2 = (gamma * zeta)^(s / (s + 2));
    factor_3 = (log(1 / delta))^2;
    factor_4 = max_potentia ^ (2 / (s + 2));
    factor_5 = epsilon ^ (s/(s+2));
    expected_accuracy = factor_1 * factor_2 * factor_3 * factor_4 / factor_5;
    expected_asymptotic_accuracy = [expected_asymptotic_accuracy, expected_accuracy];

end

plot(num_queries_for_plot, errors_for_plot);
xlabel('Number of Queries');
ylabel('Actual error (cut size)', 'rot', 0);
title('MD-IDC error');


end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end