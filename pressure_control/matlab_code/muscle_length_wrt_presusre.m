%% Clear workspace and close all figures
clear;
close all;

%% Load data
load('../matlab_data/mckibben_pam_contraction_ratio.mat');
load('../matlab_data/require_pressure_calculation_data.mat', 'muscle_data');

%% Define constants
LENGTH_TERMINAL_END = 6.5;  % Length of terminal end (mm)
LENGTH_INPUT_CONNECTOR = 12.1;  % Length of input connector (mm)
SAVE_FIGURES = false;  % Flag to save figures
NUM_TENDON_LENGTHS = 10;  % Number of different tendon lengths to plot
TENDON_LENGTH_INCREMENT = 10;  % Increment of tendon length (mm)

%% Process each muscle
for muscle_index = 2:11
    tendon_length = 0;  % Initial tendon length (mm)
    fig = figure('units', 'normalized', 'outerposition', [0, 0, 1, 1]);  % Create full-screen figure
    
    %% Plot for different tendon lengths
    for tendon_length_index = 1:NUM_TENDON_LENGTHS
        % Calculate muscle lengths
        muscle_length_initial = muscle_data{muscle_index, 2} - (LENGTH_INPUT_CONNECTOR + LENGTH_TERMINAL_END + tendon_length);
        muscle_length_pressurize = (1 - contraction_ratio_pressurize) * muscle_length_initial;
        muscle_length_depressurize = (1 - contraction_ratio_depressurize) * muscle_length_initial;
        
        % Calculate normalized muscle lengths
        normalized_muscle_length_pressurize = (muscle_length_pressurize + LENGTH_TERMINAL_END + LENGTH_INPUT_CONNECTOR + tendon_length) / muscle_data{muscle_index, 2};
        normalized_muscle_length_depressurize = (muscle_length_depressurize + LENGTH_TERMINAL_END + LENGTH_INPUT_CONNECTOR + tendon_length) / muscle_data{muscle_index, 2};
        
        % Create subplot
        subplot(2, 5, tendon_length_index);
        plot_muscle_length(air_pressure_MPa, normalized_muscle_length_pressurize, normalized_muscle_length_depressurize, ...
                           muscle_data{muscle_index, 1}, tendon_length);
        
        % Plot minimum muscle length
        plot_minimum_muscle_length(muscle_index, muscle_data);
        
        % Increment tendon length for next iteration
        tendon_length = tendon_length + TENDON_LENGTH_INCREMENT;
    end
    
    %% Save figure if option is enabled
    if SAVE_FIGURES
        save_muscle_figure(fig, muscle_data, muscle_index);
    end
end

%% Helper Functions

function plot_muscle_length(pressure, length_pressurize, length_depressurize, muscle_name, tendon_length)
    % Set up plot
    set(gca, 'Fontsize', 14);
    xlabel('Pressure [MPa]');
    ylabel('Normalized muscle length (' + muscle_name + ')');
    xlim([0, 0.5]);
    ylim([0.75, 1]);
    xticks(0:0.1:0.5);
    title(['L_{tendon} = ', num2str(tendon_length), ' [mm]']);
    grid on;
    hold on;
    
    % Plot pressurize and depressurize curves
    plot(pressure, length_pressurize, 'o-', 'LineWidth', 1.5);
    plot(pressure, length_depressurize, 'o-', 'LineWidth', 1.5);
end

function plot_minimum_muscle_length(muscle_index, muscle_data)
    % Plot minimum muscle length for specific muscles
    if muscle_index <= 11
        min_length = min(muscle_data{muscle_index, 7});
        yline(min_length, '--', 'Min.', 'LineWidth', 1.5);
    end
end

function save_muscle_figure(fig, muscle_data, muscle_index)
    try
        % Create save directory
        save_dir = fullfile('..', 'saved_figures', 'muscle_length_wrt_pressure');
        if ~exist(save_dir, 'dir')
            mkdir(save_dir);
        end

        % Generate filename
        muscle_name = muscle_data{muscle_index, 1};
        if iscell(muscle_name)
            muscle_name = muscle_name{1};
        end
        muscle_name = strtrim(char(muscle_name));
        filename = matlab.lang.makeValidName(regexprep(muscle_name, '\s+', '_'));
        
        % Create file paths
        fig_path = fullfile(save_dir, [filename, '.fig']);
        svg_path = fullfile(save_dir, [filename, '.svg']);
        
        % Save figures
        saveas(fig, fig_path, 'fig');
        saveas(fig, svg_path, 'svg');
        
        fprintf('Saved figure: %s\n', filename);
    catch err
        warning('Failed to save figure: %s\nError: %s', filename, err.message);
        disp(['Error occurred with muscle: ', muscle_name]);
        disp(['Current working directory: ', pwd]);
        disp(['Save directory: ', save_dir]);
    end
end