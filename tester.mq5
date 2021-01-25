#include <Trade\Trade.mqh>


CTrade trade;

void OnTick ()

{
      double ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
      if(PositionsTotal()<20) trade.Sell(0.01,_Symbol,ask,0,0,TimeToString(TimeCurrent()));
           
      time_of_position();
}



void time_of_position()
{



      
     //for (int i = PositionsTotal()-1;i>=0;i--)

     //{    
         string symbol = PositionGetSymbol(18);
         if(PositionSelect(symbol))
         {
              if (PositionGetInteger(POSITION_TICKET) == 2) trade.PositionClose(PositionGetInteger(POSITION_TICKET));
              Comment( 
              "ticket ",PositionGetInteger(POSITION_TICKET),"\n",
              "id ",PositionGetInteger(POSITION_IDENTIFIER),"\n",
              "time ",PositionGetInteger(POSITION_TIME),"\n",
              "time in mili ",PositionGetInteger(POSITION_TIME_MSC),"\n",
              "type ",PositionGetInteger(POSITION_TYPE),"\n",
              "magic ",PositionGetInteger(POSITION_MAGIC),"\n",
              "magic ",PositionGetString(POSITION_COMMENT),"\n"); 
         }
         
      //}
      
    }