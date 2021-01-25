#include <Trade\Trade.mqh>


CTrade trade;

void OnTick ()

{

   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   if (PositionsTotal()<2)
   trade.Buy(0.01,_Symbol,ask,ask-1000*_Point,ask+500*_Point);
   check_trailing_stop(ask);
   
   
}

void check_trailing_stop (double ask)
{
      double SLPercentage = NormalizeDouble(-150*_Point+ask,_Digits);
      for (int i = PositionsTotal()-1;i>=0;i--)
      {
         
         string symbol = PositionGetSymbol(i);
         
         if (_Symbol==symbol)
         {
            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            double current_stop_lose = PositionGetDouble(POSITION_SL);
            
            if (current_stop_lose  < SLPercentage)
            {
                  trade.PositionModify(positionticket,current_stop_lose+10*_Point,0);
            }
            
         }
         
         
      }
}