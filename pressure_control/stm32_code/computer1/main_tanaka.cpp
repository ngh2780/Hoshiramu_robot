#include "mbed.h" 

PwmOut GN(D8), CT(D10), IP(D2), GLU(D3), BF(D4), SMT(D5), RF(D6), VM(D7);//各筋肉に対応した電空レギュレータへの信号（オペアンプ増幅前）．
RawSerial button(PC_6, PC_7);//D0,D1はデフォルト設定では使えないらしい//一番最初に動くCTが動いたらsecondマイコンに指令を送る．

#define DataNumber 16//データ数
#define DataNumber_CT_VM 17

Ticker ticker_GN, ticker_CT, ticker_IP, ticker_GLU, ticker_BF, ticker_SMT, ticker_RF, ticker_VM;

double f = 50000;//PWMの周波数
double duty_GN = 0, duty_CT = 0, duty_IP = 0, duty_GLU = 0, duty_BF = 0, duty_SMT = 0, duty_RF = 0, duty_VM = 0;//PWMのDuty比
int counter_GN = 0, counter_CT = 0, counter_IP = 0, counter_GLU = 0, counter_BF = 0, counter_SMT = 0, counter_RF = 0, counter_VM = 0;//カウンタ
int count_computer = 0;

//matlabからの二周期分のデータ(時間)
double time_GN[DataNumber] = {0,541.6,1083.2,1499.8,2166.4,2610.8,3055.2,3499.6,3666.2154,4207.8154,4749.4154,5166.0154,5832.6154,6277.0154,6721.4154,7165.8154};//GNの時間割り込み，単位ms
double time_CT[DataNumber_CT_VM] = {0,374.5,749,1499.8,1874.8,2249.8,2666.4,3083,3499.6,4040.7154,4415.2154,5166.0154,5541.0154,5916.0154,6332.6154,6749.2154,7165.8154};//CTの時間割り込み，単位ms
double time_IP[DataNumber] = {0,541.6,1083.2,1566.48,2049.76,2533.04,3016.32,3499.6,3666.2154,4207.8154,4749.4154,5232.6954,5715.9754,6199.2554,6682.5354,7165.8154};//IPの時間割り込み，単位ms
double time_GLU[DataNumber] = {0,541.6,1083.2,1566.48,2049.76,2533.04,3016.32,3499.6,3666.2154,4207.8154,4749.4154,5232.6954,5715.9754,6199.2554,6682.5354,7165.8154};//GLUの時間割り込み，単位ms
double time_BF[DataNumber] = {0,499.9333,999.8667,1499.8,1999.75,2499.7,2999.65,3499.6,3666.2154,4166.1487,4666.0821,5166.0154,5665.9654,6165.9154,6665.8654,7165.8154};//BFの時間割り込み，単位ms
double time_SMT[DataNumber] = {0,499.9333,999.8667,1499.8,1999.75,2499.7,2999.65,3499.6,3666.2154,4166.1487,4666.0821,5166.0154,5665.9654,6165.9154,6665.8654,7165.8154};//SMTの時間割り込み，単位ms
double time_RF[DataNumber] = {0,499.9333,999.8667,1499.8,1999.75,2499.7,2999.65,3499.6,3666.2154,4166.1487,4666.0821,5166.0154,5665.9654,6165.9154,6665.8654,7165.8154};//RFの時間割り込み，単位ms
double time_VM[DataNumber_CT_VM] = {0,208.2923,583.2,1083.2,1583.2,2055.3333,2527.4667,2999.6,3499.6,3874.5077,4249.4154,4749.4154,5249.4154,5721.5487,6193.6821,6665.8154,7165.8154};//VMの時間割り込み，単位ms

//割り込みに使用する時間差
double interval_GN[DataNumber];//GNの時間割り込み，単位ms
double interval_CT[DataNumber_CT_VM];//CTの時間割り込み，単位ms
double interval_IP[DataNumber];//IPの時間割り込み，単位ms
double interval_GLU[DataNumber];//GLUの時間割り込み，単位ms
double interval_BF[DataNumber];//BFの時間割り込み，単位ms
double interval_SMT[DataNumber];//SMTの時間割り込み，単位ms
double interval_RF[DataNumber];//RFの時間割り込み，単位ms
double interval_VM[DataNumber_CT_VM];//VMの時間割り込み，単位ms

