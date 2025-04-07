clc; clear; close all;

% Arm Lengths
L1 = 0.151;  % Length of first arm (m)
L2 = 1.6525;  % Length of second arm (m)

% Get user input for first arm angle
yaw_input = input('Enter the first arm angle (Yaw) in degrees (-90 to 90): ');
yaw_fixed = deg2rad(yaw_input); % Convert to radians

% Ensure input is within valid range
if yaw_input < -90 || yaw_input > 90
    error('Invalid input. Please enter a value between -90 and 90 degrees.');
end

% Time parameters
dt = 0.05; % Time step
t_max = 10; % Total simulation time
t = 0:dt:t_max;

% Define second arm motion (0° to -90° range)
theta2 = 90 * (0.5 * (1 - cos(2 * pi * t / t_max))); % Pitch motion from 0 to -90°

% Initialize arrays to store end-effector path
path_x = zeros(1, length(t));
path_y = zeros(1, length(t));
path_z = zeros(1, length(t));

% Initialize separate motion paths
path_xy_x = zeros(1, length(t)); % XY plane motion
path_xy_y = zeros(1, length(t));

path_xz_x = zeros(1, length(t)); % XZ plane motion
path_xz_z = zeros(1, length(t));

% Setup Figure
figure;
set(gcf, 'Position', [100, 100, 1600, 600]); % Adjust window size

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
    path_x(i) = x2;
    path_y(i) = y2;
    path_z(i) = z2;

    % Store separate motion paths
    path_xy_x(i) = x2; % XY plane motion
    path_xy_y(i) = y2;

    path_xz_x(i) = x2; % XZ plane motion
    path_xz_z(i) = z2;

    % Clear figure for real-time plotting
    clf;

    % Subplot 1: 3D Arm Motion
    subplot(1, 3, 1);
    plot3([0, x1], [0, y1], [0, z1], 'r', 'LineWidth', 3); % First Arm (Fixed)
    hold on;
    plot3([x1, x2], [y1, y2], [z1, z2], 'b', 'LineWidth', 3); % Second Arm (Moving)
    plot3(x2, y2, z2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    
    % Plot base point
    plot3(0, 0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k');

    % Plot trajectory path so far
    plot3(path_x(1:i), path_y(1:i), path_z(1:i), 'g', 'LineWidth', 1.5); % Path trace
    
    % Update title with time
    title(sprintf('3D Arm Motion (Fixed Yaw: %.1f°)\nTime: %.2f sec', yaw_input, t(i)));
    xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
    xlim([-2 2]); ylim([-2 2]); zlim([-2 2]); % Extended limits
    view(45, 30);
    grid on;

    % Subplot 2: XZ Plane Motion (Pitch Only)
    subplot(1, 3, 2);
    plot([0, x1], [0, z1], 'r', 'LineWidth', 3); % First Arm (Fixed)
    hold on;
    plot([x1, x2], [z1, z2], 'b', 'LineWidth', 3); % Second Arm (Moving)
    plot(x2, z2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    plot(0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Base
    title('XZ Plane Motion (Pitch)');
    xlabel('X-axis'); ylabel('Z-axis');
    xlim([-2 2]); ylim([-2 2]);
    grid on;
    axis equal;

    % Subplot 3: XY Plane Motion (Yaw Only)
    subplot(1, 3, 3);
    plot([0, x1], [0, y1], 'r', 'LineWidth', 3); % First Arm (Fixed)
    hold on;
    plot([x1, x2], [y1, y2], 'b', 'LineWidth', 3); % Second Arm (Moving)
    plot(x2, y2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    plot(0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Base
    title('XY Plane Motion (Yaw Fixed)');
    xlabel('X-axis'); ylabel('Y-axis');
    xlim([-2 2]); ylim([-2 2]);
    grid on;
    axis equal;

    % Pause for animation effect
    pause(dt);
end

% Final Plot of Entire 3D Path
figure;
plot3(path_x, path_y, path_z, 'g', 'LineWidth', 2);
hold on;
scatter3(path_x(1), path_y(1), path_z(1), 50, 'r', 'filled'); % Start Point
scatter3(path_x(end), path_y(end), path_z(end), 50, 'b', 'filled'); % End Point
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
title(sprintf('End Effector Path Over Time (Fixed Yaw: %.1f°)', yaw_input));
grid on;
axis equal;
xlim([-2 2]); ylim([-2 2]); zlim([-2 2]); % Extended limits
view(45, 30);
legend('End Effector Path', 'Start', 'End');

% Final Plot of XZ Plane Motion (Pitch)
figure;
plot(path_xz_x, path_xz_z, 'g', 'LineWidth', 2);
hold on;
scatter(path_xz_x(1), path_xz_z(1), 50, 'r', 'filled'); % Start Point
scatter(path_xz_x(end), path_xz_z(end), 50, 'b', 'filled'); % End Point
xlabel('X-axis'); ylabel('Z-axis');
title(sprintf('XZ Plane Motion (Pitch) - Fixed Yaw: %.1f°', yaw_input));
grid on;
axis equal;

% Final Plot of XY Plane Motion
figure;
plot(path_xy_x, path_xy_y, 'g', 'LineWidth', 2);
hold on;
scatter(path_xy_x(1), path_xy_y(1), 50, 'r', 'filled'); % Start Point
scatter(path_xy_x(end), path_xy_y(end), 50, 'b', 'filled'); % End Point
xlabel('X-axis'); ylabel('Y-axis');
title(sprintf('XY Plane Motion - Fixed Yaw: %.1f°', yaw_input));
grid on;
axis equal;
