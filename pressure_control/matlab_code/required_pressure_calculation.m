%% Initialization
clear;
close all;

% Load data
% load ('..\matlab_data\require_pressure_calculation_data.mat');
load ('..\matlab_data\require_pressure_calculation_data.mat'); % Short ligaments


% Plot and save options
PLOT_GRAPHS = true;
SAVE_FIGURES = true;
PLOT_ALL_MUSCLES_SUBPLOT = false;
EXPORT_VIDEO = true;

% Initialize constants
TIMELINE_EXTENSION_FACTOR = 1; % Factor for extending time intervals
LENGTH_TERMINAL_END = 6.5;
LENGTH_INPUT_CONNECTOR = 12.1;
timeline_extended_one_cycle = timeline * TIMELINE_EXTENSION_FACTOR; % Extend time intervals
timeline_extended_two_cycles = [timeline_extended_one_cycle, timeline_extended_one_cycle(end) + timeline_extended_one_cycle(2:end)]; % Time for two cycles
air_pressure_range_MPa = 0:0.005:0.5; % Applied air pressure range (MPa)

%% Process muscle data
for muscle_index = 2:11 % For all muscles
    muscle_data = process_muscle(muscle_data, muscle_index, LENGTH_TERMINAL_END, LENGTH_INPUT_CONNECTOR, ...
                                 air_pressure_MPa, air_pressure_range_MPa, contraction_ratio_pressurize, ...
                                 contraction_ratio_depressurize, timeline, timeline_extended_one_cycle, TIMELINE_EXTENSION_FACTOR);
end
%% Plot and export results
plot_and_export_results(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, TIMELINE_EXTENSION_FACTOR, PLOT_GRAPHS, SAVE_FIGURES);

%% Create subplot figure with all muscles
create_all_muscles_subplot(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, TIMELINE_EXTENSION_FACTOR, PLOT_ALL_MUSCLES_SUBPLOT);

%% Clear unnecessary variables
clearvars -except muscle_data air_pressure_MPa contraction_ratio_pressurize contraction_ratio_depressurize timeline

%% Function definitions

function muscle_data = process_muscle(muscle_data, muscle_index, LENGTH_TERMINAL_END, LENGTH_INPUT_CONNECTOR, ...
                                      air_pressure_MPa, air_pressure_range_MPa, contraction_ratio_pressurize, ...
                                      contraction_ratio_depressurize, timeline, timeline_extended_one_cycle, TIMELINE_EXTENSION_FACTOR)
    % Calculate PAM lengths
    [muscle_length_pressurize, muscle_length_depressurize, muscle_length_pressurize_normalized, muscle_length_depressurize_normalized] = ...
        calculate_pam_lengths(muscle_data, muscle_index, LENGTH_TERMINAL_END, LENGTH_INPUT_CONNECTOR, contraction_ratio_pressurize, contraction_ratio_depressurize);
    
    % Fit curves
    muscle_data = fit_muscle_curves(muscle_data, muscle_index, air_pressure_MPa, air_pressure_range_MPa, ...
                                    muscle_length_pressurize_normalized, muscle_length_depressurize_normalized);
    
    % Determine pressure points
    muscle_data = determine_pressure_points(muscle_data, muscle_index, timeline, TIMELINE_EXTENSION_FACTOR);
    
    % Calculate required pressure
    muscle_data = calculate_required_pressure(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa);
end

function [muscle_length_pressurize, muscle_length_depressurize, muscle_length_pressurize_normalized, muscle_length_depressurize_normalized] = ...
    calculate_pam_lengths(muscle_data, muscle_index, LENGTH_TERMINAL_END, LENGTH_INPUT_CONNECTOR, contraction_ratio_pressurize, contraction_ratio_depressurize)
    
    length_tendon = muscle_data{muscle_index, 3};
    muscle_length_initial = muscle_data{muscle_index, 2} - (LENGTH_INPUT_CONNECTOR + LENGTH_TERMINAL_END + length_tendon);
    muscle_length_pressurize = (ones(size(contraction_ratio_pressurize)) - contraction_ratio_pressurize) * muscle_length_initial;
    muscle_length_depressurize = (ones(size(contraction_ratio_depressurize)) - contraction_ratio_depressurize) * muscle_length_initial;
    muscle_length_pressurize_normalized = (muscle_length_pressurize + LENGTH_TERMINAL_END + LENGTH_INPUT_CONNECTOR + length_tendon) / muscle_data{muscle_index, 2};
    muscle_length_depressurize_normalized = (muscle_length_depressurize + LENGTH_TERMINAL_END + LENGTH_INPUT_CONNECTOR + length_tendon) / muscle_data{muscle_index, 2};