//matlabからの二周期分のデータ(圧力)
double pressure_GN[DataNumber] = {0.14,0.115,0.07,0.165,0,0.145,0.17,0.185,0.14,0.115,0.07,0.165,0,0.145,0.17,0.185};//GNの圧力，単位MPa
double pressure_CT[DataNumber_CT_VM] = {0.005,0.015,0.45,0,0.39,0.42,0.075,0.015,0,0.015,0.45,0,0.39,0.42,0.075,0.015,0};//CTの圧力，単位MPa
double pressure_IP[DataNumber] = {0,0.16,0.18,0.105,0.105,0.1,0.08,0,0,0.16,0.18,0.105,0.105,0.1,0.08,0};//IPの圧力，単位MPa
double pressure_GLU[DataNumber] = {0.135,0.055,0,0.1,0.11,0.12,0.145,0.19,0.135,0.055,0,0.1,0.11,0.12,0.145,0.19};//GLUの圧力，単位MPa
double pressure_BF[DataNumber] = {0.225,0.165,0.12,0,0.16,0.18,0.205,0.235,0.225,0.165,0.12,0,0.16,0.18,0.205,0.235};//BFの圧力，単位MPa
double pressure_SMT[DataNumber] = {0.38,0.23,0.125,0,0.16,0.185,0.22,0.285,0.38,0.23,0.125,0,0.16,0.185,0.22,0.285};//SMTの圧力，単位MPa
double pressure_RF[DataNumber] = {0,0.12,0.195,0.4,0.155,0.13,0.1,0.08,0,0.12,0.195,0.4,0.155,0.13,0.1,0.08};//RFの圧力，単位MPa
double pressure_VM[DataNumber_CT_VM] = {0.175,0.105,0,0.17,0.5,0.165,0.14,0.13,0.215,0.105,0,0.17,0.5,0.165,0.14,0.13,0.215};//VMの圧力，単位MPa

void control_GN()
{
    duty_GN = pressure_GN[counter_GN]/0.50;//duty比へ変換
    GN.period(1/f);
    GN.pulsewidth(1/f*duty_GN);
    if (counter_GN == DataNumber-1)
    {
        counter_GN = DataNumber-8;//二周期のスタートに戻る
        ticker_GN.attach(&control_GN, interval_GN[counter_GN]*5/1000);//次の割り込み時間を設定
    }
    else
    {
        counter_GN++;
        ticker_GN.attach(&control_GN, interval_GN[counter_GN]*5/1000);
    }

}

void control_CT()
{
    count_computer = count_computer + 1;
    if(count_computer == 1)
    {
        button.putc('A');
        count_computer = count_computer + 1;
    }
    duty_CT = pressure_CT[counter_CT]/0.50*2;
    CT.period(1/f);
    CT.pulsewidth(1/f*duty_CT);
    if (counter_CT == DataNumber-1)
    {
        counter_CT = DataNumber-8;//二周期のスタートに戻る
        interval_VM[counter_CT] = time_VM[counter_VM]-3666.2154;
        ticker_CT.attach(&control_CT, interval_CT[counter_CT]*5/1000);
    }
    else
    {
        counter_CT++;
        ticker_CT.attach(&control_CT, interval_CT[counter_CT]*5/1000);

    }

}

void control_IP()
{
    duty_IP = pressure_IP[counter_IP]/0.50;
    IP.period(1/f);
    IP.pulsewidth(1/f*duty_IP);
    if (counter_IP == DataNumber-1)
    {
        counter_IP = DataNumber-8;//二周期のスタートに戻る
        ticker_IP.attach(&control_IP, interval_IP[counter_IP]*5/1000);
    }
    else
    {
        counter_IP++;
        ticker_IP.attach(&control_IP, interval_IP[counter_IP]*5/1000);
    }

}

void control_GLU()
{
    duty_GLU = pressure_GLU[counter_GLU]/0.50;
    GLU.period(1/f);
    GLU.pulsewidth(1/f*duty_GLU);
    if (counter_GLU == DataNumber-1)
    {
        counter_GLU = DataNumber-8;//二周期のスタートに戻る
        ticker_GLU.attach(&control_GLU, interval_GLU[counter_GLU]*5/1000);
    }
    else
    {
        counter_GLU++;
        ticker_GLU.attach(&control_GLU, interval_GLU[counter_GLU]*5/1000);
    }

}

void control_BF()
{
    duty_BF = pressure_BF[counter_BF]/0.50;
    BF.period(1/f);
    BF.pulsewidth(1/f*duty_BF);
    if (counter_BF == DataNumber-1)
    {
        counter_BF = DataNumber-8;//二周期のスタートに戻る
        ticker_BF.attach(&control_BF, interval_BF[counter_BF]*5/1000);

    }
    else
    {
        counter_BF++;
        ticker_BF.attach(&control_BF, interval_BF[counter_BF]*5/1000);

    }

}

