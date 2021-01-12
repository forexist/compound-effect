//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

double Takeprofit=10;
double Stoploss=3;

#include <Trade\Trade.mqh>
CTrade trade;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   int  RandomNumber;
   double Ask,Bid; 
   int Spread; 

   
  Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK); 
  Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
  Spread=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD); 
   
 
    RandomNumber = MathRand()%100;

  
   { 
   
    if(RandomNumber <=49 ) 
    {
        trade.Sell(0.1,NULL,Bid,Bid+Stoploss,Bid-Takeprofit,NULL);
     

    }
    if(RandomNumber >=50) 
    {
 
      trade.Buy(0.1,NULL,0,Ask-Stoploss,Ask+Takeprofit,NULL);

    }

    }
  
  
  }