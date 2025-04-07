clc; clear; close all;

% Arm Lengths
L1 = 0.151;  % Length of first arm (m)
L2 = 1.6525;  % Length of second arm (m)

% Define yaw angles in steps of 5° (-90° to 90°)
yaw_angles = -90:5:90;
num_cases = length(yaw_angles);

% Time parameters
dt = 0.05; % Time step
t_max = 10; % Total simulation time
t = 0:dt:t_max;

% Define second arm motion (Pitch from 0° to -90°)
theta2 = 90 * (0.5 * (1 - cos(2 * pi * t / t_max))); % Motion over time

% Initialize arrays to store all end-effector paths
all_path_x = zeros(num_cases, length(t));
all_path_y = zeros(num_cases, length(t));
all_path_z = zeros(num_cases, length(t));

% Calculate motion for each fixed first arm angle
for j = 1:num_cases
    yaw_fixed = deg2rad(yaw_angles(j)); % Convert yaw angle to radians

    for i = 1:length(t)
        % Convert pitch angle to radians
        pitch = deg2rad(theta2(i));

        % First Arm (Fixed Horizontal Rotation - Yaw)
        x1 = L1 * cos(yaw_fixed);
        y1 = L1 * sin(yaw_fixed);
        z1 = 0; % Base remains at (0,0,0)

        % Second Arm (Rotating from 0° to -90°)
        x2 = x1 + L2 * cos(pitch) * cos(yaw_fixed);
        y2 = y1 + L2 * cos(pitch) * sin(yaw_fixed);
        z2 = z1 - L2 * sin(pitch); % Moves downward

        % Store the end-effector position
        all_path_x(j, i) = x2;
        all_path_y(j, i) = y2;
        all_path_z(j, i) = z2;
    end
end

% Setup figure for multiple plots
figure;
set(gcf, 'Position', [100, 100, 1600, 600]);

% --- 3D Motion of End Effector Paths ---
subplot(1, 3, 1);
hold on;
for j = 1:num_cases
    plot3(all_path_x(j, :), all_path_y(j, :), all_path_z(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
title('3D End Effector Paths for Different Yaw Angles');
grid on;
axis equal;
xlim([-2 2]); ylim([-2 2]); zlim([-2 2]);
view(45, 30);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');

% --- XZ Plane Motion (Pitch) ---
subplot(1, 3, 2);
hold on;
for j = 1:num_cases
    plot(all_path_x(j, :), all_path_z(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Z-axis');
title('XZ Plane Motion (Pitch Only)');
grid on;
axis equal;
xlim([-2 2]); ylim([-2 2]);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');

% --- XY Plane Motion (Yaw Fixed) ---
subplot(1, 3, 3);
hold on;
for j = 1:num_cases
    plot(all_path_x(j, :), all_path_y(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Y-axis');
title('XY Plane Motion (Yaw Fixed)');
grid on;
axis equal;
xlim([-2 2]); ylim([-2 2]);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');

