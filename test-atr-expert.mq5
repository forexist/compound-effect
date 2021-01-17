
void OnTick()
  {
  
   
   Comment(
   
   "atr ",a_t_r_ (14), "\n",
   "ask ",SymbolInfoDouble(_Symbol,SYMBOL_ASK) , "\n",
   "ask + atr ",(SymbolInfoDouble(_Symbol,SYMBOL_ASK) + a_t_r_(14)), "\n",
   "bid ",SymbolInfoDouble(_Symbol,SYMBOL_BID), "\n",
   "price change ",SymbolInfoDouble(_Symbol,SYMBOL_PRICE_CHANGE ), "\n"
   
   
   );
   
  }
//+------------------------------------------------------------------+


 double a_t_r_(int domain)
         {
               double my_price_array [];
               int atr_definition = iATR (_Symbol,_Period, domain);
               
               ArraySetAsSeries(my_price_array,true);
               CopyBuffer(atr_definition,0,1,3,my_price_array);
               double ATR_Value = NormalizeDouble(my_price_array[0],5);
               return ATR_Value;
         }