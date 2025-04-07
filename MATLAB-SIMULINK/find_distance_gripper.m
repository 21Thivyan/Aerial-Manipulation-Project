%working gripper Final!

clc; clear; close all;

% Link Lengths (in centimeters)
L0 = 2.1;   % Ground Link
L1 = 3;     % Input Link
L2 = 2.2;   % Coupler Link
L3 = 3;     % Output Link
L_ext = 3.055; % Extended bar length from right end of L2
ext_angle = 30; % Angle of the extended bar from L2 (counterclockwise)
hook_length = 0.497; % Hook length
hook_angle = -90; % Hook angle relative to extension

% Rotation angle for whole system (clockwise)
rotation_angle = -25.3; % Negative for clockwise rotation

% Input Angle Range (Driving Link Motion) - Limited to 29.2° to 89.2°
theta2 = 29.2:2:57.2; % Driving Link Motion Range

% Define new origins for the gripper fractions
origin_shift = [0; 1.41]; % Set origin at (0,1.41) for the original fraction
mirrored_origin_shift = [0; -1.41]; % Set origin at (0,-1.41) for the mirrored fraction

% Rotation Matrix (for whole system rotation)
R = [cosd(rotation_angle), -sind(rotation_angle); 
     sind(rotation_angle),  cosd(rotation_angle)];

% Store P positions for trajectory plotting
P1_positions = [];
P2_positions = [];
P1_positions_mirror = [];
P2_positions_mirror = [];
P2_distance = [];
P2_O_distance = [];

om3 = zeros(1, length(theta2));  % Angular velocity of θ₃
om4 = zeros(1, length(theta2));  % Angular velocity of θ₄

distance_offset = 2.82; % Vertical distance between original and mirrored parts

figure(1);
for i = 1:length(theta2)
    
    % Position Analysis using Cosine Rule (Ensures Lengths Remain Fixed)
    AC = sqrt(L0^2 + L1^2 - 2 * L0 * L1 * cosd(theta2(i)));
    beta = acosd((L0^2 + AC^2 - L1^2) / (2 * L0 * AC));
    psi = acosd((L2^2 + AC^2 - L3^2) / (2 * L2 * AC));
    lambda = acosd((L3^2 + AC^2 - L2^2) / (2 * L3 * AC));

    theta3 = psi - beta;
    theta4 = 180 - lambda - beta;

    % Define Joint Positions (Before Rotation)
    Ox = [0; 0] + origin_shift; % Fixed Ground Point
    Cx = [L0; 0] + origin_shift; % Fixed Ground Point
    
    Ax = Ox + [L1 * cosd(theta2(i)); L1 * sind(theta2(i))];
    Bx = Ax + [L2 * cosd(theta3); L2 * sind(theta3)];
    
    % Define Extended Bar from Right End of L2 (B Point)
    P1 = Bx + [L_ext * cosd(theta3 + ext_angle); L_ext * sind(theta3 + ext_angle)];
    
    % Define Hook End
    P2 = P1 + [hook_length * cosd(theta3 + ext_angle + hook_angle); hook_length * sind(theta3 + ext_angle + hook_angle)];
    
    % Apply Rotation Matrix to all points
    P1_rot = R * P1;
    P2_rot = R * P2;
    Ox_rot = R * Ox;
    Ax_rot = R * Ax;
    Bx_rot = R * Bx;
    Cx_rot = R * Cx;
    
    % Mirroring the system at y = 0 with vertical offset
    Ox_mirror = [Ox_rot(1); -Ox_rot(2)];
    Ax_mirror = [Ax_rot(1); -Ax_rot(2)];
    Bx_mirror = [Bx_rot(1); -Bx_rot(2)];
    Cx_mirror = [Cx_rot(1); -Cx_rot(2)];
    P1_mirror = [P1_rot(1); -P1_rot(2)];
    P2_mirror = [P2_rot(1); -P2_rot(2)];
    
    % Calculate Distance Between P2 and O in (x, y) format
    P2_O_dist = P2_rot - Ox_rot;
    P2_O_distance = [P2_O_distance; P2_O_dist'];
    
    % Plot the Original and Mirrored 4-Bar Mechanism
    plot([Ox_rot(1) Ax_rot(1)], [Ox_rot(2) Ax_rot(2)], 'r', 'LineWidth', 3);
    hold on;
    plot([Ax_rot(1) Bx_rot(1)], [Ax_rot(2) Bx_rot(2)], 'b', 'LineWidth', 3);
    plot([Bx_rot(1) Cx_rot(1)], [Bx_rot(2) Cx_rot(2)], 'g', 'LineWidth', 3);
    plot([Ox_rot(1) Cx_rot(1)], [Ox_rot(2) Cx_rot(2)], 'k', 'LineWidth', 3);
    plot([Bx_rot(1) P1_rot(1)], [Bx_rot(2) P1_rot(2)], 'm', 'LineWidth', 2);
    plot([P1_rot(1) P2_rot(1)], [P1_rot(2) P2_rot(2)], 'c', 'LineWidth', 2);
    
    plot([Ox_mirror(1) Ax_mirror(1)], [Ox_mirror(2) Ax_mirror(2)], 'r', 'LineWidth', 3);
    plot([Ax_mirror(1) Bx_mirror(1)], [Ax_mirror(2) Bx_mirror(2)], 'b', 'LineWidth', 3);
    plot([Bx_mirror(1) Cx_mirror(1)], [Bx_mirror(2) Cx_mirror(2)], 'g', 'LineWidth', 3);
    plot([Ox_mirror(1) Cx_mirror(1)], [Ox_mirror(2) Cx_mirror(2)], 'k', 'LineWidth', 3);
    plot([Bx_mirror(1) P1_mirror(1)], [Bx_mirror(2) P1_mirror(2)], 'm', 'LineWidth', 2);
    plot([P1_mirror(1) P2_mirror(1)], [P1_mirror(2) P2_mirror(2)], 'c', 'LineWidth', 2);
    
    grid on;
    axis equal;
    title('Four-Bar Linkage with Mirrored Gripper and Hooks');
    xlabel('X-axis');
    ylabel('Y-axis');
    drawnow;
    hold off;
end

% Display P2 to O Distance
disp('Distance Between P2 and O in (x, y) format for each theta2 value:');
disp(P2_O_distance);
