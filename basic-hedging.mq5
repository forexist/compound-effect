#include <Trade\Trade.mqh>

input double TP_percent_for_OPT = 30; // Take profit percentage
input double SL_percent_for_OPT = 10; // Stop lose percentage
input double maximum_equity_allowed = 0.9; // Equity alocator Maximum = 1 & Minimum = 0
input double VOL_percent_for_OPT = 0.01; // Size of orders
input int    retrospective_reform_days = 7; // Hedge after how many days
input double    hedge_profit_percentage_close = 0; // Hedge function closes position upon this amount of profit
// input int    hedge_lose_percentage_action = 0; // A reversed position would be open upon this amount of lose
input int trailing_SL = 5; // Trailing Stop Percentage

CTrade my_trade;


void OnTick()
{

// A Display Information.

// B How many open positions for this particualr current chart 
   int      how_many_positions_are_open_for_this_symbol = 0; 
   for (int i = PositionsTotal()-1 ; i>=0; i--)
   {
   
   string this_chart_symbol = PositionGetSymbol(i);
   // here you should add some code to count sell and buy positions as well. 
   if (Symbol() == this_chart_symbol) how_many_positions_are_open_for_this_symbol+=1;
   
   } // for ends here.
   
// B ends here. 
   
// C Calculate hidden swap fees. Hint: This benefits you when trading. Sometimes its value is in your favor and positive.
   double   long_position_swap = SymbolInfoDouble(Symbol(),SYMBOL_SWAP_LONG);
   double   short_position_swap = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_SHORT);
// C ends here.   
   double   accountBALANCE  = AccountInfoDouble(ACCOUNT_BALANCE);
   double   accountPROFIT   = AccountInfoDouble(ACCOUNT_PROFIT);
   double   accountEQUITY   = AccountInfoDouble(ACCOUNT_EQUITY);
   int      accountLEVERAGE = AccountInfoInteger(ACCOUNT_LEVERAGE);
   int      sym_spread      = SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
   double   min_balance     = VOL_percent_for_OPT*100000/accountLEVERAGE;
   
  /* 
   Comment("account balance=> ", accountBALANCE, "\n", 
           "account profit=> ", accountPROFIT, "\n",
           "account equity=> ", accountEQUITY, "\n", 
           "Leverage=> ", accountLEVERAGE, "\n", 
           "How many open positions for this symbol=> ", how_many_positions_are_open_for_this_symbol,"\n", 
           "Hidden Long Swap=>", long_position_swap , "\n", 
           "Hidden Short Swap=> ", short_position_swap,"\n"
           "Symbol Spread=> ", sym_spread,"\n"
           "How many candels so far=> ", candel_counter(), "\n"
            );
            
            
*/

// A ends here.

// D Send random buy and sell orders

   MqlTradeRequest buy_request;
   MqlTradeRequest sell_request;
   MqlTradeResult myresult;
   ZeroMemory(buy_request);
   ZeroMemory(sell_request);

   // buy specification

   // formula of profit or lose ===> percentage = ((v2-v1)/v1)*100
   
   
   
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   
   double TP_Percentage = TP_percent_for_OPT; // for instance 30 mean 30 percentage or 30% of profit on the opened position.
   double SL_Percentage = SL_percent_for_OPT; // for instance 10 mean -10 percentage or -10% of losage on the opened position.
   
   double Price_at_take_profit_BUY_ORDER_double = ((TP_Percentage * ask)/(accountLEVERAGE*100))+ask;
   double Price_at_stop_loss_BUY_ORDER_double   = ((-1 *SL_Percentage * ask)/(accountLEVERAGE*100))+ask;
   
   double Price_at_take_profit_SELL_ORDER_double = ((-1*TP_Percentage * bid)/(accountLEVERAGE*100))+bid;
   double Price_at_stop_loss_SELL_ORDER_double   = ((SL_Percentage * bid)/(accountLEVERAGE*100))+bid;
   
    
   // int TP = 1000;
   // int SL = 300;
   
   
   buy_request.action             = TRADE_ACTION_DEAL;
   buy_request.type               = ORDER_TYPE_BUY;
   buy_request.tp                 = Price_at_take_profit_BUY_ORDER_double; // ask + TP * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   buy_request.sl                 = Price_at_stop_loss_BUY_ORDER_double; // ask - SL * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT); 
   buy_request.deviation          = 50;
   buy_request.symbol             = _Symbol;
   buy_request.volume             = VOL_percent_for_OPT;
   buy_request.type_filling       = ORDER_FILLING_FOK;
   buy_request.price              = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   buy_request.comment            = IntegerToString(candel_counter());
   

// sell specification

   sell_request.action            = TRADE_ACTION_DEAL;
   sell_request.type              = ORDER_TYPE_SELL ;
   sell_request.tp                = Price_at_take_profit_SELL_ORDER_double; // bid - TP * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   sell_request.sl                = Price_at_stop_loss_SELL_ORDER_double; // bid + SL * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT); 
   sell_request.deviation         = 50;
   sell_request.symbol            = _Symbol;
   sell_request.volume            = VOL_percent_for_OPT;
   sell_request.type_filling      = ORDER_FILLING_FOK;
   sell_request.price             = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   sell_request.comment           = IntegerToString(candel_counter());


