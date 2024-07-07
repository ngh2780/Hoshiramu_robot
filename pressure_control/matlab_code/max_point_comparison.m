% Clear workspace and close all figures
clear;
close all;

% Load data
muscle_length_left = readmatrix('../../raw_data/opensim_IK/left_muscle_length.csv');
muscle_length_right = readmatrix ('../../raw_data/opensim_IK/right_muscle_length.csv');

% Normalize muscle lengths
for muscle_index = 3:size(muscle_length_left, 2)
    muscle_length_left(:,muscle_index) = muscle_length_left(:,muscle_index) ./ max(muscle_length_left(:,muscle_index));
    muscle_length_right(:,muscle_index) = muscle_length_right(:,muscle_index) ./ max(muscle_length_right(:,muscle_index));
end

% Extract frame&timline and save normalized muscle lengths
frame = [muscle_length_left(:,1)];
timeline = [muscle_length_left(:,2)];
bf = [muscle_length_left(:,3), muscle_length_right(:,3)]; % Left, Right
ct = [muscle_length_left(:,4), muscle_length_right(:,4)]; % Left, Right
gn = [muscle_length_left(:,5), muscle_length_right(:,5)]; % Left, Right
glu = [muscle_length_left(:,6), muscle_length_right(:,6)]; % Left, Right
ip = [muscle_length_left(:,7), muscle_length_right(:,7)]; % Left, Right
rf = [muscle_length_left(:,8), muscle_length_right(:,8)]; % Left, Right
smt = [muscle_length_left(:,9), muscle_length_right(:,9)]; % Left, Right
vi = [muscle_length_left(:,10), muscle_length_right(:,10)]; % Left, Right
vl = [muscle_length_left(:,11), muscle_length_right(:,11)]; % Left, Right
vm = [muscle_length_left(:,12), muscle_length_right(:,12)]; % Left, Right

% Plot left leg muscles
fig = figure('units', 'normalized', 'outerposition', [0, 0, 1, 1]);  % Create full-screen figure
set(gca, 'Fontsize', 14);
xlabel('Time [ms]');
ylabel('Normalized muscle length');
hold on;
% p_ip_l = plot(timeline * 1000, ip(:,1), "LineWidth", 1);
% p_glu_l = plot(timeline * 1000, glu(:,1), "LineWidth", 1);
% p_bf_l = plot(timeline * 1000, bf(:,1), "LineWidth", 1);
% p_smt_l = plot(timeline * 1000, smt(:,1), "LineWidth", 1);
% p_rf_l = plot(timeline * 1000, rf(:,1), "LineWidth", 1);
p_vl_l = plot(timeline * 1000, vl(:,1), "LineWidth", 1);
% p_gn_l = plot(timeline * 1000, gn(:,1), "LineWidth", 1);
% p_ct_l = plot(timeline * 1000, ct(:,1), "LineWidth", 1);

% Plot right leg muscles
% p_ip_r = plot(timeline * 1000, ip(:,2), "LineWidth", 1, "LineStyle", "--");
% p_glu_r = plot(timeline * 1000, glu(:,2), "LineWidth", 1, "LineStyle", "--");
% p_bf_r = plot(timeline * 1000, bf(:,2), "LineWidth", 1, "LineStyle", "--");
% p_smt_r = plot(timeline * 1000, smt(:,2), "LineWidth", 1, "LineStyle", "--");
% p_rf_r = plot(timeline * 1000, rf(:,2), "LineWidth", 1, "LineStyle", "--");
p_vl_r = plot(timeline * 1000, vl(:,2), "LineWidth", 1, "LineStyle", "--");
% p_gn_r = plot(timeline * 1000, gn(:,2), "LineWidth", 1, "LineStyle", "--");
% p_ct_r = plot(timeline * 1000, ct(:,2), "LineWidth", 1, "LineStyle", "--");

% Set the same colors
% p_ip_r.Color = p_ip_l.Color;
% p_glu_r.Color = p_glu_l.Color;
% p_bf_r.Color = p_bf_l.Color;
% p_smt_r.Color = p_smt_l.Color;
% p_rf_r.Color = p_rf_l.Color;
p_vl_r.Color = p_vl_l.Color;
% p_gn_r.Color = p_gn_l.Color;
% p_ct_r.Color = p_ct_l.Color;




