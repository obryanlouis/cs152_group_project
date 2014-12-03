
function [] = run_mdc_imbalanced() 

num_nodes_for_plot = [];
md_errors_for_plot = [];
mw_errors_for_plot = [];
% % Calculate the expected asymptotic accuracy to graph later
% expected_asymptotic_accuracy = [];

for nn=1:5

    num_nodes = nn * 20;
    %num_queries = num_nodes * 10;
    num_queries = 1;
    gamma = 1;
    beta = .01;
    epsilon = .01;
    p_beta = 1.25;
    q = log(num_nodes);
    zeta = num_nodes ^ (2 / q);
    p = log(num_nodes) / (log(num_nodes) - 1);
    delta = 0.1; % A privacy parameter that we set arbitrarily. Higher values mean lower privacy but higher accuracy.
    
    input_database = generate_imbalanced(num_nodes);
    reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
    queries = generate_some_queries(num_queries, num_nodes);
    % MD-IDC output database
    output_database = md_idc_power_law(input_database, epsilon, num_nodes, queries, p, beta, delta);
    % Multiplicative weights output database
    mw_output_database = multiplicative_weights(input_database, epsilon, queries, num_nodes, beta, delta);
    
    md_error = 0;
    mw_error = 0;
    for i=1:num_queries
        query = queries{i};
        query_answer = evaluate_query(reshaped_input_database, query);
        md_answer = evaluate_query(output_database, query);
        mw_answer = evaluate_query(mw_output_database, query);
        md_error = md_error + abs(query_answer - md_answer);
        mw_error = mw_error + abs(query_answer - mw_answer);
    end
    % Now take averages
    md_error = md_error / num_queries;
    mw_error = mw_error / num_queries;
    
    % Now record the errors
    num_nodes_for_plot = [num_nodes_for_plot, num_nodes];
    md_errors_for_plot = [md_errors_for_plot, md_error];
    mw_errors_for_plot = [mw_errors_for_plot, mw_error];
    
    
    
    
    
    
%     % Check the results by recording the average error
%     index = randi(num_queries, 1, 1);
%     random_query = queries{index};
%     expected_output = evaluate_query(reshaped_input_database, random_query);
%     actual_output = evaluate_query(output_database, random_query);
%     error = abs(expected_output - actual_output);
%     
%     zeta = num_nodes ^ 2;
%     max_potentia = sum(sum(input_database));
%     
%     num_nodes_for_plot = [num_nodes_for_plot, num_nodes];
%     errors_for_plot = [errors_for_plot, error];
%     s = 2;
%     factor_1 = log(num_queries / beta)^(2 / (s + 2));
%     factor_2 = (gamma * zeta)^(s / (s + 2));
%     factor_3 = (log(1 / delta))^2;
%     factor_4 = max_potentia ^ (2 / (s + 2));
%     factor_5 = epsilon ^ (s/(s+2));
%     expected_accuracy = factor_1 * factor_2 * factor_3 * factor_4 / factor_5;
%     expected_asymptotic_accuracy = [expected_asymptotic_accuracy, expected_accuracy];

end


handle = plot(num_nodes_for_plot, md_errors_for_plot, num_nodes_for_plot, mw_errors_for_plot);
legend('Mirror Descent', 'Multiplicative Weights', 'Location', 'northwest');
xlabel('Graph size (nodes)', 'FontWeight', 'bold');
ylabel('Error', 'rot', 0, 'FontWeight', 'bold');
title('MD-IDC vs MW-IDC Error by Graph Size', 'FontWeight', 'bold', 'fontsize', 14);
set(handle, 'linewidth', 5);

end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end