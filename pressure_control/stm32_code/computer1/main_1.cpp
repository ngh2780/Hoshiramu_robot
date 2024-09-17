#include <mbed.h>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>

// PWM port numbers for each muscle
PwmOut IP(D2), GLU(D3), BF(D4), SMT(D5), RF(D6), VL(D7), GN(D8), CT(D10);

// Constants
const int CHANNEL_NUMBER = 8;
const int NUM_ELEM = 16;
const int NUM_ELEM_VL_AND_CT = NUM_ELEM + 1;
const double PWM_FREQUENCY = 50000.0;
const double TIMELINE_EXTENSION_FACTOR = 1.0;
const double FIRST_SECTION_END_POINT = 1833.1077;
const double MAX_DUTY_RATIO = 0.5;

// Muscle names
const std::string MUSCLE_NAME[CHANNEL_NUMBER] = {"IP", "GLU", "BF", "SMT", "RF", "VL", "GN", "CT"};

// Global variables
Ticker ticker_IP, ticker_GLU, ticker_BF, ticker_SMT, ticker_RF, ticker_VL, ticker_GN, ticker_CT;
double duty_GN = 0, duty_CT = 0, duty_IP = 0, duty_GLU = 0, duty_BF = 0, duty_SMT = 0, duty_RF = 0, duty_VL = 0;
int counter_GN = 0, counter_CT = 0, counter_IP = 0, counter_GLU = 0, counter_BF = 0, counter_SMT = 0, counter_RF = 0, counter_VL = 0;

// Arrays to store data from CSV files
std::vector<std::vector<double>> time_points(CHANNEL_NUMBER);
std::vector<std::vector<double>> pressures(CHANNEL_NUMBER);
std::vector<std::vector<double>> intervals(CHANNEL_NUMBER);

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

// Control functions
void control_IP()
{
    duty_IP = pressures[0][counter_IP] / MAX_DUTY_RATIO; // Convert to duty ratio
    IP.period(1 / PWM_FREQUENCY);
    IP.pulsewidth(1 / PWM_FREQUENCY * duty_IP);
    if (counter_IP == pressures[0].size() - 1) {
        counter_IP = pressures[0].size() - 8; // Return to the start of the second cycle
        ticker_IP.attach(&control_IP, intervals[0][counter_IP] / 1000); // Set next interrupt time
    } else {
        counter_IP++;
        ticker_IP.attach(&control_IP, intervals[0][counter_IP] / 1000);
    }
}

void control_GLU()
{
    duty_GLU = pressures[1][counter_GLU] / MAX_DUTY_RATIO; // Convert to duty ratio
    GLU.period(1 / PWM_FREQUENCY);
    GLU.pulsewidth(1 / PWM_FREQUENCY * duty_GLU);
    if (counter_GLU == pressures[1].size() - 1) {
        counter_GLU = pressures[1].size() - 8; // Return to the start of the second cycle
        ticker_GLU.attach(&control_GLU, intervals[1][counter_GLU] / 1000); // Set next interrupt time
    } else {
        counter_GLU++;
        ticker_GLU.attach(&control_GLU, intervals[1][counter_GLU] / 1000);
    }
}

void control_BF()
{
    duty_BF = pressures[2][counter_BF] / MAX_DUTY_RATIO; // Convert to duty ratio
    BF.period(1 / PWM_FREQUENCY);
    BF.pulsewidth(1 / PWM_FREQUENCY * duty_BF);
    if (counter_BF == pressures[2].size() - 1) {
        counter_BF = pressures[2].size() - 8; // Return to the start of the second cycle
        ticker_BF.attach(&control_BF, intervals[2][counter_BF] / 1000); // Set next interrupt time
    } else {
        counter_BF++;
        ticker_BF.attach(&control_BF, intervals[2][counter_BF] / 1000);
    }
}

void control_SMT()
{
    duty_SMT = pressures[3][counter_SMT] / MAX_DUTY_RATIO; // Convert to duty ratio
    SMT.period(1 / PWM_FREQUENCY);
    SMT.pulsewidth(1 / PWM_FREQUENCY * duty_SMT);
    if (counter_SMT == pressures[3].size() - 1) {
        counter_SMT = pressures[3].size() - 8; // Return to the start of the second cycle
        ticker_SMT.attach(&control_SMT, intervals[3][counter_SMT] / 1000); // Set next interrupt time
    } else {
        counter_SMT++;
        ticker_SMT.attach(&control_SMT, intervals[3][counter_SMT] / 1000);
    }
}

