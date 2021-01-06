#include<Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>

//+------------------------------------------------------------------+
//|                                                  Basic-Robot.mq5 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                      https://forexist.github.io/compound-effect/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+




CTrade trade; 

int OnInit()
{

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{


//Alert(random_signal());

}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string trade_or_do_not_trade_that_is_the_question() // OFF or ON?
{

   //if spread is small, not bad times, and all other conditional situations are OK, then
   //DayOfWeekDescription(STime.day_of_week)

   string text="";
   switch(mostafa_time().day_of_week) {
   case  0:
      text= "OFF"; //"Sunday";
      break;
   case  1:
      text= "ON"; //"Monday";
      break;
   case  2:
      text= "ON"; //"Tuesday";
      break;
   case  3:
      text= "ON"; //"Wednesday";
      break;
   case  4:
      text= "ON"; //"Thursday";
      break;
   case  5:
      text= "ON"; //"Friday";
      break;
   case  6:
      text= "OFF"; //"Saturday";
      break;
   default:
      text= "OFF"; //"Another day";
      break;
   }
//---
   return(text);
}





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+




string random_signal()
{

   double random_buy_or_sell = (MathRand()/(32767/2.0));
   if(random_buy_or_sell >=1)
      return("BUY");
   else
      return("SELL");

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MqlDateTime mostafa_time ()
{

// bellow block of code is something for mamaging Broker and Client date and times

   MqlDateTime STime;
   datetime time_current=TimeCurrent();
   datetime time_local=TimeLocal();

   TimeToStruct(time_current,STime);
   // Print ("Time Current ",TimeToString(time_current,TIME_DATE|TIME_SECONDS)," day of week ",DayOfWeekDescription(STime.day_of_week));
   return(STime);


   //TimeToStruct(time_local,STime);
   // Print ("Time Local ",TimeToString(time_local,TIME_DATE|TIME_SECONDS)," day of week ",DayOfWeekDescription(STime.day_of_week));


// end of date annd time concerns!

}

//   string DayOfWeekDescription(const int day_of_week)
//{
//   string text="";
//   switch(day_of_week) {
//   case  0:
//      text="Sunday";
//      break;
//   case  1:
//      text="Monday";
//      break;
//   case  2:
//      text="Tuesday";
//      break;
//   case  3:
//      text="Wednesday";
//      break;
//   case  4:
//      text="Thursday";
//      break;
//   case  5:
//      text="Friday";
//      break;
//   case  6:
//      text="Saturday";
//      break;
//   default:
//      text="Another day";
//      break;
//   }
////---
//   return(text);
//}
//
////+------------------------------------------------------------------+
