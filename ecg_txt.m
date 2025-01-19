% Generate synthetic ECG signal
fs = 300; % Sampling rate in Hz
t = 0:1/fs:10; % Time vector for 10 seconds

% Create synthetic ECG signal using a built-in waveform
ecg_signal = 1.5 * sin(2 * pi * 1 * t) + 0.5 * sin(2 * pi * 50 * t); % Sinusoids to simulate heartbeats

% Add random noise
ecg_signal = ecg_signal + 0.2 * randn(size(ecg_signal));

% Save to file
filename = 'ecg_data.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%f\n', ecg_signal);
fclose(fileID);

disp(['Synthetic ECG data saved to ', filename]);
% Load ECG data from the file
ecg_data = load('ecg_data.txt');

% Sampling rate (in Hz)
fs = 300;

% Time vector for plotting
t = (0:length(ecg_data)-1) / fs;

% Plot the raw ECG signal
figure;
plot(t, ecg_data);
xlabel('Time (s)');
ylabel('ECG Signal (mV)');
title('Raw ECG Signal');

% Filter the ECG signal to remove noise
[b, a] = butter(2, [0.5 40] / (fs / 2), 'bandpass');
filtered_ecg = filtfilt(b, a, ecg_data);

% Plot the filtered ECG signal
figure;
plot(t, filtered_ecg);
xlabel('Time (s)');
ylabel('Filtered ECG Signal (mV)');
title('Filtered ECG Signal');

% Compute the derivative of the filtered signal
diff_ecg = diff(filtered_ecg);

% Square the derivative to emphasize the QRS complex
squared_ecg = diff_ecg .^ 2;

% Moving window integration
window_size = round(0.12 * fs);
mwi_ecg = movsum(squared_ecg, window_size);

% Plot the moving window integrated signal
figure;
plot(t(2:end), mwi_ecg);
xlabel('Time (s)');
ylabel('MWI Signal');
title('Moving Window Integrated ECG Signal');

% Define the minimum peak distance (refractory period)
min_peak_distance = round(0.6 * fs);  % 600 ms minimum distance between peaks

% Thresholding to detect R-peaks
threshold = 0.1;  % Manually set the threshold
[~, r_peaks] = findpeaks(mwi_ecg, 'MinPeakHeight', threshold, 'MinPeakDistance', min_peak_distance);

% Plot the R-peaks on the filtered ECG signal
figure;
plot(t, filtered_ecg);
hold on;
plot(r_peaks / fs, filtered_ecg(r_peaks), 'ro');
xlabel('Time (s)');
ylabel('Filtered ECG Signal (mV)');
title('Detected R-peaks on ECG Signal');

% Compute heart rate in beats per minute (BPM)
rr_intervals = diff(r_peaks) / fs;
heart_rate = 60 ./ rr_intervals;

% Plot the heart rate over time
figure;
plot(r_peaks(2:end) / fs, heart_rate);
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
title('Heart Rate Over Time');

% Heart Disease Detection

% Bradycardia Detection
isBradycardia = heart_rate < 60;

% Tachycardia Detection
isTachycardia = heart_rate > 100;

% PVC Detection (Premature Ventricular Contractions)
normalRRInterval = median(rr_intervals);  % Assuming the median RR interval as normal
rr_deviation = abs(rr_intervals - normalRRInterval);
isPVC = rr_deviation > 0.05 & rr_intervals < normalRRInterval;  % Early beats

% Thresholds for significance
bradycardia_threshold = 0.1;  % Percentage of time points where Bradycardia is detected
tachycardia_threshold = 0.1;  % Percentage of time points where Tachycardia is detected
pvc_threshold = 0.05;        % Percentage of time points where PVC is detected

% Calculate percentages
total_points = length(heart_rate);
bradycardia_percentage = sum(isBradycardia) / total_points;
tachycardia_percentage = sum(isTachycardia) / total_points;
pvc_percentage = sum(isPVC) / total_points;

% Determine if conditions are significant
isBradycardiaSignificant = bradycardia_percentage > bradycardia_threshold;
isTachycardiaSignificant = tachycardia_percentage > tachycardia_threshold;
isPVCSignificant = pvc_percentage > pvc_threshold;

% Plot Heart Disease Detection Results
figure;
subplot(3, 1, 1);
plot(r_peaks(2:end) / fs, isBradycardia, 'r*');
xlabel('Time (s)');
ylabel('Bradycardia');
title('Bradycardia Detection (BPM < 60)');

subplot(3, 1, 2);
plot(r_peaks(2:end) / fs, isTachycardia, 'g*');
xlabel('Time (s)');
ylabel('Tachycardia');
title('Tachycardia Detection (BPM > 100)');

subplot(3, 1, 3);
plot(r_peaks(2:end) / fs, isPVC, 'b*');
xlabel('Time (s)');
ylabel('PVCs');
title('PVC Detection (Premature Beats)');

% Display results
disp('Detected R-peaks at indices:');
disp(r_peaks);

disp('RR intervals (in seconds):');
disp(rr_intervals);

disp('Heart Rate (BPM):');
disp(heart_rate);

disp('Bradycardia is significant:');
disp(isBradycardiaSignificant);

disp('Tachycardia is significant:');
disp(isTachycardiaSignificant);

disp('PVCs are significant:');
disp(isPVCSignificant);
