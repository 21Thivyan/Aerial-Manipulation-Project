clc; clear; close all;

% Arm Lengths
L1 = 1.51;  % Length of first arm (m)
L2 = 16.525;  % Length of second arm (m)
L2m= L2 + 7.58; %modified L2

% Define yaw angles in steps of 5° (-90° to 90°)
yaw_angles = -90:5:90;
num_cases = length(yaw_angles);

% Time parameters
dt = 0.5; % Time step
t_max = 10; % Total simulation time
t = 0:dt:t_max;

% Define colors for different lines
colors = jet(num_cases);

% Initialize arrays to store all end-effector paths
all_path_x = zeros(num_cases, length(t));
all_path_y = zeros(num_cases, length(t));
all_path_z = zeros(num_cases, length(t));

% Calculate motion for each fixed first arm angle
for j = 1:num_cases
    yaw_fixed = deg2rad(yaw_angles(j)); % Convert yaw angle to radians
    
    % Smooth transition of second arm movement at yaw boundary (-30, 30)
    transition_factor = max(0, min(1, (30 - abs(yaw_angles(j))) / 10));
    
    % Compute theta2 range with smooth blending
    theta2_min = (1 - transition_factor) * 60 + transition_factor * 0;
    theta2_max = (1 - transition_factor) * 120 + transition_factor * 180;
    theta2 = -(theta2_min + (theta2_max - theta2_min) * (0.5 * (1 - cos(2 * pi * t / t_max))));
    
    for i = 1:length(t)
        % Convert pitch angle to radians
        pitch = deg2rad(theta2(i));

        % First Arm (Fixed Horizontal Rotation - Yaw)
        x1 = L1 * cos(yaw_fixed);
        y1 = L1 * sin(yaw_fixed);
        z1 = 0; % Base remains at (0,0,0)

        % Second Arm (Rotating)
        x2 = x1 + L2m * cos(pitch) * cos(yaw_fixed);
        y2 = y1 + L2m * cos(pitch) * sin(yaw_fixed);
        z2 = z1 + L2m * sin(pitch); % Corrected direction

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
    plot3(all_path_x(j, :), all_path_y(j, :), all_path_z(j, :), 'Color', colors(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
title('3D End Effector Paths for Different Yaw Angles');
grid on;
axis equal;
xlim([-30 30]); ylim([-30 30]); zlim([-30 30]);
view(45, 30);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');

% --- XZ Plane Motion (Pitch) ---
subplot(1, 3, 2);
hold on;
for j = 1:num_cases
    plot(all_path_x(j, :), all_path_z(j, :), 'Color', colors(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Z-axis');
title('XZ Plane Motion (Pitch Only)');
grid on;
axis equal;
xlim([-30 30]); ylim([-30 30]);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');

% --- XY Plane Motion (Yaw Fixed) ---
subplot(1, 3, 3);
hold on;
for j = 1:num_cases
    plot(all_path_x(j, :), all_path_y(j, :), 'Color', colors(j, :), 'LineWidth', 1.5);
end
xlabel('X-axis'); ylabel('Y-axis');
title('XY Plane Motion (Yaw Fixed)');
grid on;
axis equal;
xlim([-30 30]); ylim([-30 30]);
legend(arrayfun(@(x) sprintf('Yaw %d°', x), yaw_angles, 'UniformOutput', false), 'Location', 'northeastoutside');