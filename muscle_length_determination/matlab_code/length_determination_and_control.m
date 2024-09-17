%% Initialization
close all;
clear;

% Load data
load ('../matlab_data/muscle_length_and_joint_angle.mat');

% Save option
SAVE_FIGURES = false;

%% Data Preparation

% Define muscle names and corresponding length data
muscle_data = {
    "IP", muscle_length_ip;
    "GLU", muscle_length_glu;
    "BF", muscle_length_bf;
    "SMT", muscle_length_smt;
    "QF\RF", muscle_length_vl;
    "RF", muscle_length_rf;
    "GN", muscle_length_gn;
    "CT", muscle_length_ct
};

% Define joint names and corresponding angle data
joint_data = {
    "hip", joint_angle_hip;
    "stf", joint_angle_stf;
    "tcl", joint_angle_tcl
};

% Set the time period for analysis
PERIOD_START = 15;
PERIOD_END = 59;
time_adjusted = timeline - timeline(PERIOD_START);
time_adjusted = time_adjusted(PERIOD_START:PERIOD_END);

%% Data Normalization

% Normalize muscle lengths for one period
for muscle_index = 1:size(muscle_data, 1)
    muscle_length = muscle_data{muscle_index, 2}(PERIOD_START:PERIOD_END);
    [~, max_length_index] = max(muscle_length);
    muscle_data{muscle_index, 2} = muscle_length / muscle_length(max_length_index);
end

%% Visualization

for muscle_index = 1:size(muscle_data, 1)
    % Create figure
    fig = figure('Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
    set(gca, 'FontSize', 14);
    
    % Plot joint angles
    hold on;
    for joint_index = 1:size(joint_data, 1)
        joint_angle = joint_data{joint_index, 2}(PERIOD_START:PERIOD_END);
        plot(time_adjusted, joint_angle, '--', 'LineWidth', 1.1, 'DisplayName', joint_data{joint_index, 1});
    end
    
    % Set up legend for joint angles
    lgd_joint = legend('show');
    set(lgd_joint, 'Interpreter', 'latex', 'Box', 'off', ...
                   'FontSize', 14, 'Location', 'northeast', 'NumColumns', 3);

    % Update legend text
    legend_entries = lgd_joint.String;
    for i = 1:length(legend_entries)
        legend_entries{i} = ['$\theta_\textrm{' legend_entries{i} '}$'];
    end
    lgd_joint.String = legend_entries;
    
    % Configure left y-axis (joint angles)
    ylabel('Joint angle [deg]');
    xlabel('Time [s]');
    
    % Plot muscle length on right y-axis
    yyaxis right;
    muscle_name = muscle_data{muscle_index, 1};
    muscle_length = muscle_data{muscle_index, 2};
    plot(time_adjusted, muscle_length, '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    
    % Configure right y-axis (muscle length)
    ylabel(['Normalized muscle length (' + muscle_name + ')']);
    ylim([0.8, 1]);
    xlim([time_adjusted(1), time_adjusted(end)]);
    
    % Save figure if option is enabled
    if SAVE_FIGURES
        try
            % Create a directory for saving figures if it doesn't exist
            save_dir = fullfile('..', 'saved_figures', 'normalized_muscle_length_and_joint_angle');
            if ~exist(save_dir, 'dir')
                mkdir(save_dir);
            end
    
            % Generate a valid filename
            filename = strrep(muscle_name{1}, '\', '_');  % Replace backslash with underscore
            if strcmp(muscle_name{1}, 'QF\RF')
                filename = 'QF_except_RF';
            end
            filename = matlab.lang.makeValidName(filename);
            
            % Debug output
            disp(['Muscle name: ', muscle_name{1}]);
            disp(['Generated filename: ', filename]);
            
            % Create full file paths
            fig_path = fullfile(save_dir, [filename, '.fig']);
            svg_path = fullfile(save_dir, [filename, '.svg']);
            
            % Debug output
            disp(['Fig path: ', fig_path]);
            disp(['SVG path: ', svg_path]);
            
            % Save as .fig
            saveas(fig, fig_path, 'fig');
            
            % Save as .svg
            saveas(fig, svg_path, 'svg');
            
            fprintf('Saved figure: %s\n', filename);
        catch err
            warning('Failed to save figure: %s\nError: %s', filename, err.message);
            % Additional debug information
            disp(['Error occurred with muscle: ', muscle_name{1}]);
            disp(['Current working directory: ', pwd]);
            disp(['Save directory: ', save_dir]);
        end
    end
end