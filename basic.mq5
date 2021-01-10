#include <Trade\Trade.mqh>

CTrade DoTrade;

void OnTick()
{

// A Display Information.

// B How many open positions for this particualr current chart 
   int      how_many_positions_are_open_for_this_symbol = 0; 
   for (int i = PositionsTotal()-1 ; i>=0; i--)
   {
   string this_chart_symbol = PositionGetSymbol(i);
   string this_chart_symbol_buy = 
   if (Symbol() == this_chart_symbol) how_many_positions_are_open_for_this_symbol+=1;
   
   } // for ends here.
   
// B ends here. 
   
   double   accountBALANCE  = AccountInfoDouble(ACCOUNT_BALANCE);
   double   accountPROFIT   = AccountInfoDouble(ACCOUNT_PROFIT);
   double   accountEQUITY   = AccountInfoDouble(ACCOUNT_EQUITY);
   int      accountLEVERAGE = AccountInfoInteger(ACCOUNT_LEVERAGE);
   
   
   Comment("account balance=> ", accountBALANCE, "\n", "account profit=> ", accountPROFIT, "\n",
           "account equity=> ", accountEQUITY, "\n", "Leverage=> ", accountLEVERAGE, "\n", "How many open positions for this symbol=> ", how_many_positions_are_open_for_this_symbol);

// A ends here.

}