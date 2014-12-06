
function [] = make_asymptotic_graph() 

num_nodes_for_plot = [];
md_errors_for_plot = [];

% Calculate the expected asymptotic accuracy to graph later
expected_asymptotic_accuracy = [];

for nn=1:20

    % Initialize a variable that determines whether both MW-IDC and MD-IDC
    % are successful
    successful = 0;
    
    % While we have yet to succeed for this database size
    while successful == 0 
       %try
    
            num_nodes = nn * 4; 
            num_queries = 30;
            cut_size = min(10, num_nodes);
            beta = .1;
            epsilon = .01;
            delta = 0.1;

            input_database = generate_imbalanced(num_nodes);
            reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
            queries = generate_sized_queries(num_queries, num_nodes, cut_size);
            % MD-IDC output database
            md_answers = md_idc(epsilon, delta, beta, queries, input_database, num_nodes);
            
            md_error = 0;
            for i=1:num_queries
                query = queries{i};
                query_answer = evaluate_query(reshaped_input_database, query);
                md_answer = md_answers(i);
                md_error = md_error + abs(query_answer - md_answer);
            end
            % Now take averages
            md_error = md_error / num_queries;
            
            % Now record the errors
            num_nodes_for_plot = [num_nodes_for_plot, num_nodes];
            md_errors_for_plot = [md_errors_for_plot, md_error];
            
            % Now calculate the expected asymptotic accuracy
            k = num_queries;
            maximal_query = ones(num_nodes^2, 1);
            zeta = norm(maximal_query, 2);
            max_potential = norm(maximal_query, 2)^2;
            expected = log(k / beta)^(1/2) * zeta^(1/2) * log(1/delta)^2 * max_potential^(1/4) / epsilon^(1/2);
            expected_asymptotic_accuracy = [expected_asymptotic_accuracy, expected];
            
            
            successful = 1;

    
       %catch
       %end
    end
    
end

% Now calculate the ratios of the real error to the asymptotic error
values_to_plot = md_errors_for_plot;
[~, num_vals] = size(values_to_plot);
for i=1:num_vals
    values_to_plot(i) = values_to_plot(i) / expected_asymptotic_accuracy(i);
end
handle = plot(num_nodes_for_plot, values_to_plot);
xlabel('Graph size (nodes)', 'FontWeight', 'bold');
ylabel({'MD-IDC Error /                        ', 'Theoretical Error                        '}, 'rot', 0, 'FontWeight', 'bold');
title({'MD-IDC Asymptotic Error comparison', 'for Power-law graphs'}, 'FontWeight', 'bold', 'fontsize', 14);
set(handle, 'linewidth', 2);

end


function [answer] = evaluate_query (database, query) 

answer = dot(database, query);

end