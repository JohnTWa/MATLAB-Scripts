clear

%% Given parameters
V1 = 1.0; % Voltage magnitude at Bus 1 (Slack Bus, assumed to be 1.0 p.u.)
delta_1 = 0;
S2 = -0.6 - 0.3j; % Apparent power demand at Bus 2 in p.u. (negative for load)
Z12 = 0.025 + 0.25j; % Impedance of the line between Bus 1 and Bus 2 in p.u.

%% Setup

% Admittance Matrix
Y12 = 1/Z12;
Ybus = [Y12 Y12*-1; Y12*-1 Y12]; % n by n matrix for n = number of buses
Y21 = -Y12;
Y22 = Ybus(2,2);

% B Matrices
B = imag(Ybus);
B_prime = B(2, 2); 
B_2prime = B_prime; % These are only equal for a network of two buses

% Convergence Criteria

tolerance = 1e-7;
i_max = 100;

% Initial Guess

V2(1) = 1.0;
delta_2(1) = 0;

%% Iterative Process
for i = 1:i_max
    
    % Calculating Active and Reactive Power for Iteration
    P2(i) = abs(V2(i))*abs(V1)*abs(Y21)*cos(angle(Y21)-delta_2(i)+delta_1) ...
        + abs(V2(i))^2*abs(Y22)*cos(angle(Y22));
    Q2(i) = -abs(V2(i))*abs(V1)*abs(Y21)*sin(angle(Y21)-delta_2(i)+delta_1) ...
        - abs(V2(i))^2*abs(Y22)*sin(angle(Y22));
    
    % Calculating Power Discrepancy for Iteration
    d_P2(i) = real(S2) - P2(i);
    d_Q2(i) = imag(S2) - Q2(i);
    
    % Calculating Voltage and Phase Angle Discrepancy using B Matrices and 
    % Active and Reactive Power Discrepancies
    
    d_delta_2(i) = -(B_prime^(-1))*d_P2(i)/abs(V1);
    d_V2(i) = -(B_2prime^(-1))*d_Q2(i)/abs(V1);
    
    % Calculating Voltage and Phase Angle at end of Iteration
    
    delta_2(i+1) = delta_2(i) + d_delta_2(i);
    V2(i+1) = V2(i) + d_V2(i);

    % Checking for Convergence
    if abs(abs(V2(i+1)) - abs(V2(i))) <= tolerance || ...
            abs(abs(delta_2(i+1)) - abs(delta_2(i))) <= tolerance
        break;
    end
end

fprintf("Iterations Performed:");
disp(i);
fprintf("Voltage at Bus 2:");
disp(V2(i+1));
fprintf("Phase Angle at Bus 2:");
disp(delta_2(i+1));