void control_RF()
{
    duty_RF = pressures[4][counter_RF] / MAX_DUTY_RATIO; // Convert to duty ratio
    RF.period(1 / PWM_FREQUENCY);
    RF.pulsewidth(1 / PWM_FREQUENCY * duty_RF);
    if (counter_RF == pressures[4].size() - 1) {
        counter_RF = pressures[4].size() - 8; // Return to the start of the second cycle
        ticker_RF.attach(&control_RF, intervals[4][counter_RF] / 1000); // Set next interrupt time
    } else {
        counter_RF++;
        ticker_RF.attach(&control_RF, intervals[4][counter_RF] / 1000);
    }
}

void control_VL()
{
    duty_VL = pressures[5][counter_VL] / MAX_DUTY_RATIO; // Convert to duty ratio
    VL.period(1 / PWM_FREQUENCY);
    VL.pulsewidth(1 / PWM_FREQUENCY * duty_VL);
    if (counter_VL == pressures[5].size() - 1) {
        counter_VL = pressures[5].size() - 8; // Return to the start of the second cycle
        intervals[5][counter_VL] = time_points[5][counter_VL] - FIRST_SECTION_END_POINT * TIMELINE_EXTENSION_FACTOR;
        ticker_VL.attach(&control_VL, intervals[5][counter_VL] / 1000); // Set next interrupt time
    } else {
        counter_VL++;
        ticker_VL.attach(&control_VL, intervals[5][counter_VL] / 1000);
    }
}

void control_GN()
{
    duty_GN = pressures[6][counter_GN] / MAX_DUTY_RATIO; // Convert to duty ratio
    GN.period(1 / PWM_FREQUENCY);
    GN.pulsewidth(1 / PWM_FREQUENCY * duty_GN);
    if (counter_GN == pressures[6].size() - 1) {
        counter_GN = pressures[6].size() - 8; // Return to the start of the second cycle
        ticker_GN.attach(&control_GN, intervals[6][counter_GN] / 1000); // Set next interrupt time
    } else {
        counter_GN++;
        ticker_GN.attach(&control_GN, intervals[6][counter_GN] / 1000);
    }
}

void control_CT()
{
    duty_CT = pressures[7][counter_CT] / MAX_DUTY_RATIO; // Convert to duty ratio
    CT.period(1 / PWM_FREQUENCY);
    CT.pulsewidth(1 / PWM_FREQUENCY * duty_CT);
    if (counter_CT == pressures[7].size() - 1) {
        counter_CT = pressures[7].size() - 8; // Return to the start of the second cycle
        intervals[5][counter_CT] = time_points[7][counter_CT] - FIRST_SECTION_END_POINT * TIMELINE_EXTENSION_FACTOR;
        ticker_CT.attach(&control_CT, intervals[7][counter_CT] / 1000); // Set next interrupt time
    } else {
        counter_CT++;
        ticker_CT.attach(&control_CT, intervals[7][counter_CT] / 1000);
    }
}

int main() {
    // Load data from CSV files
    for (int i = 0; i < CHANNEL_NUMBER; ++i) {
        std::string filename = MUSCLE_NAME[i] + ".csv";
        time_points[i] = load_csv(filename, 0);
        pressures[i] = load_csv(filename, 1);
        
        // Apply TIMELINE_EXTENSION_FACTOR to time_points
        for (size_t j = 0; j < time_points[i].size(); ++j) {
            time_points[i][j] *= TIMELINE_EXTENSION_FACTOR;
        }
        
        // Calculate intervals
        intervals[i].resize(time_points[i].size());
        for (size_t j = 1; j < time_points[i].size(); ++j) {
            intervals[i][j] = time_points[i][j] - time_points[i][j-1];
        }
        intervals[i][0] = 0;
    }

    // Set up PWM
    IP.period(1.0 / PWM_FREQUENCY);
    GLU.period(1.0 / PWM_FREQUENCY);
    BF.period(1.0 / PWM_FREQUENCY);
    SMT.period(1.0 / PWM_FREQUENCY);
    RF.period(1.0 / PWM_FREQUENCY);
    VL.period(1.0 / PWM_FREQUENCY);
    GN.period(1.0 / PWM_FREQUENCY);
    CT.period(1.0 / PWM_FREQUENCY);

    // Set up tickers with 10-second initial delay
    ticker_IP.attach(&control_IP, 10.0);
    ticker_GLU.attach(&control_GLU, 10.0);
    ticker_BF.attach(&control_BF, 10.0);
    ticker_SMT.attach(&control_SMT, 10.0);
    ticker_RF.attach(&control_RF, 10.0);
    ticker_VL.attach(&control_VL, 10.0);
    ticker_GN.attach(&control_GN, 10.0);
    ticker_CT.attach(&control_CT, 10.0);

    while (1) {
        // Main loop
    }
}