end

function muscle_data = fit_muscle_curves(muscle_data, muscle_index, air_pressure_MPa, air_pressure_range_MPa, ...
                                         muscle_length_pressurize_normalized, muscle_length_depressurize_normalized)
    % Fit 9th order polynomial to pressurize and depressurize data
    coefficient_pressurize = polyfit(air_pressure_MPa, muscle_length_pressurize_normalized, 9);
    coefficient_depressurize = polyfit(air_pressure_MPa, muscle_length_depressurize_normalized, 9);
    
    % Calculate fitted curves
    muscle_data{muscle_index, 4} = polyval(coefficient_pressurize, air_pressure_range_MPa);
    muscle_data{muscle_index, 5} = polyval(coefficient_depressurize, air_pressure_range_MPa);
end

function muscle_data = determine_pressure_points(muscle_data, muscle_index, timeline, TIMELINE_EXTENSION_FACTOR)
    global_end_point = 1.7498;
    
    switch muscle_index
        case {4, 5, 6} % For BF, SMT, RF
            pressurize_point_one_cycle = calculate_pressure_points_case1(global_end_point);
        case {2, 3} % For IP, GLU
            pressurize_point_one_cycle = calculate_pressure_points_case2(global_end_point);
        case {7, 8, 9} % For QF except RF
            pressurize_point_one_cycle = calculate_pressure_points_case3(global_end_point, timeline);
        case 10 % For GN
            pressurize_point_one_cycle = calculate_pressure_points_case4(global_end_point);
        otherwise % For CT
            pressurize_point_one_cycle = calculate_pressure_points_case5(global_end_point);
    end
    
    muscle_data{muscle_index, 6} = pressurize_point_one_cycle * TIMELINE_EXTENSION_FACTOR;
end

function pressurize_point_one_cycle = calculate_pressure_points_case1(global_end_point)
    local_min_max_point = 0.7499;
    first_section = local_min_max_point * [0, 1/3, 2/3, 1];
    second_section = local_min_max_point * ones(1, 4) + (global_end_point - local_min_max_point) * [1/4, 2/4, 3/4, 1];
    pressurize_point_one_cycle = [first_section, second_section];
end

function pressurize_point_one_cycle = calculate_pressure_points_case2(global_end_point)
    local_min_max_point = [0.5416, global_end_point];
    first_section = local_min_max_point(1) * [0, 1/2, 1];
    second_section = local_min_max_point(1) * ones(1, 5) + (local_min_max_point(2) - local_min_max_point(1)) * [1/5, 2/5, 3/5, 4/5, 1];
    pressurize_point_one_cycle = [first_section, second_section];
end

function pressurize_point_one_cycle = calculate_pressure_points_case3(global_end_point, timeline)
    local_min_max_point = [0.2916, 0.7916, 1.4998, global_end_point];
    first_section = [global_end_point + (timeline(end) - global_end_point + local_min_max_point(1)) / 2 - timeline(end), local_min_max_point(1)];
    second_section = local_min_max_point(1) * ones(1, 2) + (local_min_max_point(2) - local_min_max_point(1)) * [1/2, 1];
    third_section = local_min_max_point(2) * ones(1, 3) + (local_min_max_point(3) - local_min_max_point(2)) * [1/3, 2/3, 1];
    fourth_section = global_end_point;
    pressurize_point_one_cycle = [first_section, second_section, third_section, fourth_section];
end

