%% Put muscle lengths to a cell with each names
muscles = cell(8, 2);
muscles{1, 1} = "IP";
muscles{1, 2} = muscle_ip;
muscles{2, 1} = "GLU";
muscles{2, 2} = muscle_glu;
muscles{3, 1} = "BF";
muscles{3, 2} = muscle_bf;
muscles{4, 1} = "SMT";
muscles{4, 2} = muscle_smt;
muscles{5, 1} = "QF\RF";
muscles{5, 2} = muscle_vl;
muscles{6, 1} = "RF";
muscles{6, 2} = muscle_rf;
muscles{7, 1} = "GN";
muscles{7, 2} = muscle_gn;
muscles{8, 1} = "CT";
muscles{8, 2} = muscle_ct;

%% Put joint angles to a cell with each names
joints = cell(3, 2);
joints{1, 1} = "hip";
joints{1, 2} = joint_hip;
joints{2, 1} = "stf";
joints{2, 2} = joint_stf;
joints{3, 1} = "tcl";
joints{3, 2} = joint_tcl;

%% Set the time as one period and extend by 2.5 times
period_interval = [15, 59];
time_correction = time - time(15);
time_correction(60 : end) = [];
time_correction(1 : 14) = [];
time_extended = time_correction * 2.5;

%% Normalize muscle lengths for one period
for muscle_index = 1 : 8
    muscles{muscle_index, 2}(period_interval(2) + 1 : end) = [];
    muscles{muscle_index, 2}(1 : period_interval(1) - 1) = [];
    [~, max_length_temp_index] = max(muscles{muscle_index, 2});
    muscles{muscle_index, 2} = muscles{muscle_index, 2} / muscles{muscle_index, 2}(max_length_temp_index);
    clear("max_length_temp_index");
end
clear("muscle_index")

%% Print figures
for muscle_index = 1 : 8
    fig = figure("units", "normalized", "outerposition", [0, 0, 1, 1]);
    set(gca, "Fontsize", 14);
    xlabel("Time [s]");
    hold on;
    for joint_index = 1 : 3
        p_joint = plot(time_extended, joints{joint_index, 2}(period_interval(1) : period_interval(2)));
        p_joint.LineWidth = 1.1;
        p_joint.LineStyle = "--";
    end
    lgd_muscle = legend("$\theta_\textrm{hip}$", "$\theta_\textrm{stf}$", "$\theta_\textrm{tcl}$", "Interpreter", "latex");
    lgd_muscle.Box = "off";
    lgd_muscle.FontSize = 14;
    lgd_muscle.Location = "northeast";
    lgd_muscle.NumColumns = 3;
    ylabel("Joint angle [deg]");
    yyaxis right
    p_muscle = plot(time_extended, muscles{muscle_index, 2});
    p_muscle.LineWidth = 1.5;
    p_muscle.LineStyle = "-";
    p_muscle.HandleVisibility = "off";
    ylabel("Normalized muscle length "+ "(" + muscles{muscle_index, 1} + ")");
    ylim([0.8, 1]);
    xlim([time_extended(1), time_extended(end)]);
    if muscle_index == 5
         saveas(gca, "QF_except_RF.fig");
         saveas(gca, "QF_except_RF.svg");
    else
         saveas(gca, muscles{muscle_index, 1} + ".fig");
         saveas(gca, muscles{muscle_index, 1} + ".svg");
    end
end
