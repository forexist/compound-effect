#include <Trade\Trade.mqh>

CTrade  trade; 


void OnTick()
{

double accountBALANCE = AccountInfoDouble(ACCOUNT_BALANCE);
double accountEQUITY =AccountInfoDouble(ACCOUNT_EQUITY);
double bidPRICE = NormalizeDouble( SymbolInfoDouble (_Symbol,SYMBOL_BID),_Digits );
Comment("B=> ", accountBALANCE, "\n","Totoal positions=> ", PositionsTotal());



if (accountEQUITY >= accountBALANCE) 
trade.Sell (0.01,NULL,bidPRICE,0,(bidPRICE-100*_Point),NULL);
}