function pressurize_point_one_cycle = calculate_pressure_points_case4(global_end_point)
    local_min_max_point = [0, 0.5416, 0.7499, 1.0832];
    first_section = local_min_max_point(1);
    second_section = local_min_max_point(1) * ones(1, 2) + (local_min_max_point(2) - local_min_max_point(1)) * [1/2, 1];
    third_section = local_min_max_point(3);
    fourth_section = local_min_max_point(4);
    fifth_section = local_min_max_point(4) * ones(1, 3) + (global_end_point - local_min_max_point(4)) * [1/3, 2/3, 1];
    pressurize_point_one_cycle = [first_section, second_section, third_section, fourth_section, fifth_section];
end

function pressurize_point_one_cycle = calculate_pressure_points_case5(global_end_point)
    local_min_max_point = [0.3745, 0.7499, 1.1249];
    first_section = local_min_max_point(1) * [1/2, 1];
    second_section = local_min_max_point(2);
    third_section = local_min_max_point(2) * ones(1, 2) + (local_min_max_point(3) - local_min_max_point(2)) * [1/2, 1];
    fourth_section = local_min_max_point(3) * ones(1, 3) + (global_end_point - local_min_max_point(3)) * [1/3, 2/3, 1];
    pressurize_point_one_cycle = [first_section, second_section, third_section, fourth_section];
end

function muscle_data = calculate_required_pressure(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa)
    muscle_length_at_time_point = [];
    pressurize_time_point = [];
    is_pressurize = [];
    required_pressure = [];
    
    for time_point_index = 1:8 % For one cycle
        [~, time_point_index_temp] = min(abs(timeline_extended_one_cycle - muscle_data{muscle_index, 6}(time_point_index)));
        pressurize_time_point = [pressurize_time_point, time_point_index_temp];
        muscle_length_at_time_point = [muscle_length_at_time_point, interp1(timeline_extended_one_cycle, muscle_data{muscle_index, 7}, muscle_data{muscle_index, 6}(time_point_index))];
        
        is_pressurize = update_is_pressurize(is_pressurize, muscle_length_at_time_point);
        
        if is_pressurize(end)
            [~, required_pressure_temp] = min(abs(muscle_length_at_time_point(end) - muscle_data{muscle_index, 4}));
        else
            [~, required_pressure_temp] = min(abs(muscle_length_at_time_point(end) - muscle_data{muscle_index, 5}));
        end
        required_pressure = [required_pressure, air_pressure_range_MPa(required_pressure_temp)];
    end
    
    muscle_data{muscle_index, 8} = pressurize_time_point;
    muscle_data{muscle_index, 9} = muscle_length_at_time_point;
    muscle_data{muscle_index, 10} = is_pressurize;
    % Amplify required pressures of IP, RF, and CT
    if muscle_index == 2 || muscle_index == 6
        amplification_factor = 0.5 / max(required_pressure); % Set the amplification so that the new maximum pressure is 0.5
    elseif muscle_index == 11
        amplification_factor = 2; % Set the amplification to increase the pressure by 2 times
    else
        amplification_factor = 1;
    end
    muscle_data{muscle_index, 11} = required_pressure * amplification_factor;
end

function is_pressurize = update_is_pressurize(is_pressurize, muscle_length_at_time_point)
    if isempty(is_pressurize)
        is_pressurize = [muscle_length_at_time_point(end) < muscle_length_at_time_point(1)];
    else
        is_pressurize = [is_pressurize, muscle_length_at_time_point(end) < muscle_length_at_time_point(end-1)];
    end
end

function plot_and_export_results(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, TIMELINE_EXTENSION_FACTOR, PLOT_GRAPHS, SAVE_FIGURES)
    for muscle_index = 2:11
        [time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods] = ...
            prepare_plot_data(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa);
        if PLOT_GRAPHS
            % Replace create_figure() with direct figure creation
            fig = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
            plot_muscle_data(gca, muscle_data, muscle_index, timeline_extended_one_cycle, timeline_extended_two_cycles, ...
                             time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods, TIMELINE_EXTENSION_FACTOR, false);
        end
        
        if SAVE_FIGURES
            export_results(muscle_data, muscle_index, time_point_two_periods, required_pressure_two_periods, TIMELINE_EXTENSION_FACTOR);
        end    
    end
end