// Placing orders occur HERE ** ** ** **
// ************************* ** ** ** *
// ************************ ** ** ** *
// *********************** ** ** ** *
 
      static double max_equity_so_far;
      if (max_equity_so_far < accountEQUITY) max_equity_so_far = accountEQUITY;
      
      /*
      
      Comment(
      "eq_max = ", max_equity_so_far, "\n",
      "eq= ", accountEQUITY
      );
      
      */
      
      // Order Management
      
      MqlRates priceDATA2 [];
      ArraySetAsSeries(priceDATA2,true);
      CopyRates(_Symbol,_Period,0,3,priceDATA2);
      static int candel___counter;
      
      static datetime time_stamp_last_check2;
 
      datetime time_stamp_current_candel2;
 
      time_stamp_current_candel2 = priceDATA2[0].time;
      
      if (time_stamp_current_candel2 != time_stamp_last_check2) 
      {
         time_stamp_last_check2 = time_stamp_current_candel2;
         candel___counter++;   
        
         int delta_time_lag = candel___counter-retrospective_reform_days;
         
         if (delta_time_lag >1)
         {
               string symbol = PositionGetSymbol(delta_time_lag); 
               if(PositionSelect(symbol)) // ONLY ORDERS THAT ARE BEHIND AND STILL OPEN SINCE SPECIFIC DAYS AGO.
                     {
                           if (PositionGetDouble(POSITION_PROFIT) > 0) trade.PositionClose(PositionGetInteger(POSITION_TICKET));
                           if (PositionGetDouble(POSITION_PROFIT) <= 0) 
                           {
                                 
                           }
                           if (PositionGetInteger(POSITION_TICKET) == delta_time_lag) 
                           {
                                 
                           }
              Comment( 
              "ticket ",PositionGetInteger(POSITION_TICKET),"\n",
              "id ",PositionGetInteger(POSITION_IDENTIFIER),"\n",
              "Opened time ",PositionGetInteger(POSITION_TIME),"\n",
              "magic ",PositionGetString(POSITION_COMMENT),"\n"); 
         }
         }
         
         
         
                        if (random_number_buy_sell() == "INSTANT_SELL" && accountEQUITY > maximum_equity_allowed * max_equity_so_far) 
                              {
                                 OrderSend(sell_request,myresult);
                              }
          
                        else if (random_number_buy_sell() == "INSTANT_BUY" && accountEQUITY > maximum_equity_allowed * max_equity_so_far)
      
                              {
                                 OrderSend(buy_request,myresult);
                              }      
      }
      
      
      
      
      
      
      
      
      
      /* 
      
      THE FOLLOWING BLOCK OF CODE TRADES ONLY WHEN A PREVIOUSLY OPENED POSITION MEETS ITS STOP-LOSS OR TAKE-PROFIT.
      THE ABOVE BLOCK OF CODE, TRADES WHENEVER A NEW CANLED IS AVAILABLE. 
      
      if (!PositionSelect(_Symbol) && random_number_buy_sell() == "INSTANT_SELL" ) 
         OrderSend(sell_request,myresult);
      else if (!PositionSelect(_Symbol) && random_number_buy_sell() == "INSTANT_BUY")
         OrderSend(buy_request,myresult);
      
      */ 
      
} // end of onTick function.

// The following function has no application for the basic idea. However, I am writing it because we may need it later.
      void close_all_open_positions()
      {
            int i = PositionsTotal()-1;
            while (i>=0) 
            {
            if (my_trade.PositionClose(PositionGetSymbol(i))) i--;
            }
      } // close_all_open_positions function ends here.


// random number generator
// THIS IS THE MAIN BRAIN OF THE ALGORITHM :)))))
string random_number_buy_sell()
{
      MathSrand(GetTickCount());
      int random_number = MathRand()%200;
      if (random_number >= 101) return("INSTANT_SELL");
      if (random_number < 101 ) return("INSTANT_BUY");
      return "error";
}




void check_trailing_stop (double ask, int SL)
{
      double SLPercentage = NormalizeDouble((100-SL)*ask,_Digits);
      for (int i = PositionsTotal()-1;i>=0;i--)
      {
         
         string symbol = PositionGetSymbol(i);
         if (_Symbol==symbol)
         {
            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            double current_stop_lose = PositionGetDouble(POSITION_SL);
            
            if (current_stop_lose  < SLPercentage)
            {
                  my_trade.PositionModify(positionticket,current_stop_lose+10*_Point,0);
            }
            
         }
         
         
      }
}






int candel_counter ()
{

      MqlRates priceDATA [];
      ArraySetAsSeries(priceDATA,true);
      CopyRates(_Symbol,_Period,0,3,priceDATA);
      static int candel__counter;
      static datetime time_stamp_last_chech;
      datetime time_stamp_current_candel;
      time_stamp_current_candel = priceDATA[0].time;
 
      if (time_stamp_current_candel != time_stamp_last_chech)
      {
         time_stamp_last_chech = time_stamp_current_candel;
         candel__counter++;
      }
      return candel__counter;
}




/*
      double a_t_r_()
         {
               double my_price_array [];
               int atr_definition = iATR (_Symbol,_Period,1000);
               ArraySetAsSeries(my_price_array,true);
               CopyBuffer(atr_definition,0,0,3,my_price_array);
               double ATR_Value = NormalizeDouble(my_price_array[0],2);
               return ATR_Value;
         }
         
*/         


