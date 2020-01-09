//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BearsPower_EURUSD_M1_Params : Stg_BearsPower_Params {
  Stg_BearsPower_EURUSD_M1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M1;
    BearsPower_Period = 13;
    BearsPower_Applied_Price = 1;
    BearsPower_Shift = 0;
    BearsPower_TrailingStopMethod = 0;
    BearsPower_TrailingProfitMethod = 0;
    BearsPower_SignalOpenLevel = 0;
    BearsPower_SignalBaseMethod = 0;
    BearsPower_SignalOpenMethod1 = 0;
    BearsPower_SignalOpenMethod2 = 0;
    BearsPower_SignalCloseLevel = 0;
    BearsPower_SignalCloseMethod1 = 0;
    BearsPower_SignalCloseMethod2 = 0;
    BearsPower_MaxSpread = 0;
  }
};