function [time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods] = ...
    prepare_plot_data(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa)
    
    time_point_two_periods = [muscle_data{muscle_index, 6}, muscle_data{muscle_index, 6} + timeline_extended_one_cycle(end)];
    muscle_length_time_point_two_periods = [muscle_data{muscle_index, 9}, muscle_data{muscle_index, 9}];
    required_pressure_two_periods = [muscle_data{muscle_index, 11}, muscle_data{muscle_index, 11}];
    
    if muscle_index == 7 || muscle_index == 8 || muscle_index == 9 || muscle_index == 11 % For QF except RF and CT
        time_point_two_periods = [0, time_point_two_periods];
        muscle_length_time_point_two_periods = [muscle_data{muscle_index, 7}(1), muscle_length_time_point_two_periods];
        [~, zero_time_point_index] = min(abs(muscle_data{muscle_index, 4} - muscle_data{muscle_index, 7}(1)));
        if ~isempty(zero_time_point_index) && zero_time_point_index <= length(air_pressure_range_MPa)
            required_pressure_two_periods = [air_pressure_range_MPa(zero_time_point_index), required_pressure_two_periods];
        else
            required_pressure_two_periods = [required_pressure_two_periods(1), required_pressure_two_periods];
        end
    end
end

function plot_muscle_data(ax, muscle_data, muscle_index, timeline_extended_one_cycle, timeline_extended_two_cycles, ...
                          time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods, TIMELINE_EXTENSION_FACTOR, is_subplot)
    axes(ax);
    % Plot normalized muscle lengths
    yyaxis left
    muscle_name = muscle_data{muscle_index, 1};
    if ~is_subplot
        xlabel("Time (" + string(TIMELINE_EXTENSION_FACTOR) + " times extended)" + " [ms]");
        ylabel("Normalized muscle length (" + muscle_name + ')');
    end
    ylim([0.8, 1]);
    hold on;
    
    % Plot original data
    p_original = plot(timeline_extended_one_cycle * 1000, muscle_data{muscle_index, 7});
    p_original.LineWidth = 1;
    p_original.LineStyle = "--";
    set(gca, "Fontsize", 14, "XTickLabel", get(gca, "XTick"));
    
    % Plot approximated data
    p_approx = plot(time_point_two_periods * 1000, muscle_length_time_point_two_periods);
    p_approx.LineWidth = 2;
    p_approx.LineStyle = "-";
    p_approx.Marker = "o";
    p_approx.Color = p_original.Color;
    if is_subplot
        xline(timeline_extended_one_cycle(end) * 1000, "--");
    else
        xline(timeline_extended_one_cycle(end) * 1000, "--", string(round(timeline_extended_one_cycle(end) * 1000)), "FontSize", 14);
    end

    % Plot required air pressures
    yyaxis right
    if ~is_subplot
        ylabel("Air pressure [MPa]");
    end

    ylim([0, 0.5]);
    hold on;
    p_required_pressure = plot(time_point_two_periods * 1000, required_pressure_two_periods);
    p_required_pressure.LineWidth = 1.5;
    p_required_pressure.Marker = "*";
    
    % Add text annotations only if it's not a subplot
    if ~is_subplot
        for time_point_index = 1:length(time_point_two_periods)
            value_temp = [time_point_two_periods(time_point_index) * 1000, required_pressure_two_periods(time_point_index)];
            text(value_temp(1), value_temp(2), sprintf("%.0f ms\n%.3f MPa", value_temp), 'Horiz','left', 'Vert','bottom');
        end
    end
end

