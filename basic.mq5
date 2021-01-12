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
            );
            
            

// A ends here.

// D Send random buy and sell orders

   MqlTradeRequest buy_request;
   MqlTradeRequest sell_request;
   MqlTradeResult myresult;
   ZeroMemory(buy_request);
   ZeroMemory(sell_request);

// buy specification

   buy_request.action = TRADE_ACTION_DEAL;
   buy_request.type = ORDER_TYPE_BUY;
   buy_request.tp = 0;
   buy_request.deviation = 50;
   buy_request.symbol = _Symbol;
   buy_request.volume = 0.1;
   buy_request.type_filling = ORDER_FILLING_FOK;
   buy_request.price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

// sell specification

   sell_request.action            = TRADE_ACTION_DEAL;
   sell_request.type              = ORDER_TYPE_SELL ;
   sell_request.tp                = 0;
   sell_request.deviation         = 50;
   sell_request.symbol            = _Symbol;
   sell_request.volume            = 0.1;
   sell_request.type_filling      = ORDER_FILLING_FOK;
   sell_request.price             = SymbolInfoDouble(_Symbol,SYMBOL_BID);



      if (!PositionSelect(_Symbol) && random_number_buy_sell() == "INSTANT_SELL" ) 
         OrderSend(sell_request,myresult);
      else if (!PositionSelect(_Symbol) && random_number_buy_sell() == "INSTANT_BUY")
         OrderSend(buy_request,myresult);



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
      int random_number = MathRand()%2;
      if (random_number == 0) return("INSTANT_SELL");
      else return("INSTANT_BUY");
}
