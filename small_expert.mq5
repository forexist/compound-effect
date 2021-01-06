#include <Trade\Trade.mqh>

void OnTick()
{
double myaccountBALANCE = AccountInfoDouble(ACCOUNT_BALANCE);
double myaccountPROFIT = AccountInfoDouble(ACCOUNT_PROFIT);
double myaccountEQUITY = AccountInfoDouble(ACCOUNT_EQUITY);

Comment("account balance=> ", myaccountBALANCE, "\n" , "account profit=> ", myaccountPROFIT, "\n" , 
"account equity=> ", myaccountEQUITY);

}