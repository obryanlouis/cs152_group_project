
function [] = run_mdc_imbalanced() 

num_nodes_for_plot = [];
md_errors_for_plot = [];
mw_errors_for_plot = [];
max_errors_for_plot = [];
% % Calculate the expected asymptotic accuracy to graph later
% expected_asymptotic_accuracy = [];

for nn=1:5

    % Initialize a variable that determines whether both MW-IDC and MD-IDC
    % are successful
    successful = 0;
    
    % While we have yet to succeed for this database size
    while successful == 0 
       try
    
            num_nodes = nn * 4; 
            %num_queries = num_nodes * 10;
            num_queries = 30;
            cut_size = min(10, num_nodes);
            beta = .1;
            epsilon = .1;
            p_beta = 1.25;
            %p = log(num_nodes)  / (log(num_nodes) - 1);
            delta = 0.1; % A privacy parameter that we set arbitrarily. Higher values mean lower privacy but higher accuracy.

            input_database = generate_imbalanced(num_nodes);
            reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
            %queries = generate_some_queries(num_queries, num_nodes);
            queries = generate_sized_queries(num_queries, num_nodes, cut_size);
            % Multiplicative weights 
            mw_answers = hr_multiplicative_weights(epsilon, delta, beta, queries, reshaped_input_database, num_nodes);
            % MD-IDC output database
            md_answers = md_idc_power_law(epsilon, delta, beta, queries, input_database, num_nodes);
            %output_database = test(input_database, epsilon, num_nodes, queries, p, beta, delta);
            
            
            %mw_output_database = multiplicative_weights(input_database, epsilon, queries, num_nodes, beta, delta);

            md_error = 0;
            mw_error = 0;
            avg_query_answer = 0;
            for i=1:num_queries
                query = queries{i};
                query_answer = evaluate_query(reshaped_input_database, query);
                avg_query_answer = avg_query_answer + query_answer;
                %md_answer = evaluate_query(output_database, query);
                md_answer = md_answers(i);
                %mw_answer = evaluate_query(mw_output_database, query);
                mw_answer = mw_answers(i);
                md_error = md_error + abs(query_answer - md_answer);
                mw_error = mw_error + abs(query_answer - mw_answer);
            end
            % Now take averages
            md_error = md_error / num_queries;
            mw_error = mw_error / num_queries;
            avg_query_answer = avg_query_answer / num_queries;

            % Now record the errors
            num_nodes_for_plot = [num_nodes_for_plot, num_nodes];
            md_errors_for_plot = [md_errors_for_plot, md_error];
            mw_errors_for_plot = [mw_errors_for_plot, mw_error];
            max_errors_for_plot = [max_errors_for_plot, avg_query_answer];
            
            successful = 1;

    
       catch
       end
    end
    
    
    
    
end


handle = plot(num_nodes_for_plot, md_errors_for_plot, num_nodes_for_plot, mw_errors_for_plot);
legend('Mirror Descent', 'Multiplicative Weights', 'Location', 'northwest');
xlabel('Graph size (nodes)', 'FontWeight', 'bold');
ylabel('Error', 'rot', 0, 'FontWeight', 'bold');
title('MD-IDC vs MW-IDC Error for Imbalanced Graphs', 'FontWeight', 'bold', 'fontsize', 14);
set(handle, 'linewidth', 2);

end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end