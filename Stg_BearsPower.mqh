//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BearsPower strategy based on the Bears Power indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_BearsPower.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __BearsPower_Parameters__ = "-- BearsPower strategy params --";  // >>> BEARS POWER <<<
INPUT int BearsPower_Active_Tf = 0;  // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32,H4=64...)
INPUT ENUM_TRAIL_TYPE BearsPower_TrailingStopMethod = 22;         // Trail stop method
INPUT ENUM_TRAIL_TYPE BearsPower_TrailingProfitMethod = 1;        // Trail profit method
INPUT int BearsPower_Period = 13;                                 // Period
INPUT ENUM_APPLIED_PRICE BearsPower_Applied_Price = PRICE_CLOSE;  // Applied Price
INPUT int BearsPower_Shift = 0;                                   // Shift (relative to the current bar, 0 - default)
INPUT double BearsPower_SignalOpenLevel = 0.00000000;             // Signal open level
INPUT int BearsPower_SignalBaseMethod = 0;                        // Signal base method (0-
INPUT int BearsPower_SignalOpenMethod1 = 0;                       // Open condition 1 (0-1023)
INPUT int BearsPower_SignalOpenMethod2 = 0;                       // Open condition 2 (0-)
INPUT double BearsPower_SignalCloseLevel = 0.00000000;            // Signal close level
INPUT ENUM_MARKET_EVENT BearsPower_SignalCloseMethod1 = 0;        // Signal close method 1
INPUT ENUM_MARKET_EVENT BearsPower_SignalCloseMethod2 = 0;        // Signal close method 2
INPUT ENUM_MARKET_EVENT BearsPower_CloseCondition = C_BEARSPOWER_BUY_SELL;  // Close condition
INPUT double BearsPower_MaxSpread = 6.0;                                    // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_BearsPower_Params : Stg_Params {
  unsigned int BearsPower_Period;
  ENUM_APPLIED_PRICE BearsPower_Applied_Price;
  int BearsPower_Shift;
  ENUM_TRAIL_TYPE BearsPower_TrailingStopMethod;
  ENUM_TRAIL_TYPE BearsPower_TrailingProfitMethod;
  double BearsPower_SignalOpenLevel;
  long BearsPower_SignalBaseMethod;
  long BearsPower_SignalOpenMethod1;
  long BearsPower_SignalOpenMethod2;
  double BearsPower_SignalCloseLevel;
  ENUM_MARKET_EVENT BearsPower_SignalCloseMethod1;
  ENUM_MARKET_EVENT BearsPower_SignalCloseMethod2;
  double BearsPower_MaxSpread;

  // Constructor: Set default param values.
  Stg_BearsPower_Params()
      : BearsPower_Period(::BearsPower_Period),
        BearsPower_Applied_Price(::BearsPower_Applied_Price),
        BearsPower_Shift(::BearsPower_Shift),
        BearsPower_TrailingStopMethod(::BearsPower_TrailingStopMethod),
        BearsPower_TrailingProfitMethod(::BearsPower_TrailingProfitMethod),
        BearsPower_SignalOpenLevel(::BearsPower_SignalOpenLevel),
        BearsPower_SignalBaseMethod(::BearsPower_SignalBaseMethod),
        BearsPower_SignalOpenMethod1(::BearsPower_SignalOpenMethod1),
        BearsPower_SignalOpenMethod2(::BearsPower_SignalOpenMethod2),
        BearsPower_SignalCloseLevel(::BearsPower_SignalCloseLevel),
        BearsPower_SignalCloseMethod1(::BearsPower_SignalCloseMethod1),
        BearsPower_SignalCloseMethod2(::BearsPower_SignalCloseMethod2),
        BearsPower_MaxSpread(::BearsPower_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_BearsPower : public Strategy {
 public:
  Stg_BearsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BearsPower *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_BearsPower_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_BearsPower_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_BearsPower_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_BearsPower_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_BearsPower_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_BearsPower_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_BearsPower_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    BearsPower_Params bp_params(_params.BearsPower_Period, _params.BearsPower_Applied_Price);
    IndicatorParams bp_iparams(10, INDI_BEARS);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_BearsPower(bp_params, bp_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.BearsPower_SignalBaseMethod, _params.BearsPower_SignalOpenMethod1,
                       _params.BearsPower_SignalOpenMethod2, _params.BearsPower_SignalCloseMethod1,
                       _params.BearsPower_SignalCloseMethod2, _params.BearsPower_SignalOpenLevel,
                       _params.BearsPower_SignalCloseLevel);
    sparams.SetStops(_params.BearsPower_TrailingProfitMethod, _params.BearsPower_TrailingStopMethod);
    sparams.SetMaxSpread(_params.BearsPower_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_BearsPower(sparams, "BearsPower");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, long _signal_method = EMPTY, double _signal_level = EMPTY) {
    bool _result = false;
    double bears_0 = ((Indi_BearsPower *)this.Data()).GetValue(0);
    double bears_1 = ((Indi_BearsPower *)this.Data()).GetValue(1);
    double bears_2 = ((Indi_BearsPower *)this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level == EMPTY) _signal_level = GetSignalOpenLevel();
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // @todo
        break;
      case ORDER_TYPE_SELL:
        // @todo
        break;
    }
    return _result;
  }

  /**
   * Check strategy's closing signal.
   */
  bool SignalClose(ENUM_ORDER_TYPE _cmd, long _signal_method = EMPTY, double _signal_level = EMPTY) {
    if (_signal_level == EMPTY) _signal_level = GetSignalCloseLevel();
    return SignalOpen(Order::NegateOrderType(_cmd), _signal_method, _signal_level);
  }
};
