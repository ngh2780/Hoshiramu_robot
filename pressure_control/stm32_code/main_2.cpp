#include <mbed.h>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>

// Constants
const int CHANNEL_NUMBER = 8;
const double PWM_FREQUENCY = 50000.0;
const double TIMELINE_EXTENSION_FACTOR = 1.0;
const double FIRST_SECTION_END_POINT = 1833.1077;
const double MAX_DUTY_RATIO = 0.5;
const double INITIAL_DELAY = 10.0;

// Muscle names and corresponding PWM pins
const std::pair<std::string, PinName> MUSCLES[CHANNEL_NUMBER] = {
    {"IP", D2}, {"GLU", D3}, {"BF", D4}, {"SMT", D5},
    {"RF", D6}, {"VL", D7}, {"GN", D8}, {"CT", D10}
};

// Global variables (to maintain original functionality)
PwmOut *pwm_outputs[CHANNEL_NUMBER];
Ticker tickers[CHANNEL_NUMBER];
std::vector<std::vector<double>> time_points(CHANNEL_NUMBER);
std::vector<std::vector<double>> pressures(CHANNEL_NUMBER);
std::vector<std::vector<double>> intervals(CHANNEL_NUMBER);
double duty_ratios[CHANNEL_NUMBER] = {0};
int counters[CHANNEL_NUMBER] = {0};

// Function to load data from CSV file
std::vector<double> load_csv(const std::string& filename, int row_to_extract) {
    std::vector<double> data;
    std::ifstream file(filename);
    
    if (file.is_open()) {
        std::string line;
        for (int i = 0; i <= row_to_extract; ++i) {
            std::getline(file, line);
        }
        
        std::stringstream ss(line);
        std::string value;
        std::getline(ss, value, '\t'); // Skip first column
        
        while (std::getline(ss, value, '\t')) {
            data.push_back(std::stod(value));
        }
        
        file.close();
    } else {
        printf("Unable to open file: %s\n", filename.c_str());
    }
    
    return data;
}

// Control functions for each muscle
void control_IP() {
    duty_ratios[0] = pressures[0][counters[0]] / MAX_DUTY_RATIO;
    pwm_outputs[0]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[0]);
    if (counters[0] == pressures[0].size() - 1) {
        counters[0] = pressures[0].size() - 8;
    } else {
        ++counters[0];
    }
    tickers[0].attach(&control_IP, intervals[0][counters[0]] / 1000.0);
}

void control_GLU() {
    duty_ratios[1] = pressures[1][counters[1]] / MAX_DUTY_RATIO;
    pwm_outputs[1]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[1]);
    if (counters[1] == pressures[1].size() - 1) {
        counters[1] = pressures[1].size() - 8;
    } else {
        ++counters[1];
    }
    tickers[1].attach(&control_GLU, intervals[1][counters[1]] / 1000.0);
}

void control_BF() {
    duty_ratios[2] = pressures[2][counters[2]] / MAX_DUTY_RATIO;
    pwm_outputs[2]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[2]);
    if (counters[2] == pressures[2].size() - 1) {
        counters[2] = pressures[2].size() - 8;
    } else {
        ++counters[2];
    }
    tickers[2].attach(&control_BF, intervals[2][counters[2]] / 1000.0);
}

void control_SMT() {
    duty_ratios[3] = pressures[3][counters[3]] / MAX_DUTY_RATIO;
    pwm_outputs[3]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[3]);
    if (counters[3] == pressures[3].size() - 1) {
        counters[3] = pressures[3].size() - 8;
    } else {
        ++counters[3];
    }
    tickers[3].attach(&control_SMT, intervals[3][counters[3]] / 1000.0);
}

void control_RF() {
    duty_ratios[4] = pressures[4][counters[4]] / MAX_DUTY_RATIO;
    pwm_outputs[4]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[4]);
    if (counters[4] == pressures[4].size() - 1) {
        counters[4] = pressures[4].size() - 8;
    } else {
        ++counters[4];
    }
    tickers[4].attach(&control_RF, intervals[4][counters[4]] / 1000.0);
}

void control_VL() {
    duty_ratios[5] = pressures[5][counters[5]] / MAX_DUTY_RATIO;
    pwm_outputs[5]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[5]);
    if (counters[5] == pressures[5].size() - 1) {
        counters[5] = pressures[5].size() - 8;
        intervals[5][counters[5]] = time_points[5][counters[5]] - FIRST_SECTION_END_POINT * TIMELINE_EXTENSION_FACTOR;
    } else {
        ++counters[5];
    }
    tickers[5].attach(&control_VL, intervals[5][counters[5]] / 1000.0);
}

void control_GN() {
    duty_ratios[6] = pressures[6][counters[6]] / MAX_DUTY_RATIO;
    pwm_outputs[6]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[6]);
    if (counters[6] == pressures[6].size() - 1) {
        counters[6] = pressures[6].size() - 8;
    } else {
        ++counters[6];
    }
    tickers[6].attach(&control_GN, intervals[6][counters[6]] / 1000.0);
}

void control_CT() {
    duty_ratios[7] = pressures[7][counters[7]] / MAX_DUTY_RATIO;
    pwm_outputs[7]->pulsewidth(1.0 / PWM_FREQUENCY * duty_ratios[7]);
    if (counters[7] == pressures[7].size() - 1) {
        counters[7] = pressures[7].size() - 8;
        intervals[5][counters[7]] = time_points[7][counters[7]] - FIRST_SECTION_END_POINT * TIMELINE_EXTENSION_FACTOR;
    } else {
        ++counters[7];
    }
    tickers[7].attach(&control_CT, intervals[7][counters[7]] / 1000.0);
}

int main() {
    // Initialize PWM outputs
    for (int i = 0; i < CHANNEL_NUMBER; ++i) {
        pwm_outputs[i] = new PwmOut(MUSCLES[i].second);
        pwm_outputs[i]->period(1.0 / PWM_FREQUENCY);
    }

    // Load data from CSV files
    for (int i = 0; i < CHANNEL_NUMBER; ++i) {
        std::string filename = MUSCLES[i].first + ".csv";
        time_points[i] = load_csv(filename, 0);
        pressures[i] = load_csv(filename, 1);
        
        // Apply TIMELINE_EXTENSION_FACTOR to time_points
        for (double& time : time_points[i]) {
            time *= TIMELINE_EXTENSION_FACTOR;
        }
        
        // Calculate intervals
        intervals[i].resize(time_points[i].size());
        for (size_t j = 1; j < time_points[i].size(); ++j) {
            intervals[i][j] = time_points[i][j] - time_points[i][j-1];
        }
        intervals[i][0] = 0;
    }

    // Set up tickers with initial delay
    tickers[0].attach(&control_IP, INITIAL_DELAY);
    tickers[1].attach(&control_GLU, INITIAL_DELAY);
    tickers[2].attach(&control_BF, INITIAL_DELAY);
    tickers[3].attach(&control_SMT, INITIAL_DELAY);
    tickers[4].attach(&control_RF, INITIAL_DELAY);
    tickers[5].attach(&control_VL, INITIAL_DELAY);
    tickers[6].attach(&control_GN, INITIAL_DELAY);
    tickers[7].attach(&control_CT, INITIAL_DELAY);

    while (1) {
        // Main loop
    }

    // Clean up (this part will never be reached in an embedded system)
    for (int i = 0; i < CHANNEL_NUMBER; ++i) {
        delete pwm_outputs[i];
    }
}