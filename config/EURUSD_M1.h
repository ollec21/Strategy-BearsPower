/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_BearsPower_Params_M1 : Indi_BearsPower_Params {
  Indi_BearsPower_Params_M1() : Indi_BearsPower_Params(indi_bears_defaults, PERIOD_M1) {
    applied_price = (ENUM_APPLIED_PRICE)0;
    ma_method = 0;
    period = 14;
    shift = 0;
  }
} indi_bears_m1;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BearsPower_Params_M1 : StgParams {
  // Struct constructor.
  Stg_BearsPower_Params_M1() : StgParams(stg_bears_defaults) {
    lot_size = 0;
    signal_open_method = 0;
    signal_open_filter = 1;
    signal_open_level = (float)0.0;
    signal_open_boost = 0;
    signal_close_method = 2;
    signal_close_level = (float)10.0;
    price_stop_method = 0;
    price_stop_level = (float)10.0;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_bears_m1;
