%% Initialization
clear;
close all;

% Load data
load ('..\matlab_data\require_pressure_calculation_data.mat');

% Plot and save options
PLOT_GRAPHS = true;
SAVE_FIGURES = true;

% Initialize constants
timeline_extension_factor = 2; % Factor for extending time intervals
[length_terminal_end, length_input_connector] = deal(5.9, 11.5); % Component lengths (mm)
timeline_extended_one_cycle = timeline * timeline_extension_factor; % Extend time intervals
timeline_extended_two_cycles = [timeline_extended_one_cycle, timeline_extended_one_cycle(end) + timeline_extended_one_cycle(2:end)]; % Time for two cycles
air_pressure_range_MPa = 0:0.005:0.5; % Applied air pressure range (MPa)

%% Process muscle data
for muscle_index = 2:11 % For all muscles
    muscle_data = process_muscle(muscle_data, muscle_index, length_terminal_end, length_input_connector, ...
                                 air_pressure_MPa, air_pressure_range_MPa, contraction_ratio_pressurize, ...
                                 contraction_ratio_depressurize, timeline, timeline_extended_one_cycle, timeline_extension_factor);
% Amplify CT's pressure
    if muscle_index == 11
        muscle_data{muscle_index, 11} = muscle_data{muscle_index, 11} * 3;
    end
end

%% Plot and export results
plot_and_export_results(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, timeline_extension_factor, PLOT_GRAPHS, SAVE_FIGURES);

%% Clear unnecessary variables
clearvars -except muscle_data air_pressure_MPa contraction_ratio_pressurize contraction_ratio_depressurize timeline

%% Function definitions

function muscle_data = process_muscle(muscle_data, muscle_index, length_terminal_end, length_input_connector, ...
                                      air_pressure_MPa, air_pressure_range_MPa, contraction_ratio_pressurize, ...
                                      contraction_ratio_depressurize, timeline, timeline_extended_one_cycle, timeline_extension_factor)
    % Calculate PAM lengths
    [muscle_length_pressurize, muscle_length_depressurize, muscle_length_pressurize_normalized, muscle_length_depressurize_normalized] = ...
        calculate_pam_lengths(muscle_data, muscle_index, length_terminal_end, length_input_connector, contraction_ratio_pressurize, contraction_ratio_depressurize);
    
    % Fit curves
    muscle_data = fit_muscle_curves(muscle_data, muscle_index, air_pressure_MPa, air_pressure_range_MPa, ...
                                    muscle_length_pressurize_normalized, muscle_length_depressurize_normalized);
    
    % Determine pressure points
    muscle_data = determine_pressure_points(muscle_data, muscle_index, timeline, timeline_extension_factor);
    
    % Calculate required pressure
    muscle_data = calculate_required_pressure(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa);
end

function [muscle_length_pressurize, muscle_length_depressurize, muscle_length_pressurize_normalized, muscle_length_depressurize_normalized] = ...
    calculate_pam_lengths(muscle_data, muscle_index, length_terminal_end, length_input_connector, contraction_ratio_pressurize, contraction_ratio_depressurize)
    
    length_tendon = muscle_data{muscle_index, 3};
    muscle_length_initial = muscle_data{muscle_index, 2} - (length_input_connector + length_terminal_end + length_tendon);
    muscle_length_pressurize = (ones(size(contraction_ratio_pressurize)) - contraction_ratio_pressurize) * muscle_length_initial;
    muscle_length_depressurize = (ones(size(contraction_ratio_depressurize)) - contraction_ratio_depressurize) * muscle_length_initial;
    muscle_length_pressurize_normalized = (muscle_length_pressurize + length_terminal_end + length_input_connector + length_tendon) / muscle_data{muscle_index, 2};
    muscle_length_depressurize_normalized = (muscle_length_depressurize + length_terminal_end + length_input_connector + length_tendon) / muscle_data{muscle_index, 2};
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

