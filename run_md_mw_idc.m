% This function takes no arguments and runs MD-IDC for a variable number of
% graph sizes. MD-IDC is run until it is successful. At the end of
% computation, a graph is generated for accuracy statistics.

% Important: In order to get the desired results for MW-IDC and MD-IDC you may
% need to change the update bound, threshold, and step size parameters.

function [] = run_md_mw_idc() 

% Variables to hold statistics about the computations
num_nodes_for_plot = [];
md_errors_for_plot = [];
mw_errors_for_plot = [];

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
            % A parameter only used for power law graphs
            p_beta = 1.25;
            % A privacy parameter that we set arbitrarily. Higher values mean lower privacy but higher accuracy.
            delta = 0.1;

            % Generate an input database, which is represented by its
            % adjacency matrix
            input_database = generate_imbalanced(num_nodes);
            reshaped_input_database = reshape(input_database, [num_nodes ^ 2, 1]);
            % Generate queries to use for MD-IDC and MW-IDC
            queries = generate_sized_queries(num_queries, num_nodes, cut_size);
            % Run MW-IDC
            mw_answers = mw_idc(epsilon, delta, beta, queries, reshaped_input_database, num_nodes);
            % Run MD-IDC
            md_answers = md_idc(epsilon, delta, beta, queries, input_database, num_nodes);
            
            % Find and record the accuracy
            md_error = 0;
            mw_error = 0;
            for i=1:num_queries
                query = queries{i};
                query_answer = evaluate_query(reshaped_input_database, query);
                md_answer = md_answers(i);
                mw_answer = mw_answers(i);
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