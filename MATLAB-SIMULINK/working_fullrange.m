clc; clear; close all;

% Arm Lengths
L1 = 0.151;  % Length of first arm (m)
L2 = 1.6525;  % Length of second arm (m)

% Time parameters
dt = 0.05; % Time step
t_max = 10; % Total simulation time
t = 0:dt:t_max;

% Define angle motion
theta1 = 90 * sin(2 * pi * t / t_max);  % Horizontal rotation (Yaw) [-90° to +90°]
theta2 = 180 * (0.5 * (1 - cos(2 * pi * t / t_max)));  % Vertical rotation (Pitch) [0° to -180° CW]

% Initialize arrays to store end-effector path
path_x = zeros(1, length(t));
path_y = zeros(1, length(t));
path_z = zeros(1, length(t));

% Initialize arrays to store separate motion paths
path_xy_x = zeros(1, length(t)); % For XY plane
path_xy_y = zeros(1, length(t));

path_xz_x = zeros(1, length(t)); % For XZ plane
path_xz_z = zeros(1, length(t));

% Setup Figure
figure;
set(gcf, 'Position', [100, 100, 1200, 600]); % Adjust window size

for i = 1:length(t)
    % Convert angles to radians
    yaw = deg2rad(theta1(i));
    pitch = deg2rad(theta2(i));

    % First Arm (Horizontal Rotation - Yaw)
    x1 = L1 * cos(yaw);
    y1 = L1 * sin(yaw);
    z1 = 0; % Base remains at (0,0,0)

    % Second Arm (Rotates CW from 0° to -180°)
    x2 = x1 + L2 * cos(pitch) * cos(yaw);
    y2 = y1 + L2 * cos(pitch) * sin(yaw);
    z2 = z1 - L2 * sin(pitch); % Moves downward in CW rotation

    % Store the end-effector position
    path_x(i) = x2;
    path_y(i) = y2;
    path_z(i) = z2;

    % Store individual arm motion paths
    path_xy_x(i) = x2; % XY plane motion
    path_xy_y(i) = y2;

    path_xz_x(i) = x2; % XZ plane motion
    path_xz_z(i) = z2;

    % Clear figure for real-time plotting
    clf;

    % Subplot 1: 3D Arm Motion
    subplot(1, 3, 1);
    plot3([0, x1], [0, y1], [0, z1], 'r', 'LineWidth', 3); % First Arm
    hold on;
    plot3([x1, x2], [y1, y2], [z1, z2], 'b', 'LineWidth', 3); % Second Arm
    plot3(x2, y2, z2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    plot3(0, 0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Base
    plot3(path_x(1:i), path_y(1:i), path_z(1:i), 'g', 'LineWidth', 1.5); % Path trace
    title(sprintf('3D Arm Motion\nTime: %.2f sec', t(i)));
    xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
    xlim([-2 2]); ylim([-2 2]); zlim([-2 2]);
    view(45, 30);
    grid on;

    % Subplot 2: First Arm Motion (XY plane - Horizontal Yaw Motion)
    subplot(1, 3, 2);
    plot([0, x1], [0, y1], 'r', 'LineWidth', 3); % First Arm
    hold on;
    plot([x1, x2], [y1, y2], 'b', 'LineWidth', 3); % Second Arm
    plot(x2, y2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    plot(0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Base
    plot(path_xy_x(1:i), path_xy_y(1:i), 'g', 'LineWidth', 1.5); % Path trace
    title('XY Plane Motion (Yaw)');
    xlabel('X-axis'); ylabel('Y-axis');
    xlim([-2 2]); ylim([-2 2]);
    grid on;
    axis equal;

    % Subplot 3: Second Arm Motion (XZ plane - Vertical Pitch Motion)
    subplot(1, 3, 3);
    plot([0, x1], [0, z1], 'r', 'LineWidth', 3); % First Arm
    hold on;
    plot([x1, x2], [z1, z2], 'b', 'LineWidth', 3); % Second Arm
    plot(x2, z2, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % End Effector
    plot(0, 0, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Base
    plot(path_xz_x(1:i), path_xz_z(1:i), 'g', 'LineWidth', 1.5); % Path trace
    title('XZ Plane Motion (Pitch)');
    xlabel('X-axis'); ylabel('Z-axis');
    xlim([-2 2]); ylim([-2 2]);
    grid on;
    axis equal;

    % Pause for animation effect
    pause(dt);
end