void control_SMT()
{
    duty_SMT = pressure_SMT[counter_SMT]/0.50;
    SMT.period(1/f);
    SMT.pulsewidth(1/f*duty_SMT);
    if (counter_SMT == DataNumber-1)
    {
        counter_SMT = DataNumber-8;//二周期のスタートに戻る
        ticker_SMT.attach(&control_SMT, interval_SMT[counter_SMT]*5/1000);

    }
    else
    {
        counter_SMT++;
        ticker_SMT.attach(&control_SMT, interval_SMT[counter_SMT]*5/1000);
    }

}

void control_RF()
{
    duty_RF = pressure_RF[counter_RF]/0.50;
    RF.period(1/f);
    RF.pulsewidth(1/f*duty_RF);
    if (counter_RF == DataNumber-1)
    {
        counter_RF = DataNumber-8;//二周期のスタートに戻る
        ticker_RF.attach(&control_RF, interval_RF[counter_RF]*5/1000);
    }
    else
    {
        counter_RF++;
        ticker_RF.attach(&control_RF, interval_RF[counter_RF]*5/1000);
    }

}

void control_VM()
{
    duty_VM = pressure_VM[counter_VM]/0.50;
    VM.period(1/f);
    VM.pulsewidth(1/f*duty_VM);
    if (counter_VM == DataNumber-1)
    {
        counter_VM = DataNumber-8;//二周期のスタートに戻る
        interval_VM[counter_VM] = time_VM[counter_VM]-3666.2154;
        ticker_VM.attach(&control_VM, interval_VM[counter_VM]*5/1000);
    }
    else
    {
        counter_VM++;
        ticker_VM.attach(&control_VM, interval_VM[counter_VM]*5/1000);
    }

}

int main()
{
    button.baud(9600);
    //button.format(8, Serial::None, 1);
    GN.period(1/f);
    GN.pulsewidth(1/f*duty_GN);
    CT.period(1/f);
    CT.pulsewidth(1/f*duty_CT);
    IP.period(1/f);
    IP.pulsewidth(1/f*duty_IP);
    GLU.period(1/f);
    GLU.pulsewidth(1/f*duty_GLU);
    BF.period(1/f);
    BF.pulsewidth(1/f*duty_BF);
    SMT.period(1/f);
    SMT.pulsewidth(1/f*duty_SMT);
    RF.period(1/f);
    RF.pulsewidth(1/f*duty_RF);
    VM.period(1/f);
    VM.pulsewidth(1/f*duty_VM);
    //割り込み周期の設定
    for(int i=0; i < DataNumber-1; i++){
        if(i == 0){
            interval_GN[i] =0;
            interval_CT[i] = 0;
            interval_IP[i] = 0;
            interval_GLU[i] = 0;
            interval_BF[i] = 0;
            interval_SMT[i] = 0;
            interval_RF[i] = 0;
            interval_VM[i] = 0;
            continue;
        }
        interval_GN[i] = time_GN[i] - time_GN[i-1];
        interval_CT[i] = time_CT[i] - time_CT[i-1];
        interval_IP[i] = time_IP[i] - time_IP[i-1];
        interval_GLU[i] = time_GLU[i] - time_GLU[i-1];
        interval_BF[i] = time_BF[i] - time_BF[i-1];
        interval_SMT[i] = time_SMT[i] - time_SMT[i-1];
        interval_RF[i] = time_RF[i] - time_RF[i-1];
        interval_VM[i] = time_VM[i] - time_VM[i-1];
    }
    //スタートして10秒は何も起こらないようにする．
    ticker_GN.attach(&control_GN, interval_GN[counter_VM]*5/1000+10);
    ticker_CT.attach(&control_CT, interval_CT[counter_VM]*5/1000+10);
    ticker_IP.attach(&control_IP, interval_IP[counter_VM]*5/1000+10);
    ticker_GLU.attach(&control_GLU, interval_GLU[counter_VM]*5/1000+10);
    ticker_BF.attach(&control_BF, interval_BF[counter_VM]*5/1000+10);
    ticker_SMT.attach(&control_SMT, interval_SMT[counter_VM]*5/1000+10);
    ticker_RF.attach(&control_RF, interval_RF[counter_VM]*5/1000+10);
    ticker_VM.attach(&control_VM, interval_VM[counter_VM]*5/1000+10);
    while (true) {

    }
}
