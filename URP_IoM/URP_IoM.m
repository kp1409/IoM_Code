clear all;
close all;

% Define multiple values of Nperm
Nperm_values = [10,40,50,75,100,200,350,500,700,1000]; % Add more values as needed

Nkernel = 2;
Kwindow = 128;

% Initialize matrix to store EER values
EER_values = zeros(1, length(Nperm_values));

for idx = 1:length(Nperm_values)
    Nperm = Nperm_values(idx);
    
    G_vecs = cell(1, Nperm);
    
    for ii = 1:Nperm
        G_vecs{ii} = getGvec(299, Nkernel);
    end
    
    for i = 1:100
        for j = 4:8
            readfile = strcat('C:\Users\kashyap\Downloads\Compressed\IoM_Vector_full\data\', num2str(i), '_', num2str(j), '.mat');
            
            if exist(readfile, 'file') == 0
                continue;
            else
                A = load(readfile);
                A = A.Ftemplate;
                [binary_codes, G_vecs] = WTA_hashing(A, G_vecs, Nkernel, Kwindow, Nperm);
                savefile = strcat('C:\Users\kashyap\Downloads\Compressed\IoM_Vector_full\URP_IoM\wta\', num2str(i), '_', num2str(j), '.mat');
                save(savefile, 'binary_codes');
            end
        end
    end
    
    % Assuming calsimilarity_IoM returns EER
    EER = calsimilarity_IoM();
    
    % Store the EER value
    EER_values(idx) = EER;
end

% Plot the graph
figure;
plot(Nperm_values, EER_values, '-o', 'LineWidth', 2, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
xlabel('Nperm');
ylabel('EER');
title('EER vs Nperm');
grid on;  % Add grid for better readability

