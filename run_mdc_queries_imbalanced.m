
function [] = run_mdc_queries() 

num_queries_for_plot = [];
errors_for_plot = [];

% Use these numbers of queries
qq = [100, 200, 300, 400];
[~, qs] = size(qq);

for nn=1:qs

    num_nodes = 20;
    %num_queries = num_nodes * 10;
    num_queries = qq(nn);
    epsilon = 1;
    threshold = 1024;
    
    input_database = generate_imbalanced(num_nodes);
    reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
    queries = generate_some_queries(num_queries, num_nodes);
    output_database = md_idc_power_law(input_database, epsilon, threshold, num_nodes, queries);
    % Check the results by recording the average error
    avg_error = 0;
    for i=1:num_queries
        query = queries{i};
        expected_output = evaluate_query(reshaped_input_database, query);
        actual_output = evaluate_query(output_database, query);
        error = abs(expected_output - actual_output);
        avg_error = avg_error + error;
    end
    avg_error = avg_error / num_queries;
    errors_for_plot = [errors_for_plot, avg_error];
    num_queries_for_plot = [num_queries_for_plot, num_queries];

end

plot(num_queries_for_plot, errors_for_plot);
xlabel('Number of Queries');
ylabel('Error', 'rot', 0);
title('MD-IDC error');


end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end