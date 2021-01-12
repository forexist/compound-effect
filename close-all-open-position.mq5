#include <Trade\Trade.mqh>

CTrade my_trade;

void OnStart()

{

int i = PositionsTotal()-1;

   while (i>=0) {
      if (my_trade.PositionClose(PositionGetSymbol(i))) i--;
   }


}