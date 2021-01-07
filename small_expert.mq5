//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   double myaccountBALANCE = AccountInfoDouble(ACCOUNT_BALANCE);
   double myaccountPROFIT = AccountInfoDouble(ACCOUNT_PROFIT);
   double myaccountEQUITY = AccountInfoDouble(ACCOUNT_EQUITY);

   Comment("account balance=> ", myaccountBALANCE, "\n", "account profit=> ", myaccountPROFIT, "\n",
           "account equity=> ", myaccountEQUITY, "\n", "Leverage=>", AccountInfoInteger(ACCOUNT_LEVERAGE));

// whole below lines are needed to handel a single BUY ORDER.

   MqlTradeRequest myrequest;
   MqlTradeResult myresult;
   ZeroMemory(myrequest);
   myrequest.action = TRADE_ACTION_DEAL;
   myrequest.type = ORDER_TYPE_BUY;
   myrequest.tp = 0;
   myrequest.deviation = 50;
   myrequest.symbol = _Symbol;
   myrequest.volume = 0.1;
   myrequest.type_filling = ORDER_FILLING_FOK;
   myrequest.price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   if (!PositionSelect(_Symbol)) { // check if no position is opened.
      OrderSend(myrequest,myresult);
   }

   if ((myaccountEQUITY - myaccountBALANCE) > 2 ) {
      CloseAllOrders ();
   }

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllOrders ()
{
   CTrade trade;
   int i = PositionsTotal()-1;

   while (i>=0) {
      if (trade.PositionClose(PositionGetSymbol(i))) i--;
   }
}
//+------------------------------------------------------------------+
