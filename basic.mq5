#include <Trade\Trade.mqh>

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
   
   
   double TP_Percentage = 30; // for instance 30 mean 30 percentage or 30% of profit on the opened position.
   double SL_Percentage = 10; // for instance 10 mean -10 percentage or -10% of losage on the opened position.
   
   double Price_at_take_profit_BUY_ORDER_double = ((TP_Percentage * ask)/(accountLEVERAGE*100))+ask;
   double Price_at_stop_loss_BUY_ORDER_double   = ((-1*SL_Percentage * ask)/(accountLEVERAGE*100))+ask;
   
   double Price_at_take_profit_SELL_ORDER_double = ((-1*TP_Percentage * ask)/(accountLEVERAGE*100))+bid;
   double Price_at_stop_loss_SELL_ORDER_double   = ((SL_Percentage * ask)/(accountLEVERAGE*100))+bid;
   
    
   // int TP = 1000;
   // int SL = 300;
   
   
   buy_request.action             = TRADE_ACTION_DEAL;
   buy_request.type               = ORDER_TYPE_BUY;
   buy_request.tp                 = Price_at_take_profit_BUY_ORDER_double; // ask + TP * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   buy_request.sl                 = Price_at_stop_loss_BUY_ORDER_double; // ask - SL * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT); 
   buy_request.deviation          = 50;
   buy_request.symbol             = _Symbol;
   buy_request.volume             = 0.01;
   buy_request.type_filling       = ORDER_FILLING_FOK;
   buy_request.price              = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

// sell specification

   sell_request.action            = TRADE_ACTION_DEAL;
   sell_request.type              = ORDER_TYPE_SELL ;
   sell_request.tp                = Price_at_take_profit_SELL_ORDER_double; // bid - TP * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   sell_request.sl                = Price_at_stop_loss_SELL_ORDER_double; // bid + SL * _Point; //SymbolInfoDouble(_Symbol,SYMBOL_POINT); 
   sell_request.deviation         = 50;
   sell_request.symbol            = _Symbol;
   sell_request.volume            = 0.01;
   sell_request.type_filling      = ORDER_FILLING_FOK;
   sell_request.price             = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   


// Placing orders occur HERE ** ** ** **
// ************************* ** ** ** *
// ************************ ** ** ** *
// *********************** ** ** ** *
 
      
      
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
         
            
            
            
      if (random_number_buy_sell() == "INSTANT_SELL" ) 
          {
            OrderSend(sell_request,myresult);
          }
          
      else if (random_number_buy_sell() == "INSTANT_BUY")
      
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
string random_number_buy_sell()
{
      MathSrand(GetTickCount());
      int random_number = MathRand()%2;
      if (random_number == 0) return("INSTANT_SELL");
      else return("INSTANT_BUY");
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