function muscle_data = determine_pressure_points(muscle_data, muscle_index, timeline, timeline_extension_factor)
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
    
    muscle_data{muscle_index, 6} = pressurize_point_one_cycle * timeline_extension_factor;
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
    muscle_data{muscle_index, 11} = required_pressure;
end

function is_pressurize = update_is_pressurize(is_pressurize, muscle_length_at_time_point)
    if isempty(is_pressurize)
        is_pressurize = [muscle_length_at_time_point(end) < muscle_length_at_time_point(1)];
    else
        is_pressurize = [is_pressurize, muscle_length_at_time_point(end) < muscle_length_at_time_point(end-1)];
    end
end

function plot_and_export_results(muscle_data, timeline_extended_one_cycle, timeline_extended_two_cycles, air_pressure_range_MPa, timeline_extension_factor, PLOT_GRAPHS, SAVE_FIGURES)
    for muscle_index = 2:11
        [time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods] = ...
            prepare_plot_data(muscle_data, muscle_index, timeline_extended_one_cycle, air_pressure_range_MPa);
        if PLOT_GRAPHS
            fig = create_figure();
            plot_muscle_data(fig, muscle_data, muscle_index, timeline_extended_one_cycle, timeline_extended_two_cycles, ...
                             time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods, timeline_extension_factor);
        end
        
        if SAVE_FIGURES
        export_results(muscle_data, muscle_index, time_point_two_periods, required_pressure_two_periods, timeline_extension_factor);
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
        required_pressure_two_periods = [air_pressure_range_MPa(zero_time_point_index), required_pressure_two_periods];
    end
end

function fig = create_figure()
    fig = figure("units", "normalized", "outerposition", [0, 0, 1, 1]);
end

function plot_muscle_data(fig, muscle_data, muscle_index, timeline_extended_one_cycle, timeline_extended_two_cycles, ...
                          time_point_two_periods, muscle_length_time_point_two_periods, required_pressure_two_periods, timeline_extension_factor)
    figure(fig);
    % Plot normalized muscle lengths
    yyaxis left
    xlabel("Time (" + string(timeline_extension_factor) + " times extended)" + " [ms]");
    ylabel("Normalized muscle length (" + muscle_data{muscle_index, 1} + ")");
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
    xline(timeline_extended_one_cycle(end) * 1000, "--", string(round(timeline_extended_one_cycle(end) * 1000)), "FontSize", 14);

    % Plot required air pressures
    yyaxis right
    ylabel("Air pressure [MPa]");
    ylim([0, 0.5]);
    hold on;
    p_required_pressure = plot(time_point_two_periods * 1000, required_pressure_two_periods);
    p_required_pressure.LineWidth = 1.5;
    p_required_pressure.Marker = "*";
    
    % Add text annotations
    for time_point_index = 1:length(time_point_two_periods)
        value_temp = [time_point_two_periods(time_point_index) * 1000, required_pressure_two_periods(time_point_index)];
        text(value_temp(1), value_temp(2), sprintf("%.0f ms\n%.3f MPa", value_temp), 'Horiz','left', 'Vert','bottom');
    end
end

function export_results(muscle_data, muscle_index, time_point_two_periods, required_pressure_two_periods, timeline_extension_factor)
    % Prepare data for CSV export
    required_pressure_for_csv = ["Time [ms]"; "Pressure [MPa]"];
    for time_point_index = 1:length(time_point_two_periods)
        value_temp = [time_point_two_periods(time_point_index) * 1000, required_pressure_two_periods(time_point_index)];
        required_pressure_for_csv = [required_pressure_for_csv(1, :), value_temp(1); required_pressure_for_csv(2, :), value_temp(2)];
    end

    % Create a directory for saving figures if it doesn't exist
    save_dir = fullfile('..', 'saved_figures', [num2str(timeline_extension_factor), '_times_extended']);
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