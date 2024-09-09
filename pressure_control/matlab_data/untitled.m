figure;
plot(air_pressure_MPa, contraction_ratio_pressurize, 'b-o');
hold on;
plot(air_pressure_MPa, contraction_ratio_depressurize, 'r-o');
xlabel('Pressure[Mpa]');
ylabel('Contraction Ratio');