function create_all_muscles_subplot(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, TIMELINE_EXTENSION_FACTOR, PLOT_ALL_MUSCLES_SUBPLOT)
    if PLOT_ALL_MUSCLES_SUBPLOT
        fig = figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
        subplot_indices = [2:7, 10, 11]; % Exclude 8 and 9
        num_subplots = length(subplot_indices);
    
        % Create subplots
        for i = 1:num_subplots
            muscle_index = subplot_indices(i);
            ax(i) = subplot(4, 2, i);
            [time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods] = ...
                prepare_plot_data(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa);
            plot_muscle_data(ax(i), muscle_data, muscle_index, timeline_extended_one_cycle, timeline_extended_two_cycles, ...
                time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods, TIMELINE_EXTENSION_FACTOR, true);
            
            % Set title
            muscle_name = muscle_data{muscle_index, 1};
            if muscle_index == 7
                muscle_name = 'VL, VM, VI';
            end
            title(muscle_name, 'Interpreter', 'none');
        end
    
        % Add time indicator
        cycle_duration = timeline_extended_one_cycle(end);
        total_duration = timeline_extended_two_cycles(end-3);
        indicator_lines = gobjects(num_subplots, 1);
        for i = 1:num_subplots
            axes(ax(i));
            indicator_lines(i) = xline(cycle_duration * 1000, 'r-', 'LineWidth', 2);
        end
    
        % Animation settings
        speed_factor = 2; % Adjust this to change animation speed, 2 is real-time
        update_interval = 0.01; % Update interval in seconds
    
        % Get cycle durations
        first_cycle_start = timeline_extended_one_cycle(1) * 1000; % Convert to milliseconds
        first_cycle_end = timeline_extended_one_cycle(end) * 1000; % Convert to milliseconds
        second_cycle_end = timeline_extended_two_cycles(end-3) * 1000; % Convert to milliseconds
        total_duration = second_cycle_end - first_cycle_start;
    
        % Animation loop
        tic; % Start timer
        while true
            elapsed_time = toc * speed_factor;
            
            % Calculate the current position
            current_position = first_cycle_start + mod(elapsed_time * 1000, total_duration);

            % If we've passed the first cycle, adjust to stay within the second cycle
            if current_position > first_cycle_end
                current_position = first_cycle_end + mod(current_position - first_cycle_end, second_cycle_end - first_cycle_end);
            end
            
            % Update all indicator lines
            for i = 1:num_subplots
                indicator_lines(i).Value = current_position;
            end
            
            drawnow;
            pause(update_interval);
        end
    end
end

function export_results(muscle_data, muscle_index, time_point_two_periods, required_pressure_two_periods, TIMELINE_EXTENSION_FACTOR)
    % Prepare data for CSV export
    required_pressure_for_csv = ["Time [ms]"; "Pressure [MPa]"];
    for time_point_index = 1:length(time_point_two_periods)
        value_temp = [time_point_two_periods(time_point_index) * 1000, required_pressure_two_periods(time_point_index)];
        required_pressure_for_csv = [required_pressure_for_csv(1, :), value_temp(1); required_pressure_for_csv(2, :), value_temp(2)];
    end

    % Create a directory for saving figures if it doesn't exist
    save_dir = fullfile('..', 'saved_figures', [num2str(TIMELINE_EXTENSION_FACTOR), '_times_extended']);
    if ~exist(save_dir, 'dir')
        mkdir(save_dir);
    end

    % Generate a valid filename
    muscle_name = muscle_data{muscle_index, 1};
    if iscell(muscle_name)
        muscle_name = muscle_name{1};  % Extract string from cell if it's a cell array
    end
    muscle_name = char(muscle_name);  % Convert to char array if it's a string
    muscle_name = strtrim(muscle_name);  % Remove any leading/trailing whitespace
    muscle_name = regexprep(muscle_name, '\s+', '_');  % Replace any remaining whitespace with underscores
    filename = muscle_name;
    filename = matlab.lang.makeValidName(filename);
    
    % Debug output
    disp(['Muscle name: ', muscle_name]);
    disp(['Generated filename: ', filename]);
    
    % Create full file paths
    fig_path = fullfile(save_dir, [filename, '.fig']);
    svg_path = fullfile(save_dir, [filename, '.svg']);
    csv_path = fullfile(save_dir, [filename, '.csv']);
    
    % Debug output
    disp(['Fig path: ', fig_path]);
    disp(['SVG path: ', svg_path]);
    disp(['CSV path: ', csv_path]);
    
    try
        % Save as .fig
        saveas(gcf, fig_path, 'fig');
        
        % Save as .svg
        saveas(gcf, svg_path, 'svg');

        % Save as .csv
        writematrix(required_pressure_for_csv, csv_path);
        
        fprintf('Saved figure: %s\n', filename);

    catch err
        warning('Failed to save figure: %s\nError: %s', char(filename), err.message);
        % Additional debug information
        disp(['Error occurred with muscle: ', muscle_name]);
        disp(['Current working directory: ', pwd]);
        disp(['Save directory: ', save_dir]);
    end
end