clear all;
close all;

% Define multiple values of Nprojection and Ndimension
Nprojection_values = [150, 200, 250, 300]; % Add more values as needed
Ndimension_values = [5, 10, 20,50,100,150,200,250,300]; % Add more values as needed

randum = randn(299, max(Ndimension_values), max(Nprojection_values)); % Ensure randum has enough rows and columns

% Initialize cell array to store legend labels
legend_labels = cell(1, length(Nprojection_values));

% Initialize matrix to store EER values
EER_values = zeros(length(Ndimension_values), length(Nprojection_values));

% Loop over Ndimension_values and Nprojection_values
for j_proj = 1:length(Nprojection_values)
    Nprojection = Nprojection_values(j_proj);
    legend_labels{j_proj} = sprintf('Nprojection = %d', Nprojection);
    
    for i_dim = 1:length(Ndimension_values)
        Ndimension = Ndimension_values(i_dim);
        
        % Initialize EER for each combination of Ndimension and Nprojection
        EER = 0;
        
        for i = 1:100
            for j = 4:8
                file = strcat('C:\Users\kashyap\Downloads\Compressed\IoM_Vector_full\data\', num2str(i), '_', num2str(j), '.mat');
                
                if exist(file, 'file') == 0
                    continue;
                else
                    load(file);
                    vector = Ftemplate;
                end
                
                maxout_code = [];
                for counter = 1:Nprojection
                    tmp = vector * randum(:, 1:Ndimension, counter);
                    [~, ind] = max(tmp);
                    maxout_code = [maxout_code, ind];
                end
                
                file2 = strcat('C:\Users\kashyap\Downloads\Compressed\IoM_Vector_full\GRP_IoM\maxout\', num2str(i), '_', num2str(j), '.mat');
                save(file2, 'maxout_code');
            end
        end
        
        % Assuming matching_IoM returns EER
        EER = matching_IoM();
        
        % Store the EER value
        EER_values(i_dim, j_proj) = EER;
    end
end

% Plot the 2D graph
figure;
hold on;
for j_proj = 1:length(Nprojection_values)
    plot(Ndimension_values, EER_values(:, j_proj), '-o', 'LineWidth', 2, 'DisplayName', legend_labels{j_proj});
end
hold off;

xlabel('Ndimension');
ylabel('EER');
title('EER vs Ndimension for Different Nprojection');
legend('Location', 'Best');
grid on;  % Add grid for better readability
